#######################################################
# Proportional dimmentions
ROOT_DIR?=$(abspath ..)
TECH?=sg13g2

PX?=4
PY?=2
PR?=0.75

DISPX=100
DISPY=100
DISPW=100
DISPH=100

CHIPX?=1000
CHIPY?=1000

#######################################################
# Rules to create the files. 
# If there is no really rules, then can leave it blank
TOP?=saradc
CHIP_TOP?=asicone

SARADC_DIR=$(ROOT_DIR)/saradc_auto
SYN_SRC?=$(ROOT_DIR)/saradc_auto/rtl/cap.v \
$(ROOT_DIR)/saradc_auto/rtl/cdac_dummy.v \
$(ROOT_DIR)/saradc_auto/rtl/cdac_unit.v \
$(ROOT_DIR)/saradc_auto/rtl/cdac.v \
$(ROOT_DIR)/saradc_auto/rtl/cell_def.v \
$(ROOT_DIR)/saradc_auto/rtl/comp.v \
$(ROOT_DIR)/saradc_auto/rtl/saradc_analog.v \
$(ROOT_DIR)/saradc_auto/rtl/sw.v \
$(ROOT_DIR)/saradc_auto/rtl/sar_logic_buf.v \
$(ROOT_DIR)/saradc_auto/rtl/saradc.v

#######################################################
# Rules to create the files. 
# If there is no really rules, then can leave it blank

PDK_ROOT?=/opt/ext/OpenPDKs/IHP-Open-PDK
PDK?=ihp-sg13g2
TECH_PDK=$(PDK_ROOT)/$(PDK)
PDK_FILE?=none
PDK_KFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyp
