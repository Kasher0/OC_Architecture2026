# Ticket 2 — Office hardware specification

## 1. What was asked

> From: Daniyar K. (Director)
> Subject: computers for the new office
>
> We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.

## 2. What was actually needed

**Where the request is wrong.** Four identical machines is not the best answer. The four people put load on different parts of a computer: the web developer runs containers, a local database and often a VM (memory and CPU threads); the designer works with large images and colour (screen, memory, storage speed); the sales manager keeps 30–40 browser tabs and video calls open (memory); the accountant needs a reliable machine and a comfortable screen for spreadsheets and accounting software. One spec for all either wastes money on parts that idle or starves one person of the part they need.
<!-- EDIT: rewrite this paragraph in your own words -->

**What the request left out.**
- Operating-system licences (every machine must have a licensed OS, and it must be inside the 3,000,000).
- Keyboards, mice, cables, a UPS and backups.
- What "a few years" means, and so what platform (socket, memory generation) can be upgraded later.
- Which software each person runs, and whether any of it needs Windows.

**What I would have asked Daniyar.**
1. Which accounting software does the accountant use, and does it need Windows?
2. Does the designer work only in 2D (Photoshop, Illustrator, Figma) or also in 3D or video?
3. Does the web developer need any Windows-only tool, or can the work be done on Linux?
4. How many years is "a few years"?
5. Are keyboards, mice and a UPS inside the 3,000,000?

**What I assumed instead.**
- Accounting software in Kazakhstan needs Windows, so the accountant gets Windows.
- The designer does 2D only.
- The web developer can work on Linux (Docker, Node and databases run natively on it).
- "A few years" means 4–5 years, so I chose AM5 and DDR5 with free memory slots to allow a newer CPU or more memory later.
- Peripherals are paid from the unspent part of the budget.

## 3. What I did

I went from roles to loads to parts: for each person I wrote the load, then the bottleneck that load creates, then the trade-off I accepted to stay in budget, and only then chose parts so that the money goes to the bottleneck. All four machines share one platform (Ryzen 5 7600 on an MSI PRO B650M-P, 1 TB NVMe SSD, 550 W power supply, licensed OS, one monitor), so they can take a newer CPU or more memory later. They differ in memory, SSD, OS and monitor because the loads differ. Compatibility (socket, memory type, M.2, power) is checked in PCPartPicker.

Full reasoning per build: [builds.md](builds.md). Every part with price, vendor link and date: [budget.csv](budget.csv).

| Role | Memory | SSD (1 TB) | OS | Monitor | Total, KZT |
|---|---|---|---|---|---|
| Accountant | 16 GB | MSI SPATIUM M470 PRO | Windows 11 Pro | LG 24" IPS | 562,148 |
| Sales manager | 32 GB | MSI SPATIUM M470 PRO | Windows 11 Pro | Lenovo 24" | 646,051 |
| Web developer | 32 GB | MSI SPATIUM M470 PRO | Ubuntu LTS | Dahua 27" 1440p | 601,146 |
| Designer | 32 GB | Samsung 990 | Windows 11 Pro | LG 27" 1440p, sRGB 100% | ~771,634 |
| **Grand total** | | | | | **~2,580,979** |

The grand total is 419,021 KZT below the 3,000,000 limit. I kept that gap for the things the request forgot (keyboards, mice, cables, a UPS, a backup drive) and for price changes, because memory and SSD prices in Kazakhstan move within a month.

### The director's three questions

**1. Which of the four machines will you upgrade first, eighteen months from now, and why?**
The designer's machine: I would add a discrete graphics card. The board, the case and the 550 W power supply can already take one, and the integrated graphics is the one weakness I knowingly accepted in that build.

**2. Price the same four as pre-built machines from a vendor. What does the company gain and lose by not building them?**

| Role | Pre-built model | Specs | Price, KZT | Vendor link | Date |
|---|---|---|---|---|---|
| Accountant | DEXP Mars G013 | Ryzen 7 5700G (8 cores) / 16 GB DDR4 / 1 TB M.2 PCIe SSD / integrated graphics / 500 W PSU / no OS, no monitor | 283,350 (cash/card; 298,250 in installments) | (https://www.dns-shop.kz/search/?q=%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%BD%D1%8B%D0%B9+%D0%B1%D0%BB%D0%BE%D0%BA&category=17a8932c16404e77&stock=now-today-tomorrow-later&f[1hd]=cx&f[1go]=cr&f[1he]=1qhl&f[1gt]=d5) | 2026-11-22 |
| Sales manager | ПК DEXP Atlas H578 | Ryzen 7 5700G (8 cores) / 32 GB DDR4 / 1 TB M.2 PCIe SSD / integrated graphics / 500 W PSU / no monitor | 494,590 (cash/card; 520,590 installments) | (https://www.dns-shop.kz/search/?q=%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%BD%D1%8B%D0%B9+%D0%B1%D0%BB%D0%BE%D0%BA&category=17a8932c16404e77&stock=now-today-tomorrow-later&f[1hd]=1qx&f[1go]=cr&f[1he]=1qhl&f[1gt]=d5) | 2026-11-22 |
| Web developer | ПК DEXP Mars G021 | Ryzen 7 8700G (8 cores) / 32 GB DDR5 / 1 TB M.2 PCIe SSD / integrated graphics / B650 / 600 W PSU / no monitor | 549,990 (cash/card; 578,890 installments) | https://www.dns-shop.kz/search/?q=%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%BD%D1%8B%D0%B9+%D0%B1%D0%BB%D0%BE%D0%BA&category=17a8932c16404e77&stock=now-today-tomorrow-later&f[1hd]=1qx&f[1go]=cr&f[1he]=1qhl&f[1gt]=d5 | 2026-11-22 |
| Designer | ПК ASUS V500 VM501MH-0R72600250 [90PF0642-M009T0] | Ryzen 7 260 (8 cores) / 32 GB DDR5 / 1 TB M.2 PCIe SSD / integrated graphics / 180 W PSU / no monitor | 626,090 (cash/card; 659,090 installments) | https://www.dns-shop.kz/search/?q=%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%BD%D1%8B%D0%B9+%D0%B1%D0%BB%D0%BE%D0%BA&category=17a8932c16404e77&stock=now-today-tomorrow-later&f[1hd]=1qx&f[1go]=cr&f[1he]=1qhl&f[1gt]=d5 | 2026-11-22 |

Gains: one warranty and one support contact, no assembly or testing time, the operating system is already installed and licensed. Losses: choice of parts, an upgrade path on models with proprietary parts, and the ability to put the money exactly on each person's bottleneck.
<!-- EDIT: after filling the table, add the price difference vs my builds (2,500,749 KZT) -->

**3. One of these four people will complain about performance within a month. Which one, and about what?**
The designer, about slowness in GPU-accelerated filters and with very large files, because I kept the integrated graphics to stay on a sensible monitor and 32 GB of memory. The second most likely is the sales manager, about memory, if the number of CRM tabs grows beyond what 32 GB comfortably holds with video calls.
<!-- EDIT: this is your honest prediction; keep it specific -->

## 4. Evidence

- [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) — one PCPartPicker list per build; proves that socket, memory type, M.2 slot and total power are compatible (it does not price in tenge).
- [evidence/vendor-quotes/](evidence/vendor-quotes/) — a dated screenshot of every price used, with the vendor's address bar and the clock visible; proves each price in budget.csv and the day it was taken. [INDEX.md](evidence/vendor-quotes/INDEX.md) maps each file to the budget.csv rows it covers.

## 5. What I would do differently

I would ask Daniyar about the accounting software before pricing Windows for three machines, and I would price a discrete graphics card for the designer instead of only naming it as the alternative I did not take.
<!-- EDIT: replace with something that is true for you and specific -->
