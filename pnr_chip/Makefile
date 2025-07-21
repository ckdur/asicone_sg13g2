ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
PNR_DIR=$(abspath .)
PADRING_DIR=$(abspath ../padring)
PNR_DIG_DIR=$(abspath ../pnr)
RTL_DIR=$(abspath ../rtl)

export PNR_DIR
export SYN_SRC
export TOP
export ROOT_DIR
export PX
export PY
export PR
export X
export Y
export TECH

CHIP_NET=$(RTL_DIR)/rtl/$(CHIP_TOP).v
export CHIP_NET

DEF=$(PNR_DIR)/outputs/asicone.def
DEF_PADRING=$(PNR_DIR)/outputs/asicone.def
DEF_MACRO=$(RTL_DIR)/macro.def

all: $(DEF)

$(DEF): $(CHIP_NET) $(DEF_PADRING) $(DEF_MACRO) $(PNR_DIR)/tcl/pnr.tcl
	openroad -exit $(PNR_DIR)/tcl/pnr.tcl | tee -a openroad.log

manual: $(CHIP_NET) $(DEF_PADRING) $(DEF_MACRO) $(PNR_DIR)/tcl/pnr.tcl
	openroad -gui $(PNR_DIR)/tcl/pnr.tcl

clean:
	rm -vrf fv/ outputs reports *.size *.log DesignLib

.PHONY: all manual clean

