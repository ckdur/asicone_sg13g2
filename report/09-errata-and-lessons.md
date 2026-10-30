<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [8 SPI: the read-back failure](08-spi-the-read-back-failure.md) · Next: [10 Reproducing this report](10-reproducing-this-report.md)

# 9 Errata and lessons

| \# | Issue | Impact | Fix for the next chip |
|:---|:---|:---|:---|
| 1 | SPI read mux uses `addr` instead of `raddr` | MISO dead | One-line RTL fix; read regression |
| 2 | Undeclared `RESULT` in the top level | ADC result not readable by SPI | `` `default_nettype none ``; lint (Verilator) |
| 3 | SPI reset shared with `adc_rst`, opposite polarity | ADC and ROs exclusive | Separate reset pin or a register bit |
| 4 | DAC plate wiring differs per bit, halves not mirrored | ENOB 3.8 instead of 4.7 | Nested pattern, rail re-assignment, mirrored halves (done in `saradc_auto`) |
| 5 | No extraction at tapeout | Layout effects unseen | Split KLayout-PEX flow now available; make it a sign-off step |
| 6 | RO101 4.9× too fast, `DUT_Header` without effect | RO101 unusable for its purpose | Open: measurements of Section [7.2](07-ring-oscillator-measurement.md#72-is-the-mismatch-justified) |
| 7 | RO13 31 % slow | Calibration unclear | Measure supplies; separate RO grounds |
| 8 | 52 `Sdiod` DRC errors in IHP I/O | None seen | Follow IHP I/O updates |
| 9 | `ptap1` ignored in LVS; added `PolyRes` | Reduced LVS coverage | Upstream deck fixes |
| 10 | Liberty copied from `sky130` | Timing nominal | Characterize with extraction |
| 11 | Board: LMV358 front end, references undecoupled | HF ENOB, possible INL | FDA front end, decoupling (`pcbfix`) |

*Table 10: Errata.*

The common thread is verification coverage under schedule pressure: everything that DRC and LVS check was right on silicon (pad ring, supplies, connectivity of every block); everything that needed a functional simulation of the integrated design (the SPI read path, the top-level read word, the reset sharing) or a parasitic-aware simulation (the DAC, the rings) was not checked, and that is where the chip fails. A lint pass with implicit nets disabled and a top-level RTL testbench that reads every register would have caught issues 1–3 in minutes.

---

[Contents](README.md) · Previous: [8 SPI: the read-back failure](08-spi-the-read-back-failure.md) · Next: [10 Reproducing this report](10-reproducing-this-report.md)
