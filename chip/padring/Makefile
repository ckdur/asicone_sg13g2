ROOT_DIR=$(abspath ../../)
PRJ_DIR=$(abspath ../)
include $(PRJ_DIR)/settings.mk
PADRING_DIR=$(abspath .)
SIGN_DIR=$(abspath ../signoff)
SEAL_DIR=$(abspath ../sealring)
PNR_DIR=$(abspath ../pnr)
CELLS_DIR=$(abspath ./cells)

DEF=$(PADRING_DIR)/outputs/padring.def
GDS=$(PADRING_DIR)/outputs/padring.gds

export SIGN_DIR
export ROOT_DIR

all: $(DEF)

$(DEF): $(SYN_NET) $(PRJ_DIR)/rtl/${TOP}.padring.cfg
	mkdir -p $(PADRING_DIR)/outputs
	padring -v --lef $(TECH_PDK)/libs.ref/sg13g2_io/lef/sg13g2_io.lef --lef $(CELLS_DIR)/sg13g2_bondpad.lef --svg $(PADRING_DIR)/outputs/padring.svg --def $(DEF) --ver $(PADRING_DIR)/outputs/padring.v --csv $(PADRING_DIR)/outputs/padring.csv $(PRJ_DIR)/rtl/${TOP}.padring.cfg | tee $(PADRING_DIR)/padring.log
	sed -i "s|PLACED|FIXED|g" $(DEF)

gds: $(GDS)

$(GDS): $(SIGN_DIR)/tcl/gds.tcl $(SIGN_DIR)/tcl/def2stream.py $(DEF)
	mkdir -p $(SIGN_DIR)/outputs
	mkdir -p $(SIGN_DIR)/reports
ifeq ($(PDK_FILE),none)
	klayout -zz -rd design_name=padring \
	        -rd in_def=$(DEF) \
	        -rd lef_files="$(ROOT_DIR)/lib/$(TECH).tech.lef $(ROOT_DIR)/lib/$(TECH).lef $(TECH_PDK)/libs.ref/sg13g2_io/lef/sg13g2_io.lef $(PNR_DIR)/outputs/SPI.lef $(SEAL_DIR)/sealring.lef $(CELLS_DIR)/sg13g2_bondpad.lef" \
	        -rd in_files="$(ROOT_DIR)/lib/$(TECH).gds $(TECH_PDK)/libs.ref/sg13g2_io/gds/sg13g2_io.gds $(SIGN_DIR)/outputs/SPI.gds $(SEAL_DIR)/sealring.gds $(CELLS_DIR)/sg13g2_bondpad.gds" \
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

clean:
	rm -vrf fv/ outputs reports *.size *.log DesignLib

.PHONY: all manual clean

