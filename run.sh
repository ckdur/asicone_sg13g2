#!/bin/bash

# This is an example of running all the steps for the different designs
# in the asicone 202509

set -e -x

# Digital flow. Synthesis and PnR of the SPI
make -C digital/syn all
make -C digital/pnr all
make -C digital/signoff gds
make -C digital/signoff drc
make -C digital/signoff lvs

# SARADC flow
#  Synthesis and PnR of the ADC
make -C saradc_auto/syn all
make -C saradc_auto/pnr all
make -C saradc_auto/signoff gds
make -C saradc_auto/signoff drc
make -C saradc_auto/signoff lvs

#  Simulation (NOTE: The FFT takes 1 day to finish)
make -C saradc_auto/sim test_cap_linearity
make -C saradc_auto/sim test_sw_charge_injection
make -C saradc_auto/sim test_fft

# ro_reliability tests
#  DRC and LVS of all cells, and the TOPs
(cd ro_reliability/gds && bash run_drc.sh top_RO_core_13)
(cd ro_reliability/gds && bash run_drc.sh top_RO_core_101)
(cd ro_reliability/gds && bash run_lvs.sh top_RO_core_13)
(cd ro_reliability/gds && bash run_lvs.sh top_RO_core_101)

#  TODO: Simulations are possible, but need a way to do it automatic

# asicone flow
#  Padring generation and PnR integration
make -C chip/padring all
make -C chip/pnr all

#  TODO: This is the only step that returns error for some reason
#        It generates the GDS correctly tho
set +e
make -C chip/signoff gds
set -e

make -C chip/signoff filler
make -C chip/signoff drc
make -C chip/signoff lvs
