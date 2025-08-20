ROOT_DIR=$(abspath ../../)
include $(ROOT_DIR)/settings.mk
CELLS_DIR=$(abspath .)

gds2lef_file=$(CELLS_DIR)/gds2lef.sh

# Force the magic PDK file
PDK_FILE=$(TECH_PDK)/libs.tech/magic/ihp-sg13g2.magicrc

CELLS ?= sg13g2_bondpad

LEFS = $(CELLS:%=%.lef)

all: $(LEFS)

%.lef: %.gds
	bash $(gds2lef_file) $*.gds $(PDK_FILE)
	python create_lef_library.py $(CELLS_DIR) $*
	rm -rf $*.*.lef

clean:
	rm -rf *.lef
