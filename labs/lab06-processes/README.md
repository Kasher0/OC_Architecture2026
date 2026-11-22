\# Lab 6 — Live processes and memory pressure



Student: Kazhymurat · Date: 22.11.26 · Guests:  Ubuntu 26.04.1 LTS. Windows Enterprise LTSC Evaluation 24H2. Both machines have 4GB of RAM



\## Part 1 — One process, three tools

Process chosen: `VBoxService` (`VBoxService.exe` on Windows / `/usr/sbin/VBoxService` on Ubuntu) — why: It is the VirtualBox Guest Additions background service present on both the Windows and Ubuntu guest VMs, making it easy to inspect and compare across all three tools.



| | Task Manager | Process Explorer | htop / ps |

| :--- | :--- | :--- | :--- |

| PID | 1772 | 1772 | 1199 |

| Parent (name and PID) | — (not shown) | Not shown in columns | PPID 1 |

| "Memory" as shown by default | 1,104 K | 2,484 K | 0.1% / 3816 |

| Private memory | 1,104 K | 2,484 K | Not shown by default |

| Working set / RES | 1,104 K | 9,548 K | 3816 |

| Virtual size | Not shown in visible columns | 2,151,781,564 K | 349M |

| Handles / file descriptors | Not shown in visible columns | 195 | Not shown by default |

| Threads | Not shown in visible columns | 16 | Not shown as a count column |



\### Where the tools disagree

Different "Memory" metrics and numbers (`1,104 K` vs. `2,484 K` / `9,548 K` vs. `3816` / `0.1%`). 



\## Part 2 — Memory pressure

Guest RAM: 3.3GB · swap: 2.6GB

Steps:

```

free -h

swapon --show

cd \~ \&\& mkdir -p lab06 \&\& cd lab06

{ echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt

while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done | tee -a memory-pressure.txt

stress-ng --vm 2 --vm-bytes 70% --timeout 60s

stress-ng --vm 2 --vm-bytes 90% --timeout 60s

stress-ng --vm 2 --vm-bytes 120% --timeout 90s

{ echo "=== AFTER $(date) ==="; free -h; } >> memory-pressure.txt

journalctl -k --since "30 min ago" | grep -i -E -B3 -A8 "out of memory|oom-kill" > kernel-log-extract.txt

cat kernel-log-extract.txt

```

| | Before | During (worst) | After |

| :--- | :--- | :--- | :--- |

| Available | 2.9GB | 111MB | 2.9GB |

| Swap used | 0GB | 1.2GB| 0GB |



Htop was updating slower



\### What the kernel did

The kernel did nothing, though usually it kills the process that's taking too much RAM. The stress test ended by itself. The log is empty



\### Windows

`Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 |

&#x20;   Format-List TimeCreated, Id, Message`

Showed nothing because the kernel never killed any process



\## What did not work the first time

The process explorer didn't show handles. Fixed by running as an administrator

