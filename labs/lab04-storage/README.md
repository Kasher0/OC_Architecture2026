# Lab 4 — Partition, mirror, fail, recover

Pair: Kazhymurat + Arsen · Driver first half: <name> · Machine: <laptop model, VirtualBox host, Ubuntu guest "ubuntu-server" + Windows guest> · Date: 11 and 13 November 2026 · Hypervisor: VirtualBox

## What I did

### Windows: partition, format, letter

One 1 GB virtual disk (`lab04-win`) added to the Windows guest while it was powered off, then in PowerShell as administrator:

```powershell
Get-Disk
Initialize-Disk -Number 1 -PartitionStyle GPT
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel LAB04
Get-Disk | Select Number, FriendlyName, PartitionStyle, Size
Get-Volume | Where FileSystemLabel -eq 'LAB04'
```

Output of the last two commands:

```
<PASTE the real Get-Disk | Select ... output here>

<PASTE the real Get-Volume | Where ... output here>
```

**MBR or GPT:** I used GPT. Windows 11 boots with UEFI, which uses GPT, so the whole machine is already GPT and one scheme is easier to reason about; GPT also keeps a backup copy of the partition table and checksums it, while MBR is limited to 2 TiB and four primary partitions.

### Linux: three disks, one mirror

Three 1 GB virtual disks (`lab04-d1`, `lab04-d2`, `lab04-d3`) added to the Ubuntu guest while it was powered off, on the same controller as the system disk. They appeared as `sdb`, `sdc`, `sdd`; the system disk is `sda`.

```bash
mkdir -p ~/lab04/evidence && cd ~/lab04
{ echo '$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS'; lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS; } > evidence/lsblk-before.txt

# one RAID partition on each disk
for d in sdb sdc sdd; do
  sudo parted -s /dev/$d mklabel gpt mkpart primary 1MiB 100% set 1 raid on
done

# mirror from two of them
sudo apt install -y mdadm
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
cat /proc/mdstat        # [2/2] [UU]
# -> evidence/array-healthy.txt

# file system, mount, proof file, checksum
sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
sudo chown $USER: /mnt/mirror
echo "Lab 4 proof file - <Kazhymurat and Arsen> - $(date)" > /mnt/mirror/proof.txt
head -c 20M /dev/urandom > /mnt/mirror/random.bin
cd /mnt/mirror
{ echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-before.txt
cd ~/lab04

# fail one disk on purpose
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
# -> evidence/array-degraded.txt   ([2/1] [U_], clean, degraded)

# prove the data survived
cat /mnt/mirror/proof.txt
cd /mnt/mirror
{ echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-after-failure.txt
cd ~/lab04
diff <(tail -n +2 evidence/checksum-before.txt) <(tail -n +2 evidence/checksum-after-failure.txt) && echo "checksums match"

# add the third disk and rebuild
sudo mdadm /dev/md0 --add /dev/sdd1
cat /proc/mdstat        # back to [2/2] [UU], sdd1 instead of sdc1
# -> evidence/array-rebuilt.txt

# keep the mirror after a reboot
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## Result

### Layout before

```
<PASTE the content of evidence/lsblk-before.txt>
```

### Layout after

```
<PASTE the NEW lsblk output taken after remounting, md0 under sdb1 and sdd1, mounted on /mnt/mirror>
```

### Three states

| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | evidence/array-healthy.txt |
| Degraded | [2/1] [U_] | evidence/array-degraded.txt |
| Rebuilt | [2/2] [UU], sdd1 replaced sdc1 | evidence/array-rebuilt.txt |

Checksums before and after the failure: **match** (`checksums match` printed by `diff`; `proof.txt` was also still readable while the array was degraded).

### RAID is not a backup

Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? No: the deletion is written to both disks at the same moment, so the mirror faithfully copies the mistake. RAID protects against a disk dying, not against human error, corruption or ransomware, and only a backup, which is a separate copy from an earlier point in time, lets you get the file back as it was an hour ago.

## What did not work the first time

**What I saw.** After the array was rebuilt I ran `lsblk` and `md0` showed up under `sdb1` and `sdd1`, but its MOUNTPOINTS column was empty. The mirror existed, but `/mnt/mirror` was not mounted, so the proof file and `random.bin` were not visible at that path.

**What it was.** My partner and I did the first and second half of the lab at different times (the evidence files are dated 11 and 13 November), and the virtual machine was shut down in between. I had mounted `md0` by hand with `sudo mount`, which does not survive a shutdown, and I had not put it in `/etc/fstab`. `mdadm --detail --scan` into `mdadm.conf` only saves how to assemble the array, not where to mount it, so after the restart the array came back but the file system was not attached to a folder.

**What I did.** I mounted it again with `sudo mount /dev/md0 /mnt/mirror`, checked that `proof.txt` and `random.bin` were there, ran `sha256sum` on both and compared with `checksum-before.txt` <CONFIRM: they matched>, and only then took the final `lsblk` for "Layout after". Lesson: the array surviving a reboot and the file system being mounted after a reboot are two separate things, and I should check both after any shutdown.

Also: while saving the checksum, a long command I pasted into the terminal got split. The shell showed a `>` prompt and waited for a closing `}`. I pressed Ctrl+C (nothing had been executed) and ran the command again as separate shorter lines.

## Evidence

- `evidence/lsblk-before.txt` — three empty 1 GB disks before anything was touched.
- `evidence/array-healthy.txt` — mirror with two active devices, `[2/2] [UU]`, `State : clean`.
- `evidence/array-degraded.txt` — one disk removed, `[2/1] [U_]`, `State : clean, degraded`.
- `evidence/checksum-before.txt` — SHA-256 of `proof.txt` and `random.bin` while the mirror was healthy.
- `evidence/checksum-after-failure.txt` — the same files while degraded, identical sums, so the data survived.
- `evidence/array-rebuilt.txt` — third disk (`sdd1`) added, `[2/2] [UU]` again, `State : clean`.
