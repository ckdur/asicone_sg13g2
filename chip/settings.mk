#######################################################
# Proportional dimmentions
ROOT_DIR?=$(abspath ..)

# Can be any
#TECH?=ihp_sg13g2
TECH?=sg13g2

# Make sure these match your .cfg
X?=1160
Y?=1122

#######################################################
# TOP name
TOP=asicone_202508
SYN_NET=$(PRJ_DIR)/rtl/asicone_202508.v

#######################################################
# Rules to create the files. 
# If there is no really rules, then can leave it blank

PDK_ROOT?=/opt/ext/OpenPDKs/IHP-Open-PDK
PDK?=ihp-sg13g2
TECH_PDK=$(PDK_ROOT)/$(PDK)
PDK_FILE?=none
PDK_KFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyp
