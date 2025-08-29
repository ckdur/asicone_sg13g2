
ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
SIM_DIR=$(abspath .)

TB_ANA_SRC=$(ROOT_DIR)/src/saradc_tb.sp
CDL_SRC=$(ROOT_DIR)/pnr/outputs/$(TOP).cdl

# For now, just using the LVS result.
# Replace me with the actual RCX when ready
TB_RCX_SRC=$(ROOT_DIR)/src/saradc_tb_rcx.sp
RCX_SRC=$(ROOT_DIR)/signoff/results/$(TOP).cir

TB_SRC=$(ROOT_DIR)/rtl/sar_logic_tb.v
VER_SIM_SRC=$(ROOT_DIR)/rtl/$(DIGTOP).v
SYN_SIM_SRC=$(ROOT_DIR)/syn/outputs/$(DIGTOP)_net.v

ana: $(SIM_DIR)/outputs/saradc_tb.csv

rcx: $(SIM_DIR)/outputs/saradc_tb_rcx.csv

sim: $(SIM_DIR)/outputs/sar_logic_tb.vcd

syn: $(SIM_DIR)/outputs/sar_logic_tb_syn.vcd

# Simulation commands
$(SIM_DIR)/outputs/saradc_tb.csv: $(TB_ANA_SRC) $(CDL_SRC)
	mkdir -p $(SIM_DIR)/outputs
	cd $(SIM_DIR)/outputs/ && ngspice $(TB_ANA_SRC)

$(SIM_DIR)/outputs/saradc_tb_rcx.csv: $(TB_RCX_SRC) $(RCX_SRC)
	mkdir -p $(SIM_DIR)/outputs
	cd $(SIM_DIR)/outputs/ && ngspice $(TB_RCX_SRC)

$(SIM_DIR)/outputs/sar_logic_tb.vcd: $(TB_SRC) $(VER_SIM_SRC)
	mkdir -p $(SIM_DIR)/outputs
	iverilog -D DIGTOP=$(DIGTOP) -s sar_logic_tb -o $(SIM_DIR)/outputs/$(TOP).o $(TB_SRC) $(VER_SIM_SRC)
	cd $(SIM_DIR)/outputs && $(SIM_DIR)/outputs/$(TOP).o

$(SIM_DIR)/outputs/sar_logic_tb_syn.vcd: $(TB_SRC) $(SYN_SIM_SRC)
	mkdir -p $(SIM_DIR)/outputs
	iverilog -D DIGTOP=$(DIGTOP) -D SYNTHESIS=1 -m sar_logic_tb -o $(SIM_DIR)/outputs/$(TOP)_syn.o $(TB_SRC) $(SYN_SIM_SRC) $(ROOT_DIR)/cells/sg13g2f.v
	cd $(SIM_DIR)/outputs && $(SIM_DIR)/outputs/$(TOP)_syn.o

clean:
	rm -rfv *.log* *.ic* *.tr* *.su* *.mt* *.st* *.pa*

# TODO: What to use as a waveform viewer?
viewana: $(ROOT_DIR)/outputs/saradc_tb.csv $(SIM_DIR)/scripts/plot.vin_vout.gnu
	gnuplot -c $(SIM_DIR)/scripts/plot.vin_vout.gnu $(ROOT_DIR)/outputs/saradc_tb.csv $(ROOT_DIR)/outputs/saradc_tb.vin_vout.pdf "Vin vs Vout"
	gnuplot -c $(SIM_DIR)/scripts/plot.result.gnu $(ROOT_DIR)/outputs/saradc_tb.csv $(ROOT_DIR)/outputs/saradc_tb.result.pdf "Results"

viewsim: $(SIM_DIR)/outputs/sar_logic_tb.vcd
	gtkwave $(SIM_DIR)/outputs/sar_logic_tb.vcd

viewsyn: $(SIM_DIR)/outputs/sar_logic_tb_syn.vcd
	gtkwave $(SIM_DIR)/outputs/sar_logic_tb_syn.vcd

.PHONY: clean

