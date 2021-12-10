# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2017 Hauke Mehrtens

include $(TOPDIR)/rules.mk

BOARDNAME:=Allwinner V3s (SPI-NAND)
FEATURES+=ubifs
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon-vfpv4
