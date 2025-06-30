set ROOT_DIR $env(ROOT_DIR)
set LIB_PATHS "$ROOT_DIR"
set LIBS "${ROOT_DIR}/lib/sg13g2.lib"
set LEFS "${ROOT_DIR}/lib/sg13g2.tech.lef ${ROOT_DIR}/lib/sg13g2.lef"
set GDSS "${ROOT_DIR}/lib/sg13g2.gds"
set CDLS "${ROOT_DIR}/lib/sg13g2.cdl"

# TODO: Do the characterization of the lib
set LIBS_BC "${ROOT_DIR}/lib/sg13g2.lib"
set LIBS_WC "${ROOT_DIR}/lib/sg13g2.lib"

if { [info exists ::env(PDK_ROOT)]} {
  # Setting a default
  set PDK_ROOT $::env(PDK_ROOT)
} else {
  # Setting a default
  set PDK_ROOT "/opt/OpenLane/share/pdk"
}
# TODO: Not defined yet
set RCX_RULES "${ROOT_DIR}/lib/sg13g2.rules"
