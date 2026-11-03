# BUILD.md — A test machine for the new developer (Ubuntu Server + Windows 11 on one laptop)

**For:** Aigerim. You need a laptop, an internet connection and about 3 hours. You do not need to buy anything.

**What you will have at the end:** two virtual computers ("VMs") inside one laptop — Ubuntu Server (Linux) and Windows 11. They can reach the internet and each other. Each has a clean snapshot, so if the developer breaks something you can go back in a few minutes.

**Words used here**
- **Host** — your real laptop. **Guest** — a virtual computer running inside it.
- **ISO** — one big file that is a copy of an installation disc.
- **Snapshot** — a saved state of a guest that you can return to.

**Why VMs at all:** a guest lives in its own files and has its own memory limit. If the developer ruins Windows inside the guest, the laptop's real Windows and files are untouched, and a snapshot restores the guest.

This guide was built on a laptop with 32 GB RAM and a 1 TB SSD. Numbers for a smaller laptop are in Step 1.

---

## Step 1. Check that the laptop is big enough
Press Ctrl+Shift+Esc → **Performance** → **Memory**. Look at the total. Then look at **Disk** (free space) and the **CPU** tab.

![](screenshots/s01-host-memory.png)

**Why:** two guests share the laptop's memory with the real Windows. Windows 11 needs 4 GB for itself, Ubuntu Server 2 GB, and the host Windows already uses a lot (about 9 GB on my laptop).
**Check:** memory total 32 GB is comfortable (what I used). 16 GB is the lowest I would try — close every other program while the guests run. At least 100 GB of free disk. The CPU tab says **Virtualization: Enabled**. If it says Disabled, it must be switched on in the laptop's BIOS before anything else works.

## Step 2. Download VirtualBox
Go to **virtualbox.org** → Downloads → **Windows hosts** and download the installer.

![](screenshots/s02-virtualbox-download.png)

**Why VirtualBox and not another one:** it is free and works on any Windows edition. Hyper-V is already inside Windows 11 Pro/Enterprise but is missing in Windows Home, so it could fail on Aigerim's laptop. VMware Workstation's licence terms have changed recently and I did not verify them, so I did not risk it for an office.
**Check:** the file is on your computer.

## Step 3. Install VirtualBox
Run the installer and click Next with the default options. **Do not** install the "Extension Pack".

![](screenshots/s03-virtualbox-installed.png)

**Why not the Extension Pack:** we do not need it, and its licence is different from the main program's (free for personal/educational/evaluation use, not for ordinary office use). Skipping it keeps the build free and legal.
**Check:** open VirtualBox → Help → About shows a version number.

## Step 4. Download the Ubuntu Server ISO
Go to **ubuntu.com/download/server** and download the current **LTS** ISO.

![](screenshots/s04-ubuntu-download.png)

**Why Server and LTS:** Server has no desktop, so it is small and fast; a developer works in the terminal anyway. LTS means long support, so the machine stays updatable for years.
**Check:** the .iso file is several GB.

## Step 5. Download the Windows 11 Enterprise evaluation ISO
Go to the **Microsoft Evaluation Center**, find **Windows 11 Enterprise**, choose the **ISO**, fill the short form and download.

![](screenshots/s05-windows-eval-download.png)

**Why the evaluation version:** it is free, needs no product key and is meant for testing. The price is that it expires (mine showed 27 January 2027) and it is not allowed for production work. A retail Windows would cost money, and Aigerim must not buy anything by mistake. When it expires, build a fresh VM from a new ISO and keep the developer's code outside the VM.
**Check:** the Windows .iso is several GB.

## Step 6. Create the network the two guests will share
In VirtualBox: **Tools → Network** (some versions: File → Tools → Network Manager) → **NAT Networks** → Create. The name I used is **NatNetwork**.

![](screenshots/s06-nat-network.png)

**Why a NAT Network:** plain NAT gives each guest its own private network, so the two guests cannot see each other. Bridged puts them on the office network, where a MAC-filtering or managed network may refuse them and the test machines become visible to everyone. Host-only has no internet. A NAT Network gives internet *and* lets the guests see each other.
**Check:** NatNetwork appears in the list.

## Step 7. Create the Ubuntu VM
VirtualBox → **Machine → New**. Name `ubuntu-server`, pick the Ubuntu ISO, type Linux / Ubuntu (64-bit). Memory **2048 MB**, **2** processors, disk **25 GB** (leave "Pre-allocate Full Size" unticked).

![](screenshots/s07-ubuntu-wizard.png)

**Why:** a server without a desktop is fine with 2 GB. A non-pre-allocated (dynamic) disk is a file that grows only as it fills, so 25 GB does not take 25 GB on day one.
**Check:** the VM appears in the left list.

## Step 8. Install Ubuntu Server
Select the VM → **Start**. In the installer keep the defaults. Choose a server name, a username and a password, and **write them down**. When it asks to reboot, do so.

![](screenshots/s08-ubuntu-installer.png)

**Why defaults:** the installer's defaults are correct for a plain test server; changing things we do not need only creates problems.
**Check:** after reboot you see a login prompt and can log in.

## Step 9. Save proof of the Ubuntu version
In the Ubuntu terminal run:
```
{ echo '$ uname -a'; uname -a; echo; echo '$ lsb_release -a'; lsb_release -a; } > 04-guest-uname.txt
cat 04-guest-uname.txt
```
Copy the file out of the VM into the `evidence/` folder of this project.

**Why:** the file has the command line and the real output, so it proves which system is running.
**Check:** `cat` shows the Ubuntu version and a kernel line.
*Evidence: [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt)*

## Step 10. Create the Windows VM
**Machine → New**. Name `VM2`, pick the Windows ISO, type Microsoft Windows / Windows 11 (64-bit). Tick **Skip Unattended Installation**. Memory **4096 MB**, **2** processors, disk **64 GB** (dynamic).

![](evidence/01-new-vm-wizard.png)
![](evidence/02-disk-settings.png)

Then **Settings → System → Motherboard**: tick **Enable EFI**, set **TPM** to **2.0**, and make sure **Secure Boot** is enabled (the option appears once EFI is on).

**Why:** Windows 11 will not install without UEFI, Secure Boot and TPM 2.0, and Microsoft's minimums are 4 GB RAM, 2 cores and 64 GB disk. Dynamic disk again so it starts small.
**Check:** Settings → System shows 4096 MB, EFI, TPM 2.0. In Settings → Storage the disk shows its virtual size (64 GB) — that screenshot is `02-disk-settings.png`.
*Evidence: [01-new-vm-wizard.png](evidence/01-new-vm-wizard.png), [02-disk-settings.png](evidence/02-disk-settings.png)*

## Step 11. Install Windows 11
Select the VM → **Start**. In my case VirtualBox installed Windows by itself (it rebooted a few times and went to the desktop with the account `vboxuser`) even though "Skip Unattended Installation" was ticked. Just wait.

![](screenshots/s11-windows-desktop.png)

**Why I mention it:** you may expect installer screens that never come. This is normal.
**Check:** press Win+R, type `winver`, Enter. It says **Windows 11 Enterprise Evaluation**.

![](screenshots/s11-winver.png)

## Step 12. Put both guests on the same network
For **each** VM: **Settings → Network → Adapter 1 → Attached to: NAT Network**, name **NatNetwork**. Restart both guests afterwards.

![](evidence/03-network-adapter.png)

**Why:** see Step 6. Both guests must use the same NAT Network name, otherwise they are on different networks.
**Check:** the screenshot shows "NAT Network" and the name.
*Evidence: [evidence/03-network-adapter.png](evidence/03-network-adapter.png)*

## Step 13. Find the address of each guest
Ubuntu: run `ip addr` and find the `inet` line. Windows: open Command Prompt, run `ipconfig`.

![](screenshots/s13-ip-ubuntu.png)
![](screenshots/s13-ip-windows.png)

**Why:** you need the other guest's address for the ping test.
**Check:** both addresses start the same way, like `10.0.2.x`, and they are different from each other. Mine were Ubuntu `10.0.2.3` and Windows `10.0.2.4`; yours may differ, use your own.

## Step 14. Let Windows answer a ping
In Windows open **PowerShell as administrator** and run **one command on one line**:
```
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```

![](screenshots/s14-firewall-rule.png)

**Why:** by default the Windows firewall blocks incoming ping, so Ubuntu would see "100% packet loss" even though the network is fine. Allowing only ping (not everything) keeps the firewall otherwise strict.
**Check:** PowerShell prints the new rule with `Enabled : True`, `Action : Allow`. If you pasted it as two lines and got an error, you may have an empty duplicate rule with the same name — remove it with `Remove-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)"` and run the command again.

## Step 15. Install `ping` on Ubuntu
In Ubuntu run:
```
sudo apt update
sudo apt install -y iputils-ping
```

![](screenshots/s15-apt-ping.png)

**Why:** the minimal Ubuntu Server image does not include `ping` ("command not found"). This needs the internet, which also checks that Ubuntu is online.
**Check:** `ping -c 2 ubuntu.com` gets replies.

## Step 16. Run the network tests and save the output
Run these four tests, one after another, and put the output of all of them, **unedited and with each command line**, into one file:
1. Ubuntu → Windows: `ping -c 4 <Windows address>`
2. Ubuntu → internet: `ping -c 4 ubuntu.com`
3. Windows → Ubuntu: `ping <Ubuntu address>`
4. Windows → internet: `ping ubuntu.com`

Save as `evidence/05-ping-between-guests.txt`.

**Why:** two directions prove the guests really see each other; the internet tests prove the NAT Network works for both.
**Check:** every test shows 0% loss.
*Evidence: [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt)*

## Step 17. Take a clean snapshot of each guest
Shut down both guests. For each: select it → **Snapshots** tab → **Take**. Name it `clean-baseline`.

![](evidence/06-snapshot-list.png)

**Why:** a snapshot of a switched-off guest is clean (no half-saved state) and is the "undo" button for the whole machine. A snapshot is not a backup — it lives in the same place as the VM, so if the laptop dies it dies with it.
**Check:** the Snapshots tab lists `clean-baseline`.
*Evidence: [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png)*

## Step 18. How to go back to the clean state
Shut the guest down → **Snapshots** tab → right-click `clean-baseline` → **Restore**. VirtualBox offers to save the current state first — choose yes if you might want it, no if you want it gone.

**Check:** the guest boots as it was at the snapshot; anything installed after it is gone.

---

## When something goes wrong

| What you see | Why | What to do |
|---|---|---|
| Windows setup says "This PC can't run Windows 11" | EFI, TPM 2.0 or Secure Boot is off | Step 10, Settings → System; enable all three |
| VirtualBox says it cannot start a 64-bit guest | virtualization is off in BIOS | Step 1; switch it on in BIOS |
| `ping` from Ubuntu to Windows: 100% packet loss | Windows firewall blocks incoming ping | Step 14 |
| `ping: command not found` on Ubuntu | minimal server image | Step 15 |
| Guests cannot reach each other | different network settings | Step 12; both must use the same NAT Network name |
| Desktop watermark says the Windows licence is expired | seen right after my install, while `slmgr /xpr` (run in `cscript`) showed expiry on 27 Jan 2027; I did not find out why | the VM worked normally; check the expiry date with `slmgr /xpr` |
| Cannot copy text between laptop and guest | shared clipboard needs Guest Additions, which I did not install | copy files out through SSH, or install Guest Additions first |
