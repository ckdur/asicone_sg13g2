<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [9 Errata and lessons](09-errata-and-lessons.md)

# 10 Reproducing this report

Chip  
`asicone_sg13g2` (`chip/`, `digital/`, `ro_reliability/`, `saradc_auto/`); submission copy in `TO_Sep2025/asicone_202509`. Note that `saradc_auto/pnr/outputs` now holds the hierarchical ADC; the taped-out ADC is in `saradc_auto/*/outputs.tapeout`.

ADC bench  
`RISCVConsole/software/mso`: `adc_sweep.sh`, then  
`make -C report RESULTS=../results/sweep_20261022`.  
Simulation: `saradc_auto/sim` (`char.sh`), extraction `saradc_auto/pex/split.py`.

RO bench  
`RISCVConsole/software/ro`: `ro_run.sh`, then  
`make -C report RESULTS=../results/ro_20261029`.  
Simulation and extraction: `ro_reliability/sim` (`ro_sim.py`, `pex/run_all.sh`).

SPI  
`report/sim/run.sh` (iverilog).

Board  
`pcbs/IHP130_ASICONE_ADP_QFN48_0p5Q_Adapter` (KiCad, BOM, CPL).

This document  
`latexmk -pdf report.tex` in `report/`.

---

[Contents](README.md) · Previous: [9 Errata and lessons](09-errata-and-lessons.md)
