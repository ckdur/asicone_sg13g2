if { [info exists ::env(PDK_ROOT)]} {
  # Setting a default
  set PDK_ROOT $::env(PDK_ROOT)
} else {
  # Setting a default
  set PDK_ROOT "/opt/OpenLane/share/pdk"
}

set LIB_PATHS "$PDK_ROOT"
set LIBS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib"
set LEFS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io.lef"
set GDSS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/gds/sg13g2_io.gds"
set CDLS "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/cdl/sg13g2_io.cdl"

set LIBS_BC "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p65V_m40C.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_fast_1p65V_3p6V_m40C.lib"
set LIBS_WC "${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_slow_1p08V_3p0V_125C.lib"

# TODO: Not defined yet
set ROOT_DIR $env(ROOT_DIR)
set RCX_RULES "${ROOT_DIR}/lib/sg13g2.rules"

set techsite "CoreSite"
set techname "sg13g2_stdcells"
