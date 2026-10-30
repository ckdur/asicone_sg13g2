<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [2 The chip](02-the-chip.md) · Next: [4 Design flow and tapeout sequence](04-design-flow-and-tapeout-sequence.md)

# 3 Block design

## 3.1 Custom standard cells

Every digital cell on the chip is custom. Two libraries were drawn for this tapeout:

- `sg13g2` (`lib/`): 86 cells, 18 tracks (6.12 μm rows on a 0.34 μm site), used by the SPI and the top level;

- `sg13g2f` (`saradc_auto/cells/`): 77 floating-body variants used inside the ADC, plus the analog cells `SARADC_CELL_INVX16_ASCAP` (unit capacitor) and `SARADC_CELL_INVX0_ASSW` (switch).

The 18-track height is generous and the cells are not optimized: the standard-cell generator was still in development. The Liberty timing was *not* characterized in SG13G2; it was adapted from `sky130`, because the PDK had no parasitic extraction to characterize the layouts with. Timing of the digital blocks is therefore nominal only; at the clock rates used (10 MHz for the ADC, a few MHz for the SPI) this was never a limitation.

## 3.2 SAR ADC

#### Architecture.

The ADC is a fully differential, top-plate-sampling charge-redistribution SAR ADC. Each side has a binary capacitive DAC of $`2^5`$ units (bits of 1, 2, 4, 8, 16 units plus a dummy) between a switched plate (VSH: input, VREFH or VREFL) and a floating top plate (FL) that feeds the comparator inputs VOUTH/VOUTL. The unit capacitor is the gate of a group of MOS transistors (67.8 fF per unit with FL floating); there are 720 unit-capacitor cells and 1452 switch cells. The comparator is a dynamic latch built from `sg13g2f` cells; the SAR logic (`sar_logic_wreset.v`) is synthesized. A conversion takes $`N + 2 = 7`$ clocks: sampling, five bit decisions and the result. Interface: `CLK`, `RST` (active high), `GO` (start conversions), `SAMPLE`, `VALID` and `RESULT[4:0]`.

#### Generator and flow.

`saradc_auto` produces the ADC from RTL: Yosys synthesizes the analog netlist (capacitors and switches as cells) and the logic; OpenROAD places the DAC array with a scripted pattern (a “circle” pattern with Metal5/TopMetal1 bridges for bits 1 and 3), routes the special nets (plates, references, top plates) with custom Tcl, and routes the rest with the detailed router. The taped-out version used the flat flow now kept as `pnr_legacy/`. Macro size 566.44 μm × 361.08 μm, 24 198 transistors.

#### Design-time simulation.

Before tapeout the ADC was verified at schematic level with ngspice and Xyce at 1.8 V: transient conversions (only a few samples were possible at the time with the analog netlist), multi-frequency tests, a capacitor-linearity test and a switch-charge test (commits of 30 August to 5 September 2025). No layout parasitics were available (Section [4.4](04-design-flow-and-tapeout-sequence.md#44-parasitic-extraction-not-available-at-tapeout)).

## 3.3 Ring oscillators

Each ring (`top_13`, `top_101`) has 13 or 101 inverting stages of `lv` MOS ($`L = 0.45\,\mathrm{µm}`$, $`W_p/W_n = 4\times3.4\,\mathrm{µm}/4\times1.3\,\mathrm{µm}`$), a 5-flop ripple divider (÷32, reset by `RO_RST_B`) and a 16 mA output pad. Three stages are special: `rovcel3` closes or opens the ring (header/footer on `n_RO_control`, `RO_control`) and, with the ring open, connects `DUT_gate` to the DUT input; `rovcel1` is the DUT, with a PMOS header (`DUT_Header`) and NMOS footer (`DUT_Footer`), whose output (`extra_load`) goes straight to an analog pad and, with the ring open, to `Drain_Force`/`Drain_Sense` through transmission gates; `rovcel4` has a PMOS header on `n_RO_control`. RO101 is supplied from ROVDD, RO13 from RO2VDD; both share the core VSS. The control bits come from SPI register 0 (RO101, `R[3:0]`) and register 1 (RO13, `R[11:8]`): bit 0 `n_RO_control`, 1 `RO_control`, 2 `DUT_Footer`, 3 `DUT_Header`; oscillation is `0x06`. The ROs were integrated last, on 12 September 2025, the day of the final submission.

## 3.4 SPI

`digital/rtl/spix/spi.v`, parameters `registers=8`, `inputs=6`, `sword=8`, `syncing=0` (one-hot shift counter), `addressing=1` (multiplexer read). Frame, sampled on the rising SCLK with CS low: write bit, read bit, `addr[2:0]`, `data[7:0]`, then, for a read, 8 bits shifted out on MISO. The register is written on the 14th edge; the bit counter only restarts on an SCLK edge with CS high. Synthesized to 108 `DFCNQD1` flops, 91 `MUX2D1` and about 140 other gates; macro 311.6 μm × 128.4 μm. Read map: register 0 = ADC result, 1 = {sample, valid}, 2/3 = constant `0xAA`/`0x55`, 4/5 = write registers 0/1 (echo). The SPI reset is the `adc_rst` pad (Section [8](08-spi-the-read-back-failure.md#8-spi-the-read-back-failure)).

---

[Contents](README.md) · Previous: [2 The chip](02-the-chip.md) · Next: [4 Design flow and tapeout sequence](04-design-flow-and-tapeout-sequence.md)
