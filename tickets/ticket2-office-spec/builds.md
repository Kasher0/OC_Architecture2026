# Builds - Ticket 2 (second office, 4 machines)

Common platform for all four: AMD Ryzen 5 7600 (AM5, integrated Radeon graphics, cooler in the box) on an MSI PRO B650M-P (mATX, DDR5, 4 DIMM slots, 2 x M.2), MSI MAG A550BN 550 W PSU, Deepcool CC560 V2 case, 1 TB NVMe SSD (M.2 2280).
Why a shared platform: AM5 + DDR5 lets every machine take a newer CPU or more memory later (4 DIMM slots, 2 used), which is what "last a few years" needs. The machines are NOT identical: memory, SSD, OS and monitor differ because the loads differ.
Compatibility checked: CPU socket AM5 = board socket AM5; board DDR5 = DDR5 memory; M.2 slot = NVMe 2280 SSD; ATX case holds an mATX board; total draw (one CPU with iGPU, one SSD) is far below 550 W - confirmed in the PCPartPicker lists (evidence/pcpartpicker-links.md).

## Build 1 - accountant
**Load:** Excel and accounting software, a browser, PDF reports, 8 hours a day, 3-5 windows at once. [EDIT to what you assumed]
**Bottleneck:** not CPU or memory - the person looks at numbers all day and the data must not be lost. Bottleneck = screen comfort and reliability.
**Trade-off:** 16 GB (2 x 8 GB) instead of 32 GB (+89,278 KZT), one SSD only, no UPS or backup drive in the budget. Acceptable because spreadsheets use little memory; backups go to an external drive or cloud.
**Alternative not taken:** 32 GB kit; Samsung 990 instead of MSI M470 PRO (+36,970 KZT).
**OS:** Windows 11 Pro OEM licence - accounting software in Kazakhstan often needs Windows (assumption).
**Total:** 562,148 KZT (budget.csv, rows 2-10)

## Build 2 - sales manager
**Load:** CRM in the browser with 30-40 tabs, Excel, several hours of video calls a day, often all at once. [EDIT]
**Bottleneck:** memory. Browser tabs plus a video call plus Windows leave little headroom in 16 GB; when memory runs out the system swaps and the call stutters.
**Trade-off:** a mid CPU (Ryzen 5 7600), a plain 24" Lenovo monitor, no extra webcam or headset in the budget. The CPU idles in this role; memory does not.
**Alternative not taken:** 16 GB (-89,278 KZT); a better monitor (LG 24MR400-B is +5,375 KZT).
**OS:** Windows 11 Pro OEM.
**Total:** 646,051 KZT (budget.csv, rows 11-19)

## Build 3 - web developer
**Load:** code editor, several browsers, Docker containers, a local database, sometimes a VM, all running at once. [EDIT]
**Bottleneck:** memory first (containers + VM + browsers), then CPU threads.
**Trade-off:** 6-core CPU instead of 8-core, 32 GB instead of 64 GB (prices for these two alternatives NOT checked). Money saved on the OS: Ubuntu LTS is free and open-source licensed, and the tools (Docker, Node, databases) run natively on it. Assumes no Windows-only tool is needed - the question I would ask Daniyar.
**Alternative not taken:** Windows 11 Pro (+67,970 KZT); Ryzen 7 (not priced); 64 GB (not priced).
**Total:** 601,146 KZT (budget.csv, rows 20-28)

## Build 4 - designer
**Load:** Photoshop/Illustrator/Figma-type 2D work with large files and many layers; colour-critical output. Assumption: no 3D or video editing. [EDIT]
**Bottleneck:** the screen (colour accuracy) and memory for large files; storage speed for opening big files.
**Trade-off:** no discrete graphics card - the integrated Radeon is weak for GPU-accelerated filters; and a 1440p sRGB-100% monitor instead of a hardware-calibrated or wide-gamut one (27" 4K sRGB 99% listings start around 173,000 KZT, about +77,000 KZT).
**Alternative not taken:** discrete GPU (not priced); 4K monitor; Ryzen 7.
**OS:** Windows 11 Pro OEM.
**Total:** ~771,634 KZT (budget.csv, rows 29-37)

## Grand total
2,500,749 KZT, i.e. 499,251 KZT under the 3,000,000 limit. The gap is kept for what the request forgot (keyboards, mice, cables, a UPS, a backup drive) and for price drift: memory prices in Kazakhstan move within a month. [EDIT: if you spend part of it, update budget.csv]
