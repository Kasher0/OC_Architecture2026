# Lab 3 — Teardown, and the same machine from the command line

Pair: Kazhymurat + Arsen · Date: 04.11.2026

## Part 1 — Ten parts

### 1. AMD Ryzen 5 7600
![AMD Ryzen 5 7600](evidence/photos/ryzen5-7600.png)

**What it is:** 6 cores / 12 threads, Zen 4 ("Raphael"), 3.8 GHz base, up to 5.1 GHz boost, 32 MB L3, 65 W default TDP, integrated Radeon graphics (2 cores).
**Connects to:** socket **AM5** (boards with A620 / B650 / B650E / B840 / B850 / X670 / X670E / X870 / X870E chipsets). Its memory controller is **DDR5 only**, 2 channels. PCIe 5.0.
**Limit:** fits only AM5 boards and only DDR5 memory (no DDR4). Official memory speed is DDR5-5200 with two modules (DDR5-3600 with four); faster kits run as an overclock profile.
Source: https://www.amd.com/en/products/processors/desktops/ryzen/7000-series/amd-ryzen-5-7600.html#product-specs

### 2. Intel Core i5-13400
![Intel Core i5-13400](evidence/photos/core-i5-13400.png)

**What it is:** 10 cores (6 Performance + 4 Efficient), 16 threads, P-core base 2.5 GHz, max turbo 4.6 GHz, 20 MB Intel Smart Cache, 65 W base power, integrated Intel UHD Graphics 730.
**Connects to:** socket **FCLGA1700**. Memory controller takes **DDR5-4800 or DDR4-3200**, 2 channels (which one is used is decided by the board's slots). PCIe 5.0 and 4.0, 20 lanes.
**Limit:** fits only LGA1700 boards. It supports both memory generations, but a given board has only one kind of slot, so the board decides.

Source: (https://www.intel.com/content/www/us/en/products/sku/230495/intel-core-i513400-processor-20m-cache-up-to-4-60-ghz/specifications.html)

### 3. ASUS PRIME B650M-A
![ASUS PRIME B650M-A](evidence/photos/asus-b650m-a.png)

**What it is:** micro-ATX motherboard, chipset AMD B650, socket AM5.
**Connects to:** AM5 CPU; DDR5 DIMM slots (4); 2 × M.2 (Key M, 2242/2260/2280, PCIe 4.0 x4); 4 × SATA 6 Gb/s; PCIe 4.0 x16 slot plus two PCIe 4.0 x16 slots running at x1.
**Limit:** only AM5 processors and only DDR5. Which Ryzen generations it takes is in the CPU Support list (see Step 3).

Source: (https://www.asus.com/ru/motherboards-components/motherboards/prime/prime-b650m-a/)

### 4. MSI PRO B760M-A WIFI DDR4
![MSI PRO B760M-A WIFI DDR4](evidence/photos/msi-b760m-a-wifi-ddr4.png)

**What it is:** micro-ATX motherboard, chipset Intel B760, socket LGA1700, Wi-Fi 6E + 2.5G LAN.
**Connects to:** LGA1700 CPU; 4 × **DDR4** DIMM slots (dual channel, up to 128 GB); 2 × M.2 (M2_1 from the CPU, PCIe 4.0 x4; M2_2 from the chipset, PCIe 4.0 x4 or SATA mode); 4 × SATA 6 Gb/s.
**Limit:** only LGA1700 CPUs and only DDR4: a DDR5 stick will not fit the slot.

Source: (https://www.msi.com/Motherboard/PRO-B760M-A-WIFI-DDR4/Specification)

### 5. Kingston FURY Beast DDR5-5600, 16 GB
![Kingston FURY Beast DDR5](evidence/photos/kingston-fury-beast-ddr5.png)

**What it is:** DDR5 UDIMM, 16 GB (one module), 5600 MT/s (PC5-44800), CL40, 1.25 V, 288 pins, on-die ECC.
**Connects to:** a 288-pin DDR5 DIMM slot. One module means one memory channel is used, the second stays empty.
**Limit:** fits only DDR5 boards (the notch is in a different place than on DDR4). The speed is also capped by the CPU: the Ryzen 5 7600 officially tops out at DDR5-5200 with two modules, so 5600 is reached only through an overclock profile.

Source: https://www.kingston.com/ru/memory/gaming/kingston-fury-beast-ddr5-memory?speed=5600mt%2Fs&total%20(kit)%20capacity=16gb&kit=single%20module&cas%20latency=40&dram%20density=16gbit&profile%20type=intel%20xmp&color=black

### 6. Crucial DDR4-3200, 16 GB DIMM
![Crucial DDR4-3200](evidence/photos/crucial-ddr4-3200.png)

**What it is:** DDR4 UDIMM, 16 GB, 3200 MT/s (PC4-25600), 288 pins, 1.2 V.
**Connects to:** a 288-pin DDR4 DIMM slot, one per channel.
**Limit:** fits only DDR4 boards. 3200 MT/s is exactly the top official DDR4 speed of the Core i5-13400.

Source: https://www.crucial.com/memory/ddr4/ct16g4dfra32a

### 7. Samsung 990 PRO 1 TB
![Samsung 990 PRO](evidence/photos/samsung-990-pro.png)

**What it is:** NVMe SSD, 1 TB, form factor M.2 2280, interface PCIe 4.0 x4 (NVMe 2.0), up to 7,450 MB/s sequential read and 6,900 MB/s write.
**Connects to:** an M.2 Key M slot that provides PCIe lanes. No data or power cable.
**Limit:** the bus: it runs at PCIe 4.0 x4 speed at best, and an M.2 slot that is SATA-only would not work.

Source: https://www.samsung.com/in/memory-storage/nvme-ssd/990-pro-1tb-nvme-pcie-gen-4-mz-v9p1t0bw/

### 8. Samsung 870 EVO 1 TB
![Samsung 870 EVO](evidence/photos/samsung-870-evo.png)

**What it is:** SATA SSD, 1 TB, 2.5-inch.
**Connects to:** a SATA 6 Gb/s port by a data cable and to the power supply by a SATA power cable.
**Limit:** the SATA bus tops out at about 550 MB/s, far below an NVMe drive.

Source: https://www.samsung.com/kz_ru/memory-storage/sata-ssd/870-evo-1tb-sata-3-2-5-ssd-mz-77e1t0bw/

### 9. Corsair RM750e (750 W)
![Corsair RM750e](evidence/photos/corsair-rm750e.png)

**What it is:** ATX power supply, 750 W, 80 PLUS Gold, fully modular.
**Connects to:** the motherboard (24-pin and CPU 8-pin), drives (SATA power), graphics card (PCIe power).
**Limit:** total wattage, 750 W.

Source: https://www.corsair.com/us/en/p/psu/cp-9020292-na/rme-series-rm750e-fully-modular-low-noise-atx-power-supply-white-na-cp-9020292-na?srsltid=AYCX9vKPkV0mtNsvs-N7qkq8QIo0WTOTqHvUVwlOBN2cK8vJPjXJdTmf

### 10. Stock cooler
![Stock cooler](evidence/photos/wraith-stealth.png)

**What it is:** AMD Wraith Stealth, the cooler that ships in the box with the Ryzen 5 7600 (AMD lists "Thermal Solution (PIB): AMD Wraith Stealth" on the product page).
**Connects to:** the AM5 socket.
**Limit:** it is made for a 65 W processor.

Source: https://www.amd.com/en/products/processors/ecosystem/cpu-cooler-solutions.html

## Step 3 — The motherboards

| | ASUS PRIME B650M-A | MSI PRO B760M-A WIFI DDR4 |
|---|---|---|
| Socket | AM5 | LGA1700 |
| Chipset | AMD B650 | Intel B760 |
| Memory | DDR5, 4 slots | DDR4, 4 slots |
| Storage | 2 × M.2 (PCIe 4.0 x4), 4 × SATA | 2 × M.2 (PCIe 4.0 x4; M2_2 also SATA mode), 4 × SATA |
| CPUs accepted | Ryzen 7000, 8000, 9000 | Core 12th, 13th and 14th gen, Pentium Gold, Celeron |
| BIOS update needed? | Not necessary, but recommended | Not necessary |


## Two builds

### Build 1 — AMD

| Part | Model | Why it fits here |
|---|---|---|
| Processor | AMD Ryzen 5 7600 | The starting point of this build. It has 6 cores / 12 threads and a 65 W default TDP, and it has integrated Radeon graphics, so the build needs no graphics card. It uses socket AM5 and its memory controller supports DDR5 only, so the motherboard and the memory below are chosen to match these two facts. |
| Motherboard | ASUS PRIME B650M-A | It has socket AM5, the same socket as the 7600, so the processor physically fits. ASUS lists Ryzen 7000, 8000 and 9000 as supported, and the 7600 is a 7000-series chip. AMD's page for the 7600 lists B650 among the chipsets it works with. The board's DIMM slots are DDR5, the only memory type the 7600 can use. It is micro-ATX and has video outputs, which this build needs because it uses the integrated graphics of the CPU. |
| Memory | Kingston FURY Beast DDR5-5600 16 GB | Both the 7600 and the board are DDR5 only, and this is a DDR5 288-pin DIMM. A DDR4 module would not fit the slot at all because its notch is in a different place. The module is rated 5600 MT/s, which is above the official 5200 MT/s of the 7600 (with two modules), so it is compatible, but the extra speed is only available through an overclock profile; without one it runs at its standard base speed. One module uses one of the four slots, so memory works in one channel. |
| SSD | Samsung 990 PRO 1 TB | The 990 PRO is an NVMe drive in the M.2 2280 size with a PCIe 4.0 x4 interface. The board has two M.2 Key M slots that take 2280 drives and give PCIe 4.0 x4, so both the size and the bus match and the drive can run at its full speed. It needs no cable: it plugs straight into the board. |
| Power | Corsair RM750e | An ATX power supply gives the 24-pin main connector and the CPU 8-pin connector that ATX and micro-ATX boards use. 750 W is far more than this build needs: a 65 W processor with integrated graphics and no graphics card. The extra capacity is only headroom (for example for a graphics card later), not a requirement. |
| Cooler | AMD Wraith Stealth | It comes in the box with the Ryzen 5 7600, it mounts on socket AM5, and it is made for a processor of this 65 W class, so nothing extra has to be bought. |

### Build 2 — Intel

| Part | Model | Why it fits here |
|---|---|---|
| Processor | Intel Core i5-13400 | The starting point of this build. It has 10 cores (6 Performance + 4 Efficient), 16 threads, 65 W base power and integrated Intel UHD Graphics 730, so no graphics card is needed. It uses socket LGA1700. Its memory controller supports both DDR5-4800 and DDR4-3200, so here the motherboard decides which memory type is used. |
| Motherboard | MSI PRO B760M-A WIFI DDR4 | It has socket LGA1700, the same as the i5-13400, so the processor fits. MSI lists 12th, 13th and 14th gen Core processors as supported, and the 13400 is 13th gen. The board's four DIMM slots are DDR4, which the CPU supports (up to DDR4-3200), and this is the reason the build uses DDR4 and not DDR5. It is micro-ATX and has video outputs for the integrated graphics. |
| Memory | Crucial DDR4-3200 16 GB | The board has only DDR4 slots, so DDR4 is the only type that works here, and the Kingston DDR5 module from Build 1 cannot be used. 3200 MT/s is exactly the official DDR4 maximum of the i5-13400, so the module runs at the full speed the processor supports without any overclocking. |
| SSD | Samsung 870 EVO 1 TB | It is a 2.5-inch SATA drive and the board has four SATA 6 Gb/s ports, so the interface matches. It needs a SATA data cable to the board and a SATA power cable from the power supply. A SATA drive is used here so that the two builds cover both kinds of SSD, NVMe in Build 1 and SATA in Build 2; its limit is the SATA bus of about 550 MB/s. |
| Cooler | Cooler from the i5-13400 box (Intel boxed cooler) | The Wraith Stealth from Build 1 is an AMD cooler with AM5 mounting, so it does not fit an LGA1700 board, and the parts list has only one stock cooler. This build therefore uses the cooler that comes in the box with the i5-13400, which has LGA1700 mounting. |

<!-- CHECK: confirm on Intel's page that the i5-13400 box includes a cooler. If it does not, delete the row's claim and add "an LGA1700 cooler" to what Build 2 still needs -->

### What each build still needs

- **Build 1:** a case, a keyboard and monitor, an operating system. No graphics card is needed (the 7600 has integrated graphics; the board has video outputs).
- **Build 2:** everything above, **plus a power supply**, because the parts list has only one (the RM750e went to Build 1). It also needs a SATA data cable for the 870 EVO and a SATA power connector from the PSU. If Intel's page shows that the i5-13400 box has no cooler, it also needs an LGA1700 cooler, because the Wraith Stealth is for AM5 and stays with Build 1.
- Both builds have only one 16 GB module, so memory runs in single-channel mode with two empty slots; a second identical module would add a channel.
<!-- CHECK: whether the MSI box includes a SATA cable and the Wi-Fi antenna: read the "What's in the box" section on msi.com -->

## Part 2 — Same facts, three operating systems

Windows is my laptop (the host). Linux is the Ubuntu VM from Lab 1, so it describes the **virtual** machine, not the laptop. No Mac in the pair, so the macOS column shows the commands from the lab guide but they were **not run**.

| Fact | Windows (PowerShell) | Linux (Ubuntu VM) | macOS (not run) |
|---|---|---|---|
| CPU model | `Get-CimInstance Win32_Processor \| Select Name` | `lscpu` (line "Model name") | `sysctl -n machdep.cpu.brand_string` |
| Cores / threads | `Get-CimInstance Win32_Processor \| Select NumberOfCores, NumberOfLogicalProcessors` | `lscpu` ("Core(s) per socket", "CPU(s)") | `sysctl hw.physicalcpu hw.logicalcpu` |
| Total memory | `Get-CimInstance Win32_PhysicalMemory \| Select Capacity` (sum of modules) | `free -h` | `sysctl hw.memsize` |
| Memory modules and speed | `Get-CimInstance Win32_PhysicalMemory \| Select DeviceLocator, Capacity, Speed, ConfiguredClockSpeed, SMBIOSMemoryType, FormFactor` | `sudo dmidecode -t memory` | `system_profiler SPMemoryDataType` |
| Disk model and type | `Get-PhysicalDisk \| Select FriendlyName, MediaType, BusType, Size` | `lsblk -d -o NAME,MODEL,ROTA,TRAN,SIZE` | `diskutil info disk0` |
| Free space | `Get-Volume C` | `df -h /` | `df -h /` |
| Architecture | `$env:PROCESSOR_ARCHITECTURE` | `uname -m` | `uname -m` |

executing the command in powershell information showed me CPU model 34 (means DDR5), while in ubuntu its showed as 25 (DDR4). Also 16 Cores in my laptop versus 4 Cores in linux ubuntu

## What did not work the first time

I was struggling to execute command to get information from ubuntu-serverr. So basically I just executed a consequative commands (sudo - v, mkdir -p ~/evidence, { echo '$ lscpu'; lscpu; } >> ~/evidence/linux-specs.txt, { echo '$ free -h'; free -h; } >> ~/evidence/linux-specs.txt, { echo '$ free -h'; free -h; } >> ~/evidence/linux-specs.txt, { echo '$ sudo dmidecode -t memory'; sudo dmidecode -t memory; } >> ~/evidence/linux-specs.txt, { echo '$ lsblk -d -o NAME,MODEL,ROTA,TRAN,SIZE'; lsblk -d -o NAME,MODEL,ROTA,TRAN,SIZE; } >> ~/evidence/linux-specs.txt, { echo '$ df -h /'; df -h /; } >> ~/evidence/linux-specs.txt and { echo '$ uname -m'; uname -m; } >> ~/evidence/linux-specs.txt) and checked that they all were executed by cat ~/evidence/linux-specs.txt command

## Evidence

- [evidence/windows-specs.txt](evidence/windows-specs.txt) — each Windows command with its raw output
- [evidence/linux-specs.txt](evidence/linux-specs.txt) — each Linux command with its raw output, from the VM
- [evidence/photos/](evidence/photos/) — screenshots of the ten maker pages
