# This defines additional macros that will be intgrated

set ROOT_DIR $env(ROOT_DIR)
set PRJ_DIR $env(PRJ_DIR)

lappend LEFS "${ROOT_DIR}/digital/pnr/outputs/SPI.lef"
lappend LEFS "${ROOT_DIR}/saradc_auto/pnr/outputs/SARADC.lef"
lappend LEFS "${PRJ_DIR}/padring/cells/sg13g2_io_mod.lef"
lappend LEFS "${PRJ_DIR}/padring/cells/sg13g2_bondpad.lef"
lappend LEFS "${PRJ_DIR}/sealring/sealring.lef"

lappend GDSS "${ROOT_DIR}/digital/signoff/outputs/SPI.gds"
lappend GDSS "${ROOT_DIR}/saradc_auto/signoff/outputs/SARADC.gds"
lappend GDSS "${PRJ_DIR}/padring/cells/sg13g2_io_mod.gds"
lappend GDSS "${PRJ_DIR}/padring/cells/sg13g2_bondpad.gds"
lappend GDSS "${PRJ_DIR}/sealring/sealring.gds"

lappend CDLS "${ROOT_DIR}/digital/pnr/outputs/SPI.cdl"
lappend CDLS "${ROOT_DIR}/saradc_auto/pnr/outputs/SARADC.cdl"
