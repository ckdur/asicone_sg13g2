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
NET=$(PNR_DIR)/outputs/$(TOP).cdl
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
	        -rd lef_files="$(ROOT_DIR)/lib/$(TECH).tech.lef $(ROOT_DIR)/lib/$(TECH).lef" \
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

drc: $(GDS)
	python3 $(SIGN_DIR)/tcl/klayout_gds_drc_check.py --gds_input_file_path $(GDS) --output_directory $(SIGN_DIR)/reports --design_name $(TOP) --drc_rules $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_minimal.lydrc

drc_magic: $(GDS)
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc $(SIGN_DIR)/tcl/run_magic_drc.tcl

$(SPICE): $(ROOT_DIR)/lib/$(TECH).cdl $(NET)
	cat $(ROOT_DIR)/lib/$(TECH).cdl $(NET) > $(SPICE)

lvs: $(GDS) $(SPICE)
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/lvs/sg13g2_full.lylvs -rd in_gds=$(GDS) -rd report_file=$(SIGN_DIR)/reports/lvs_report.lvsdb -rd cdl_file=$(SPICE) -rd target_netlist=$(SIGN_DIR)/reports/$(TOP).lay.cdl

clean:
	rm -vrf  outputs reports

.PHONY: all manual clean

