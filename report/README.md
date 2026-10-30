<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

# ASICONE (`asicone_202508`)

**IHP SG13G2 OpenMPW September 2025 (T594): design, tapeout and silicon evaluation**

Ckristian Duran, Symbiotic EDA / The University of Tokyo. October 2026.

PDF version: [report.pdf](report.pdf) (build with `make`).

## Abstract

ASICONE is a 1.4326 mm × 1.39606 mm (2.0 mm<sup>2</sup>) test chip fabricated in the IHP SG13G2 130 nm open-source PDK on the September 2025 OpenMPW shuttle (T594). It carries a generated 5-bit differential SAR ADC, two ring oscillators (13 and 101 stages) for reliability studies, and an SPI configuration block, all built with open-source tools and custom 18-track standard cells. This report collects the complete record of the chip: the blocks, the design flow, the tapeout sequence of August–September 2025 with its sign-off results and deviations, the adapter board and the bench, and the measurements compared with schematic and post-layout simulation.

**Result in one paragraph.** The chip is alive and every block responds. The ADC is monotonic with no missing codes at 1.43 MS/s, but reaches only 3.81 ENOB at low frequency (DNL −0.80 to 0.67, INL −0.87 to 0.99 LSB) because of binary-weight errors of −8 % to 7 % in its capacitive DAC; a post-layout simulation made after the fact reproduces the error pattern (INL correlation 0.98) and traces it to the wiring capacitance of the DAC plates, which could not be extracted at tapeout time. The SPI writes work, but the read-back (MISO) is dead because of a one-identifier typo in the RTL (`RDA[addr]` instead of `RDA[raddr]`), confirmed here by simulation. The 13-stage ring runs at 130.8 MHz, 31 % below the post-layout prediction; the 101-stage ring runs at 135.4 MHz, almost five times *faster* than predicted, which no parasitic can explain and which remains an open functional anomaly.

## Contents

- [1 Summary of results](#1-summary-of-results)
- [2 The chip](02-the-chip.md#2-the-chip)
  - [2.1 Contents and floorplan](02-the-chip.md#21-contents-and-floorplan)
  - [2.2 Pinout](02-the-chip.md#22-pinout)
- [3 Block design](03-block-design.md#3-block-design)
  - [3.1 Custom standard cells](03-block-design.md#31-custom-standard-cells)
  - [3.2 SAR ADC](03-block-design.md#32-sar-adc)
  - [3.3 Ring oscillators](03-block-design.md#33-ring-oscillators)
  - [3.4 SPI](03-block-design.md#34-spi)
- [4 Design flow and tapeout sequence](04-design-flow-and-tapeout-sequence.md#4-design-flow-and-tapeout-sequence)
  - [4.1 Flow](04-design-flow-and-tapeout-sequence.md#41-flow)
  - [4.2 Timeline](04-design-flow-and-tapeout-sequence.md#42-timeline)
  - [4.3 Sign-off results and deviations](04-design-flow-and-tapeout-sequence.md#43-sign-off-results-and-deviations)
  - [4.4 Parasitic extraction: not available at tapeout](04-design-flow-and-tapeout-sequence.md#44-parasitic-extraction-not-available-at-tapeout)
- [5 Measurement environment](05-measurement-environment.md#5-measurement-environment)
  - [5.1 Equipment and signal chain](05-measurement-environment.md#51-equipment-and-signal-chain)
  - [5.2 Adapter board](05-measurement-environment.md#52-adapter-board)
- [6 SAR ADC measurement](06-sar-adc-measurement.md#6-sar-adc-measurement)
  - [6.1 Static linearity](06-sar-adc-measurement.md#61-static-linearity)
  - [6.2 Dynamic performance](06-sar-adc-measurement.md#62-dynamic-performance)
  - [6.3 Comparison with simulation](06-sar-adc-measurement.md#63-comparison-with-simulation)
  - [6.4 Why the ADC performance is poor](06-sar-adc-measurement.md#64-why-the-adc-performance-is-poor)
- [7 Ring oscillator measurement](07-ring-oscillator-measurement.md#7-ring-oscillator-measurement)
  - [7.1 Results](07-ring-oscillator-measurement.md#71-results)
  - [7.2 Is the mismatch justified?](07-ring-oscillator-measurement.md#72-is-the-mismatch-justified)
- [8 SPI: the read-back failure](08-spi-the-read-back-failure.md#8-spi-the-read-back-failure)
  - [8.1 Symptom](08-spi-the-read-back-failure.md#81-symptom)
  - [8.2 Cause: one identifier](08-spi-the-read-back-failure.md#82-cause-one-identifier)
  - [8.3 Confirmation](08-spi-the-read-back-failure.md#83-confirmation)
  - [8.4 Why it escaped](08-spi-the-read-back-failure.md#84-why-it-escaped)
- [9 Errata and lessons](09-errata-and-lessons.md#9-errata-and-lessons)
- [10 Reproducing this report](10-reproducing-this-report.md#10-reproducing-this-report)

# 1 Summary of results

| Block | Status | Key numbers (bench) |
|:---|:---|:---|
| SAR ADC, 5 bit | Works, poor linearity | 1.4286 MS/s; no missing codes; ENOB 3.81 at 1 kHz, 3.08 at 650 kHz |
|  |  | DNL −0.80 to 0.67 LSB, INL −0.87 to 0.99 LSB (0.51 LSB rms) |
| RO13 | Oscillates, slow | 130.8 MHz (post-layout TT 188.8 MHz, SS 169.3 MHz) |
| RO101 | Oscillates, anomalous | 135.4 MHz (post-layout TT 27.7 MHz): 4.9× too fast |
| SPI, write | Works | RO configuration written and obeyed (16-value scan) |
| SPI, read (MISO) | Broken | RTL typo `RDA[addr]` → `RDA[raddr]`; reads return the undriven register 0 |
| I/O ring, ESD, supplies | Works | 38 bonded pads; core 1.2 V, I/O 3.3 V |

*Table 1: Status of every block of ASICONE.*

| Item | Value |
|:---|:---|
| Process | IHP SG13G2 (130 nm SiGe BiCMOS, used as SG13CMOS), open-source PDK |
| Shuttle | MPW 0.13 μm September 2025 (T594), 10 samples, final wafer thickness 200 μm |
| Top cell / GDS | `asicone_202508` / `asicone_202508.gds` (with fill) |
| Die (incl. seal ring) | 1432.60 μm × 1396.06 μm = 2.000 mm<sup>2</sup> (the full allotment) |
| Pad-ring area | 1160 μm × 1122 μm (inside seal ring, guard and bond pads) |
| Pads | 38 bonded (`sg13g2` I/O library, 70 μm bond pads), QFN48 package |
| Supplies | VDD 1.2 V (core), AVDD 1.2 V (ADC), ROVDD/RO2VDD 1.2 V (rings), VDDIO 3.3 V |
| Standard cells | Custom 18-track `sg13g2` (6.12 μm rows, 86 cells) and floating-body `sg13g2f` (77 cells, ADC) |
| Tools | Yosys, OpenROAD (custom scripts, no ORFS), KLayout DRC/LVS, ngspice, Xyce, iverilog |

*Table 2: Chip data.*

## References

1. SAR ADC generator, IEEE Xplore document 11002493. <https://ieeexplore.ieee.org/document/11002493>
2. IHP, *SG13G2 open source PDK*. <https://github.com/IHP-GmbH/IHP-Open-PDK>
3. IEEE Std 1241-2010, *Terminology and Test Methods for Analog-to-Digital Converters*.
4. IEEE Std 1057-2017, *Digitizing Waveform Recorders*.
5. Texas Instruments, *Single-Ended Input to Differential Output Circuit*, SBOA216B, 2024.
6. M. Köhler, *KLayout-PEX*, version 0.3.12. <https://iic-jku.github.io/klayout-pex-website/>

## Acknowledgements

IHP for the OpenMPW tapeout; Symbiotic EDA, which sponsored the tapeout and uses the design to evaluate open-source tools; The University of Tokyo, which uses it for research.
