<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [7 Ring oscillator measurement](07-ring-oscillator-measurement.md) · Next: [9 Errata and lessons](09-errata-and-lessons.md)

# 8 SPI: the read-back failure

## 8.1 Symptom

Writes reach the registers (the ROs obey them), but MISO never returns the expected data: neither the constant registers `0xAA`/`0x55` nor the echo of the written registers.

## 8.2 Cause: one identifier

In `digital/rtl/spix/spi.v` the read multiplexer is indexed by the *write* address:

    assign addr  = sft_reg[numbit_waddress-1+sword:sword];  // Full handshake
    assign raddr = sft_reg[numbit_raddress-1:0];            // When the handshake is on addr
    ...
    assign bus_rd = RDA[addr];        // taped out  -- should be RDA[raddr]

The read word is captured into `bus_cap` after only five bits of the frame (`encap = sync[numbit_address+2]`), when the address sits in the low bits of the shift register, i.e. in `raddr`. `addr` points 8 bits higher, where at that moment the shift register holds bits of the *previous* frame (after five shifts, its data bits \[5:3\]). The multiplexer therefore selects a stale index: for the zero-padded read frames this is index 0, the ADC-result register, and indices 6 and 7 do not exist (`inputs=6`). The output shift register, `DOUTNOZ` and the `miso` pad are correct; only the selected word is wrong.

A second error compounds it at the top level: `chip/rtl/asicone_202508.v` builds the read word from `RESULT[0..4]`, an identifier that is never declared (the ADC outputs are `pad_adc_result_*_c2p`). Verilog’s implicit nets let it through synthesis, PnR and LVS as an undriven 5-bit net, so register 0 is floating on silicon. Together: almost every read returns the undriven register 0, which matches the dead MISO.

## 8.3 Confirmation

`report/sim/run.sh` reads the SPI with 21-clock frames and the read map of the chip, with the RTL as taped out and with the one-line fix:

``` 
== as taped out              == with RDA[raddr]
read addr 2 -> xx            read addr 2 -> aa
read addr 3 -> 00            read addr 3 -> 55
read addr 4 -> 00            read addr 4 -> 06   (R0 echo)
read addr 5 -> 00            read addr 5 -> 3c   (R1 echo)
```

(`xx`: out-of-range index 7 selected by the data of the preceding write.)

## 8.4 Why it escaped

The module testbench (`spi_tb.v`) still connected a port `DOUT` that had been split into `DOUT_DAT`/`DOUT_EN`; it no longer elaborates, so the read path was not simulated after that change, and the full-chip verification was DRC and LVS only, which compare layout with netlist and cannot see a logic error. A third issue is architectural, not a typo: the SPI reset is the `adc_rst` pad, active low for the SPI and active high for the ADC, so the RO configuration is cleared whenever the ADC runs: the ADC and the ROs cannot be operated at the same time.

---

[Contents](README.md) · Previous: [7 Ring oscillator measurement](07-ring-oscillator-measurement.md) · Next: [9 Errata and lessons](09-errata-and-lessons.md)
