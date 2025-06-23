ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
PNR_DIR=$(abspath ../pnr)
SYN_DIR=$(abspath ../syn)
SIGN_DIR=$(abspath .)

GDS=$(SIGN_DIR)/outputs/$(TOP).gds
export GDS
SPICE=$(SIGN_DIR)/outputs/$(TOP).spice
export SPICE
DEF=$(PNR_DIR)/outputs/$(TOP).def
export DEF
NET=$(PNR_DIR)/outputs/$(TOP)_pg.v
export NET
export TOP
export TECH
export SIGN_DIR
export ROOT_DIR

PDK_ROOT?=/opt/ext/OpenPDKs/IHP-Open-PDK
PDK?=ihp-sg13g2
TECH_PDK=$(PDK_ROOT)/$(PDK)
#PDK_FILE ?= $(TECH_PDK)/libs.tech/magic/$(PDK).magicrc
PDK_FILE?=none
PDK_KFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyp
export PDK_ROOT
export PDK

gds: $(GDS)

$(GDS): $(SIGN_DIR)/tcl/gds.tcl $(SIGN_DIR)/tcl/def2stream.py $(DEF)
	mkdir -p $(SIGN_DIR)/outputs
	mkdir -p $(SIGN_DIR)/reports
ifeq ($(PDK_FILE),none)
	klayout -zz -rd design_name=$(TOP) \
	        -rd in_def=$(DEF) \
	        -rd in_files="$(ROOT_DIR)/lib/$(TECH).gds" \
	        -rd seal_file="" \
	        -rd out_file=$(GDS) \
	        -rd tech_file=$(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyt \
	        -rd layer_map=$(TECH_PDK)/libs.tech/klayout/tech/sg13g2.map \
	        -r $(SIGN_DIR)/tcl/def2stream.py
else
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc $(SIGN_DIR)/tcl/gds.tcl
endif

view: $(GDS)
	klayout -s $(GDS) -l $(PDK_KFILE)

spice: $(SPICE)

$(SPICE): $(SIGN_DIR)/tcl/spice.tcl $(DEF)
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc $(SIGN_DIR)/tcl/spice.tcl

drc: $(GDS)
	python3 $(SIGN_DIR)/tcl/klayout_gds_drc_check.py --gds_input_file_path $(GDS) --output_directory $(SIGN_DIR)/reports --design_name $(TOP)

drc_magic: $(GDS)
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc $(SIGN_DIR)/tcl/run_magic_drc.tcl

lvs: $(GDS) $(SPICE) $(NET)
# TODO: For LVS to work, we need to extract a .spice from a _pg.v file
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/lvs/sky130.lvs -rd input=$(GDS) -rd report=$(SIGN_DIR)/reports/lvs_report.lvsdb -rd schematic=$(SPICE) -rd thr=2 -rd run_mode=deep -rd target_netlist=$(SIGN_DIR)/outputs/$(TOP).ext.spice -rd scale=true -rd lvs_sub=VNB

lvs_netgen: $(GDS) $(SPICE) $(NET)
# TODO: For LVS to work, we need to also extract a _pg.v from DEF using OpenROAD
# This process seems a little hacky, using a weird "power_utils.py"
# The process is not yet supported
	echo "lvs {$(SPICE) $(TOP)} {$(NET) $(TOP)} $(PDK_ROOT)/$(PDK)/libs.tech/netgen/$(PDK)_setup.tcl $(SIGN_DIR)/reports/netgen.lvs.log -json" > $(SIGN_DIR)/outputs/netgen.lvs
	netgen -batch source $(SIGN_DIR)/outputs/netgen.lvs

clean:
	rm -vrf  outputs reports

.PHONY: all manual clean

