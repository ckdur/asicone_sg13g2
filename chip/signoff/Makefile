ROOT_DIR=$(abspath ../../)
PRJ_DIR=$(abspath ../)
include $(PRJ_DIR)/settings.mk
PNR_DIR=$(abspath ../pnr)
SYN_DIR=$(abspath ../syn)
PADRING_DIR=$(abspath ../padring)
SEALRING_DIR=$(abspath ../sealring)
SIGN_DIR=$(abspath .)

GDS=$(SIGN_DIR)/outputs/$(TOP).gds
GDSFILL=$(SIGN_DIR)/outputs/$(TOP).fill.gds
DEF=$(PNR_DIR)/outputs/$(TOP).def

SPICE=$(SIGN_DIR)/outputs/$(TOP).spice
NET=$(PNR_DIR)/outputs/$(TOP).cdl

PDK_ROOT?=/opt/ext/OpenPDKs/IHP-Open-PDK
PDK?=ihp-sg13g2
TECH_PDK=$(PDK_ROOT)/$(PDK)
#PDK_FILE ?= $(TECH_PDK)/libs.tech/magic/$(PDK).magicrc
PDK_FILE?=none
PDK_KFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyp
PDK_KNFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyt
export PDK_ROOT
export PDK

ADC_CELLS ?= SARADC_CELL_INVX0_ASSW SARADC_CELL_INVX16_ASCAP SARADC_FILLTIE2 SARADC_FILL1 SARADC_FILL1_NOPOWER
ADC_CDLS = $(ADC_CELLS:%=$(ROOT_DIR)/saradc_auto/cells/%.cdl)
ADC_LEFS = $(ADC_CELLS:%=$(ROOT_DIR)/saradc_auto/cells/%.lef)
ADC_GDSS = $(ADC_CELLS:%=$(ROOT_DIR)/saradc_auto/cells/%.gds)

CDLS = $(ROOT_DIR)/lib/sg13g2_io.custom.cdl $(PADRING_DIR)/cells/sg13g2_bondpad.cdl $(PADRING_DIR)/cells/sg13g2_io_mod.cdl $(SEALRING_DIR)/sealring.cdl $(ROOT_DIR)/saradc_auto/cells/sg13g2f.cdl $(ADC_CDLS) $(ROOT_DIR)/saradc_auto/pnr/outputs/SARADC.cdl $(ROOT_DIR)/digital/pnr/outputs/SPI.cdl 
LEFS = $(ROOT_DIR)/lib/sg13g2_io.custom.lef $(PADRING_DIR)/cells/sg13g2_bondpad.lef $(PADRING_DIR)/cells/sg13g2_io_mod.lef $(SEALRING_DIR)/sealring.lef $(ROOT_DIR)/saradc_auto/cells/sg13g2f.lef $(ADC_LEFS) $(ROOT_DIR)/saradc_auto/pnr/outputs/SARADC.lef $(ROOT_DIR)/digital/pnr/outputs/SPI.lef
GDSS = $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_io/gds/sg13g2_io.gds $(PADRING_DIR)/cells/sg13g2_bondpad.gds $(PADRING_DIR)/cells/sg13g2_io_mod.gds $(SEALRING_DIR)/sealring.gds $(ROOT_DIR)/saradc_auto/cells/sg13g2f.gds $(ADC_GDSS) $(ROOT_DIR)/saradc_auto/signoff/outputs/SARADC.gds $(ROOT_DIR)/digital/signoff/outputs/SPI.gds

gds: $(GDS)

$(SIGN_DIR)/outputs/%.gds: $(PNR_DIR)/outputs/%.def
	mkdir -p $(SIGN_DIR)/outputs
	mkdir -p $(SIGN_DIR)/reports
	mkdir -p $(SIGN_DIR)/reports_no_filler
ifeq ($(PDK_FILE),none)
	klayout -zz -rd design_name=$(TOP) \
	        -rd in_def=$< \
	        -rd lef_files="$(ROOT_DIR)/lib/$(TECH).tech.lef $(ROOT_DIR)/lib/$(TECH).lef $(LEFS)" \
	        -rd in_files="$(ROOT_DIR)/lib/$(TECH).gds $(GDSS)" \
	        -rd seal_file="" \
	        -rd out_file=$@ \
	        -rd tech_file=$(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyt \
	        -rd layer_map=$(TECH_PDK)/libs.tech/klayout/tech/sg13g2.map \
	        -r $(SIGN_DIR)/tcl/def2stream.py
else
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc $(SIGN_DIR)/tcl/gds.tcl
endif

view_no_filler: $(GDS)
	klayout -nn $(PDK_KNFILE) -s $(GDS)

drc_no_filler: $(GDS)
	python3 $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/run_drc.py --path=$(GDS) --mp=10 --run_dir=$(SIGN_DIR)/reports_no_filler/ --topcell=$(TOP) --run_mode=flat --density_thr=10 --antenna

$(SPICE): $(ROOT_DIR)/lib/$(TECH).cdl $(CDLS) $(NET)
	cat $(ROOT_DIR)/lib/$(TECH).cdl $(CDLS) $(NET) > $(SPICE)

lvs_no_filler: $(GDS) $(SPICE)
#	python3 $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/lvs/run_lvs.py --layout=$(GDS) --netlist=$(SPICE) --run_dir=$(SIGN_DIR)/reports_no_filler/ --topcell=$(TOP) --run_mode=flat --verbose
	python3 $(ROOT_DIR)/lib/run_lvs.py --custom_deck=$(SIGN_DIR)/lvs_custom/full_chip_custom.lvs --layout=$(GDS) --netlist=$(SPICE) --run_dir=$(SIGN_DIR)/reports_no_filler/ --topcell=$(TOP) --run_mode=flat --verbose

filler: $(GDSFILL)

$(GDSFILL): $(GDS)
	klayout -nn $(PDK_KNFILE) -n sg13g2 -zz -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/scripts/filler.py -rd output_file=$(GDSFILL) $(GDS)

view: $(GDSFILL)
	klayout -nn $(PDK_KNFILE) -s $(GDSFILL)

drc: $(GDSFILL)
	python3 $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/run_drc.py --path=$(GDSFILL) --mp=10 --run_dir=$(SIGN_DIR)/reports/ --topcell=$(TOP) --run_mode=flat --density_thr=10 --antenna

lvs: $(GDSFILL) $(SPICE)
#	Ohh my god... why there is no way to put custom scripts in the LVS?!?!?!?!
#	python3 $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/lvs/run_lvs.py --layout=$(GDSFILL) --netlist=$(SPICE) --run_dir=$(SIGN_DIR)/reports/ --topcell=$(TOP) --run_mode=flat --verbose
	python3 $(ROOT_DIR)/lib/run_lvs.py --custom_deck=$(SIGN_DIR)/lvs_custom/full_chip_custom.lvs --layout=$(GDSFILL) --netlist=$(SPICE) --run_dir=$(SIGN_DIR)/reports/ --topcell=$(TOP) --run_mode=flat --verbose

clean:
	rm -vrf  outputs reports reports_no_filler

.PHONY: all manual clean

