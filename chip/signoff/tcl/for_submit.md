# ASICONE Aug 2025 for IHP sg13g2 TO_Sep2025

## Contents:

- Self-generated 5-bit SAR ADC (SARADC). Source code to be published.
- SPI core.
- All digital cells are custom-made. 18-track cells (What a waste I am right?)
    - sg13g2 for custom-made regular cells
    - sg13g2f for floating-body cells (For the ADC)
- 38 pins. Using regular IO.

We still working on the feed-forward ring oscillators. Once finished, will be
put in the list.

## Versions of software

- IHP PDK (Final DRC, LVS and sims) - `6bda9f1cd9ae7108571041d9bd0f03a5a94f731f`
- Openroad - `59ef9a94573c0a6799d32e2dfc9fc7a93feeb30f`
- yosys - `4581f75b03a25b615a9715516854c424b580f7ab`
- klayout - `0.30.2` or `d1dc885235bf571eac7270d6dccca820a019b4b1`
- ngspice - `Public version 44.2`
- OpenVAF Reloaded - `802bce21ac44833b52c010cb90d37e0d6fddd4ac`

## Filestructure

The structure is done by [step|type]/step. Hope is not confusing.

```
  📁asicone_202508
   ┗ 📁sim              # Simulation files (ADC only)
   ┗ 📁drc              # DRC full-chip run
   ┗ 📁lvs              # LVS full-chip run
   ┗ 📁gds              # GDS submission
   ┗ 📁digital          # Digital flow for SPI
   ┗ 📁lib              # Custom standard cell library and modified IO
```

## Errdata and sins commited

- To pass LVS with IO, `ptap1` was ignored totally. We even also created a new 
  main rule file to just skip the ptaps (Why the ptap extractor gives me a diode 
  though?)
    - NOTE: Putting the `ptap1` as a diode in the source kinda works, but only 
      if you have ONE diode at a time. If you merge them in layout, will create 
      an unique diode, mismatching with the source if you have them separated.
- For convergence sake, sometimes we attached capactors to the transistors.
- In the IO cells, we added a missing `PolyRes` layer missing in some of the
  subcells for recognition of the resistors `rppd`.
- DRC passes almost fully. We have errors in the IO involving `Sdiod.d` and 
  `Sdiod.e`. No idea if we need to fix them.
- Source code for the SAR ADC generator is "To be Published". We are discussing 
  with the team at SymbioticEDA and the University of Tokyo. However, we provide
  enough information for simulation and LVS.
- Custom cells are sub-optimal. The standard cell generator is still on development.
- Characterization of cells are poor. Technically copied from `sky130`. This PDK
  doesn't have RC extraction of any kind, and makes the characterization impossible.
- We do not use OpenROAD-flow-scripts. The flow is custom.

May god forgive my actions and make this chip work.

# Acknoledge

- SARADC paper: [Read it here.](https://ieeexplore.ieee.org/document/11002493)
- Symbiotic EDA sponsored this tapeout.
