ROOT_DIR=$(abspath ../../)
PRJ_DIR=$(abspath ../)
include $(PRJ_DIR)/settings.mk
PNR_DIR=$(abspath .)
SYN_DIR=$(abspath ../syn)

export SYN_DIR
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
export PDK_ROOT

SYN_NET=$(SYN_DIR)/outputs/$(TOP)_net.v
export SYN_NET

all: $(PNR_DIR)/outputs/$(TOP).def

$(PNR_DIR)/outputs/$(TOP).def: $(SYN_NET) $(PNR_DIR)/tcl/pnr.tcl
	openroad -exit $(PNR_DIR)/tcl/pnr.tcl | tee -a openroad.log

manual: $(SYN_NET) $(PNR_DIR)/tcl/pnr.tcl
	openroad -gui $(PNR_DIR)/tcl/pnr.tcl

clean:
	rm -vrf fv/ outputs reports *.size *.log DesignLib

.PHONY: all manual clean

