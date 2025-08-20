if { [info exists ::env(PDK_ROOT)]} {
  # Setting a default
  set PDK_ROOT $::env(PDK_ROOT)
} else {
  # Setting a default
  set PDK_ROOT "/opt/OpenLane/share/pdk"
}

set ROOT_DIR $env(ROOT_DIR)
set LIB_PATHS "$ROOT_DIR"
set LIBS "${ROOT_DIR}/lib/sg13g2.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib"
set LEFS "${ROOT_DIR}/lib/sg13g2.tech.lef ${ROOT_DIR}/lib/sg13g2.lef ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io.lef"
set GDSS "${ROOT_DIR}/lib/sg13g2.gds ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/gds/sg13g2_io.gds"
set CDLS "${ROOT_DIR}/lib/sg13g2.cdl ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/cdl/sg13g2_io.cdl"

# TODO: Do the characterization of the lib
set LIBS_BC "${ROOT_DIR}/lib/sg13g2.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_fast_1p65V_3p6V_m40C.lib"
set LIBS_WC "${ROOT_DIR}/lib/sg13g2.lib ${PDK_ROOT}/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_slow_1p08V_3p0V_125C.lib"

# TODO: Not defined yet
set RCX_RULES "${ROOT_DIR}/lib/sg13g2.rules"

set techsite "obssite"
set techname "sg13g2"
