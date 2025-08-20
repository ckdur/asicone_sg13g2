#!/usr/bin/tcl
crashbackups stop
#gds flatglob *__example_*
#gds flatten true
gds read $env(GDS)
set base [file rootname $env(GDS)]

# Get all the cells
set cells [cellname list allcells]
foreach cell $cells {
  if {[string match "sg13g2_bpd*" $cell]} {
    load $cell
    select top cell
    property LEFclass BLOCK
    # TODO: Maybe this site name shall be configurable
    # property LEFsite obssite
    property LEFsymmetry "X Y R90"
    lef write $base.$cell.lef
  }
} 

quit

