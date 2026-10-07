# Name                    : AMD Ryzen 9 8940HX with Radeon Graphics
NumberOfCores           : 16
NumberOfLogicalProcessors : 32
Manufacturer Capacity    Speed DeviceLocator
------------ --------    ----- -------------
Samsung      17179869184 5600  DIMM 0
Samsung      17179869184 5600  DIMM 0

TotalVisibleMemorySize / 1MB: 31212.68 MB
FriendlyName             MediaType Size
------------             --------- ----
MTFDKBA1T0QGN-1BN1AABGA  SSD       1024209543168

DriveLetter FileSystemLabel Size          SizeRemaining
----------- --------------- ----          -------------
C           Windows 11      1023200456704 24509308928
# Lab 0 — Inventory your own machine
Pair: Ashkeev / Driver first half: Ashkeev
Machine: ROG Strix / Windows 11
Date: 07.10.2026

## What I did
Ran PowerShell CIM/WMI cmdlets to retrieve hardware specifications directly from the OS without using graphical user interface system utilities.

## Result

| What | Value | Where I got it |
| --- | --- | --- |
| CPU Model | AMD Ryzen 9 8940HX with Radeon Graphics | `Get-CimInstance Win32_Processor \| Select-Object Name` |
| Cores / Threads | 16 Cores / 32 Threads | `Get-CimInstance Win32_Processor \| Select-Object NumberOfCores, NumberOfLogicalProcessors` |
| Total Memory | 32 GB (31,212 MB) | `(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB` |
| Installed Memory Modules & Speed | 2 x 16 GB DDR5 @ 5600 MHz (Samsung) | `Get-CimInstance Win32_PhysicalMemory \| Select-Object Capacity, Speed, DeviceLocator` |
| Disk Model & Type | Micron MTFDKBA1T0QGN-1BN1AABGA (1 TB NVMe SSD) | `Get-PhysicalDisk \| Select-Object FriendlyName, MediaType, Size` |
| Disk Free Space (VM volume) | 22.8 GB free on Volume C: | `Get-Volume \| Select-Object DriveLetter, SizeRemaining` |
| Firmware Type & Version | UEFI / AMI G614PP.316 (14.05.2026) | `Get-CimInstance Win32_BIOS \| Select-Object SMBIOSBIOSVersion, ReleaseDate` |
| Hardware Virtualization | Supported & Enabled | `(Get-CimInstance Win32_ComputerSystem).HypervisorPresent` |

## What did not work the first time
When checking disk space, `Get-Disk` returned total physical capacity rather than volume-level free space. I had to use `Get-Volume` to specifically query `SizeRemaining` for Drive C: to get the actual free space available for storing virtual machines.

## Evidence
- [evidence/cpu.txt](evidence/cpu.txt) — raw terminal output for CPU details
- [evidence/memory.txt](evidence/memory.txt) — raw terminal output for RAM capacity, speed, and module count
- [evidence/disk.txt](evidence/disk.txt) — raw terminal output for disk model, media type, and remaining free space
