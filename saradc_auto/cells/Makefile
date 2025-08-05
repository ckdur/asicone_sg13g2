ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
CELLS_DIR=$(abspath .)
SCRIPTS_DIR=$(ROOT_DIR)/scripts

gds2lef_file=$(SCRIPTS_DIR)/gds2lef.sh

# Force the magic PDK file
PDK_FILE=$(TECH_PDK)/libs.tech/magic/ihp-sg13g2.magicrc

CELLS ?= SARADC_CELL_INVX0_ASSW SARADC_CELL_INVX16_ASCAP SARADC_FILLTIE2

LEFS = $(CELLS:%=%.lef)

all: $(LEFS)

%.lef: %.gds
	bash $(gds2lef_file) $*.gds $*.port.csv $(PDK_FILE)
	mv $*.$*.lef $*.lef

clean:
	rm -rf *.lef
