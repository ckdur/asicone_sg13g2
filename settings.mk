#######################################################
# Proportional dimmentions
ROOT_DIR?=$(abspath .)
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
TOP?=SPI
CHIP_TOP?=asicone

ifeq ($(TOP),aes)
	AES_DIR=$(ROOT_DIR)/rtl/aes
	SYN_SRC?=$(AES_DIR)/src/rtl/aes_core.v \
		$(AES_DIR)/src/rtl/aes_decipher_block.v \
		$(AES_DIR)/src/rtl/aes_encipher_block.v \
		$(AES_DIR)/src/rtl/aes_inv_sbox.v \
		$(AES_DIR)/src/rtl/aes_key_mem.v \
		$(AES_DIR)/src/rtl/aes_sbox.v \
		$(AES_DIR)/src/rtl/aes.v
endif

ifeq ($(TOP),SPI)
	SPIX_DIR=$(ROOT_DIR)/rtl/spix
	SYN_SRC?=$(SPIX_DIR)/spi.v
	PX:=1
	PY:=1
endif

ifeq ($(TOP),mand)
	AND_DIR=$(ROOT_DIR)/rtl/and
	SYN_SRC?=$(AND_DIR)/and.v
	PX:=1
	PY:=1
	PR:=0.5
endif

#######################################################
# Rules to create the files. 
# If there is no really rules, then can leave it blank

PDK_ROOT?=/opt/ext/OpenPDKs/IHP-Open-PDK
PDK?=ihp-sg13g2
TECH_PDK=$(PDK_ROOT)/$(PDK)
PDK_FILE?=none
PDK_KFILE ?= $(TECH_PDK)/libs.tech/klayout/tech/sg13g2.lyp
