# Ticket 1 — New developer starts Monday, needs a test machine

## 1. What was asked

> <<ВСТАВЬ ТОЧНЫЙ ТЕКСТ ЗАПРОСА ИЗ ТИКЕТА, дословно, как цитату>>

## 2. What was actually needed

The request is short and sounds simple, but almost every part of it hides a decision that only I can make, because Aigerim is not an IT person and cannot judge it.

**What the request left out**
- *Which operating systems.* "A test machine" is singular. A developer's code usually has to be tested on at least Windows and Linux, so one VM is not enough.
- *What "nothing special" means.* For a developer it is not "nothing". It means: plain operating systems with no special hardware, no company software, but with internet and a way to undo mistakes.
- *Breaking what?* "Without breaking anything" can mean the laptop, the VM, or the office network. Each needs a different protection (see below).
- *How much memory and disk the host has.* My resource numbers depend on it. The request does not say.
- *Internet, and whether the two guests see each other.* Not said. It decides the network mode.
- *Which hypervisor, which licence, which ISO,* and whether it is free and legal in an office. Not said.
- *Who follows the instructions.* Aigerim, who is not IT. Every step must work for her.

**Where the request is wrong or dangerous**
- Treating it as one VM is wrong: it needs two guests (Ubuntu Server and Windows 11 Enterprise evaluation) that can see each other.
- "Without breaking anything" is not a wish, it is a requirement for isolation (guest files are separate from the laptop), recovery (snapshots) and network safety (NAT Network, not Bridged).
- "Free" is not automatic. VirtualBox's Extension Pack has a different licence from the main program, and the Windows evaluation ISO is not for production use. A wrong choice could make Aigerim buy or break a licence by mistake.

**What I would have asked Aigerim, and what I assumed instead**

| Question I would ask | What I assumed |
|---|---|
| Which operating systems does the developer need? | Windows 11 and Linux (Ubuntu Server), one guest each |
| What does "nothing special" mean? | No special hardware, no domain join, no company software; plain OS, internet, undo |
| Breaking *what*? | The laptop (VM isolation), the VM (snapshot), the network (NAT Network) |
| How much memory and disk on the laptop? | Like mine: 32 GB RAM, 1 TB SSD (numbers in section 3) |
| Internet needed? Guests see each other? | Yes to both |
| Which hypervisor, licence, ISO? | VirtualBox without Extension Pack, Ubuntu Server LTS, Windows 11 Enterprise evaluation — all free |
| Who reads the document? | Aigerim, not IT: numbered steps, a picture, a reason and a check for each step |

## 3. What I did

I reused the two VMs and the screenshots from Lab 1 and Lab 2 where they show exactly what is needed, and renamed them as the brief requires. Full click-by-click instructions are in [BUILD.md](BUILD.md). In order:

1. Checked the host: 32 GB RAM (Windows shows 31.2 GB usable), 16-core / 32-thread CPU, 1 TB SSD.
2. Installed VirtualBox without the Extension Pack.
3. Downloaded Ubuntu Server LTS and the Windows 11 Enterprise evaluation ISO.
4. Created the Ubuntu VM and installed it; `uname -a` and `lsb_release -a` are in the evidence folder.
5. Created the Windows VM with EFI, Secure Boot and TPM 2.0 and installed it.
6. Put both guests on one NAT Network called `NatNetwork`; they got `10.0.2.3` (Ubuntu) and `10.0.2.4` (Windows).
7. Fixed the ping problem (see "What went wrong").
8. Ran ping both ways and to the internet.
9. Took a clean snapshot of each guest.

Commands I used:
```
# Windows, PowerShell as administrator (let ping in)
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow

# Ubuntu (install ping, then test)
sudo apt update
sudo apt install -y iputils-ping
ping -c 4 10.0.2.4
```

### Settings that differ from the default

| Setting | Default | Mine | Why |
|---|---|---|---|
| Windows VM memory | <<из мастера>> | 4096 MB | 4 GB is Microsoft's minimum for Windows 11 |
| Windows VM processors | <<из мастера>> | 2 | 2 cores is the Windows 11 minimum |
| Windows VM disk | <<из мастера>> | 64 GB, dynamic | 64 GB is the Windows 11 minimum; dynamic so the file grows only as used |
| EFI (Windows VM) | <<из мастера>> | on | Windows 11 needs UEFI |
| Secure Boot (Windows VM) | <<из мастера>> | on | required by Windows 11 |
| TPM (Windows VM) | <<из мастера>> | 2.0 | required by Windows 11 |
| Skip Unattended Installation | off | on | I wanted to see the installer; VirtualBox installed unattended anyway |
| Ubuntu VM memory / processors / disk | <<из мастера>> | 2048 MB / 2 / 25 GB dynamic | server without desktop needs little |
| Network adapter (both guests) | NAT | NAT Network `NatNetwork` | plain NAT would keep the guests apart |

### Resources, calculated from my real host

- Installed: 32 GB (2 x 16 GB); Windows shows **31.2 GB** usable.
- The host Windows itself already used about **9 GB** before I started any VM (my Lab 2 measurement).
- Guests: Windows 4 GB + Ubuntu 2 GB = **6 GB**.
- 9 + 6 = **15 GB** used, **16.2 GB** (about half) left as headroom. VirtualBox adds some overhead per VM that I did not measure.
- To check the limit I tested in Lab 2 with 20 GB for each guest: host memory in use rose to 27.2 GB of 31.2 GB, committed memory was 34.5 of 35.2 GB, and the laptop did not freeze. So the 6 GB I chose is far from the edge.
- CPU: 2 + 2 virtual processors out of 32 threads. Disk: at most 25 + 64 = **89 GB** of the 1 TB SSD, and much less at the start because the disks are dynamic.

### Decisions and alternatives

| Decision | Alternatives considered | Trade-off |
|---|---|---|
| VirtualBox | Hyper-V; VMware Workstation | Hyper-V is missing in Windows Home. I did not verify VMware's current licence terms, so I avoided it. VirtualBox is free and runs everywhere, but its Extension Pack has a non-free licence, so I skipped it |
| NAT Network | NAT; Bridged; Host-only | NAT: guests cannot see each other. Bridged: guests appear on the office network, which can filter them. Host-only: no internet. NAT Network gives both |
| Windows 11 Enterprise evaluation | a retail Windows | The evaluation is free and legal for testing, but it expires (mine: 27 Jan 2027) and is not for production. Retail costs money |
| Ubuntu Server LTS | Ubuntu Desktop | Server is smaller and faster; no graphical desktop, which a developer test machine does not need |
| Dynamic disks | pre-allocated (fixed) disks | Dynamic starts small and saves SSD space, but can be slightly slower and can fill the host disk if the guest fills up |
| A snapshot of a switched-off guest | snapshot while running; a backup copy | Switched-off is clean and small. A snapshot is not a backup: it lives with the VM |

### What went wrong, and how I fixed it

Ubuntu could not ping Windows. First `ping` was "command not found" because the minimal Ubuntu Server image has no ping tool; I installed `iputils-ping`. Then `ping -c 4 10.0.2.4` gave **4 transmitted, 0 received, 100% packet loss**, although Windows could ping Ubuntu. The cause was the Windows firewall, which blocks incoming ping by default. I created the rule `Allow ping in (ICMPv4)` (inbound, allow). My first attempt pasted the command split into two lines and left an empty rule with the same name; I removed it and created the rule again. After that Ubuntu → Windows and Windows → Ubuntu both showed 0% loss. The failing run is saved as evidence file 07.

## 4. Evidence

| File | What it proves |
|---|---|
| [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) | The VirtualBox new-VM wizard with my choices for the Windows guest |
| [evidence/02-disk-settings.png](evidence/02-disk-settings.png) | The disk size and that it is dynamically allocated |
| [evidence/03-network-adapter.png](evidence/03-network-adapter.png) | A guest is on the NAT Network `NatNetwork`, not plain NAT |
| [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) | `uname -a` and `lsb_release -a` inside the Ubuntu guest, with the command line |
| [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) | Ubuntu → Windows, Windows → Ubuntu, and each guest → internet, 0% loss, unedited |
| [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) | The snapshot list with my clean snapshots |
| [evidence/07-ping-timeout-before-firewall.png](evidence/07-ping-timeout-before-firewall.png) | The real 100% packet loss before the firewall rule — the problem I solved |

Step-by-step screenshots for BUILD.md are in [screenshots/](screenshots/).

## 5. What I would do differently

I skipped the Guest Additions in the Windows guest, so the shared clipboard never worked, and getting the evidence files out of the VMs took many extra steps — at one point I ran laptop commands inside a VM by mistake. Next time I would install Guest Additions right after Windows, and keep the terminals labelled "laptop", "Ubuntu" and "Windows". I would also write down a problem with a screenshot the moment it happens (like the licence watermark and the ping timeout), instead of reconstructing it later, and I would ask Aigerim the questions from section 2 before building anything.
