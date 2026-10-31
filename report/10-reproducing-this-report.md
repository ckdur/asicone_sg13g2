<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [9 Errata and lessons](09-errata-and-lessons.md)

# 10 Reproducing this report

The measurements are repeated with RISCVConsole (<https://github.com/ckdur/RISCVConsole>, branch `adc-sim-comparison`, commit `c32ae7a`) on the bench of Section [5](05-measurement-environment.md#5-measurement-environment), built from the adapter board in <https://gitlab.symbioticeda.com/ckdur.iso/pcbs> (commit `3b43187`).

Chip  
`asicone_sg13g2` (`chip/`, `digital/`, `ro_reliability/`, `saradc_auto/`); submission copy in `TO_Sep2025/asicone_202509`. Note that `saradc_auto/pnr/outputs` now holds the hierarchical ADC; the taped-out ADC (`saradc_auto/*/outputs.tapeout`, git-ignored) is archived in the release `tapeout-T594`: <https://github.com/ckdur/saradc_auto/releases/tag/tapeout-T594> (mirror: <https://gitlab.symbioticeda.com/ckdur.iso/saradc_auto/-/releases/tapeout-T594>).

ADC bench  
`RISCVConsole/software/mso`: `adc_sweep.sh`, then  
`make -C report RESULTS=../results/sweep_20261022`.  
Simulation: `saradc_auto/sim` (`char.sh`), extraction `saradc_auto/pex/split.py`.

RO bench  
`RISCVConsole/software/ro`: `ro_run.sh`, then  
`make -C report RESULTS=../results/ro_20261029`.  
Simulation and extraction: `ro_reliability/sim` (`ro_sim.py`, `pex/run_all.sh`).

Bench data  
The measured data of this report (raw captures, CSV, logs) is kept here, in `report/data/adc_sweep_20261022` and `report/data/ro_20261029`. To rebuild the bench reports without the bench, copy them into a RISCVConsole checkout as `software/mso/results/sweep_20261022` and `software/ro/results/ro_20261029` and run the two `make` commands above. With Matplotlib 3.11.2 this gives the same `results.json`, tables and figures as this report (`fig/adc_*.pdf` and `fig/ro_*.pdf` are the bench reports’ `fig/*.pdf`).

SPI  
`report/sim/run.sh` (iverilog).

Board  
`pcbs/IHP130_ASICONE_ADP_QFN48_0p5Q_Adapter` (KiCad, BOM, CPL), <https://gitlab.symbioticeda.com/ckdur.iso/pcbs>.

This document  
`latexmk -pdf report.tex` in `report/`.

---

[Contents](README.md) · Previous: [9 Errata and lessons](09-errata-and-lessons.md)
