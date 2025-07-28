ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
PNR_DIR=$(abspath .)
PADRING_DIR=$(abspath ../padring)
PNR_DIG_DIR=$(abspath ../pnr)
RTL_DIR=$(abspath ../rtl)

export PNR_DIR
export TOP
export ROOT_DIR
export CHIPX
export CHIPY
export TECH
export PDK_ROOT
export RTL_DIR
export PADRING_DIR

CHIP_NET=$(RTL_DIR)/$(CHIP_TOP).v
export CHIP_NET

CHIP_TOP?=asicone
export CHIP_TOP

OTHER_LEF=$(PNR_DIG_DIR)/outputs/SPI.lef
export OTHER_LEF
OTHER_GDS=$(PNR_DIG_DIR)/outputs/SPI.gds
export OTHER_GDS

DEF=$(PNR_DIR)/outputs/asicone.def
DEF_PADRING=$(PADRING_DIR)/outputs/asicone.def
DEF_MACRO=$(RTL_DIR)/macro.def

all: $(DEF)

$(DEF): $(CHIP_NET) $(DEF_PADRING) $(DEF_MACRO) $(PNR_DIR)/tcl/pnr.tcl
	openroad -exit $(PNR_DIR)/tcl/pnr.tcl | tee -a openroad.log

manual: $(CHIP_NET) $(DEF_PADRING) $(DEF_MACRO) $(PNR_DIR)/tcl/pnr.tcl
	openroad -gui $(PNR_DIR)/tcl/pnr.tcl

clean:
	rm -vrf fv/ outputs reports *.size *.log DesignLib

.PHONY: all manual clean

