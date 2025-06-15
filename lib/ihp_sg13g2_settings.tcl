if { [info exists ::env(PDK_ROOT)]} {
  # Setting a default
  set PDK_ROOT $::env(PDK_ROOT)
} else {
  # Setting a default
  set PDK_ROOT "/opt/OpenLane/share/pdk"
}

set LIB_PATHS "$PDK_ROOT"
set LIBS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib"
set LEFS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef "
set GDSS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds"

set LIBS_BC "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p65V_m40C.lib"
set LIBS_WC "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib"

# TODO: Not defined yet
#set RCX_RULES "$PDK_ROOT/sky130A/libs.tech/openlane/rules.openrcx.sky130A.nom.calibre"

