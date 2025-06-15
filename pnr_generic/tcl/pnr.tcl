##############################################################################
## Preset global variables and attributes
##############################################################################
set TOP $env(TOP)
set SYN_DIR $env(SYN_DIR)
set SYN_SRC $env(SYN_SRC)
set PNR_DIR $env(PNR_DIR)
set PX $env(PX)
set PY $env(PY)
set PR $env(PR)
set X $env(X)
set Y $env(Y)

###############################################################
## Library setup
###############################################################
source $env(ROOT_DIR)/lib/$env(TECH)_settings.tcl

# We assume the first LIB is the standard cell lib
set LIBMAIN [lindex $LIBS 0]
set LIBBCMAIN [lindex $LIBS_BC 0]
set LIBWCMAIN [lindex $LIBS_WC 0]

# TODO: Figure out what is the actual set of commands work
define_corners typ
read_liberty -corner typ "$LIBMAIN"
read_liberty -min -corner typ "$LIBBCMAIN"
read_liberty -max -corner typ "$LIBWCMAIN"

# We assume the first LEF is the tech lef
set TECHLEF [lindex $LEFS 0]
set OTHERLEF [lrange $LEFS 1 end]

read_lef $TECHLEF
foreach LEFFILE $OTHERLEF {
  read_lef "$LEFFILE"
}

read_verilog $env(SYN_NET)
link_design ${TOP}

read_sdc $SYN_DIR/tcl/rtl.sdc.tcl

unset_propagated_clock [all_clocks]

if {![file exists outputs]} {
  file mkdir outputs
  puts "Creating directory outputs"
}
if {![file exists reports]} {
  file mkdir reports
  puts "Creating directory reports"
}

####################################
## Cells declaration
####################################

set BUFCells [list sg13g2_buf_1]
set INVCells [list sg13g2_inv_1]
# TODO
set FILLERCells [list sg13g2_fill_1 sg13g2_fill_2 sg13g2_fill_4 sg13g2_fill_8]
set TAPCells [list ]
set DCAPCells [list ]
set DIODECells [list ]
set TIEHCell_pin sg13g2_tiehi/L_HI
set TIELCell_pin sg13g2_tielo/L_LO

####################################
## Floor Plan
####################################
# TODO: Is there a way to extract from a command?
set row   3.78
set track 0.48
set pitch [expr 32*$row]
set margin [expr 5*$row]

if {[file exists $env(PNR_DIR)/$env(TOP).openlane.fp.tcl]} {
  # FORMAT: initialize_floorplan [-utilization util] [-aspect_ratio ratio] [-core_space space | {bottom top left right}] [-die_area {lx ly ux uy}] [-core_area {lx ly ux uy}] [-sites site_name]
  source $env(PNR_DIR)/$env(TOP).openlane.fp.tcl
} else {
  initialize_floorplan -site CoreSite -aspect_ratio [expr $PX/$PY] -utilization [expr $PR*100] -core_space "$margin $margin $margin $margin"
}

add_global_connection -net VDD -inst_pattern .* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern .* -pin_pattern {^vss$} -ground
set_voltage_domain -name CORE -power VDD -ground VSS

insert_tiecells "${TIELCell_pin}" -prefix "TIE_ZERO_"
insert_tiecells "${TIEHCell_pin}" -prefix "TIE_ONE_"

set ::chip [[::ord::get_db] getChip]
set ::tech [[::ord::get_db] getTech]
set ::block [$::chip getBlock]

set die_area [$::block getDieArea]
set core_area [$::block getCoreArea]

set die_area [list [$die_area xMin] [$die_area yMin] [$die_area xMax] [$die_area yMax]]
set core_area [list [$core_area xMin] [$core_area yMin] [$core_area xMax] [$core_area yMax]]

set dbu [$tech getDbUnitsPerMicron]

set die_coords {}
set core_coords {}

foreach coord $die_area {
    lappend die_coords [expr {1.0 * $coord / $dbu}]
}
foreach coord $core_area {
    lappend core_coords [expr {1.0 * $coord / $dbu}]
}

# write out the floorplan size
set die_width [expr [lindex $die_coords 2] - [lindex $die_coords 0]]
set die_height [expr [lindex $die_coords 3] - [lindex $die_coords 1]]
set core_width [expr [lindex $core_coords 2] - [lindex $core_coords 0]]
set core_height [expr [lindex $core_coords 3] - [lindex $core_coords 1]]

set FPsize   "\{$die_width $die_height\}"
set CoreSize "\{$core_width $core_height\}"
set fo [open FPlanFinal.size w]
puts $fo "Core size: \{X Y\} = ${CoreSize}"
puts $fo "Floorplan size: \{X Y\} = ${FPsize}"
close $fo

# Copied from flow/platforms/ihp-sg13g2/make_tracks.tcl inside OpenROAD-flow-scripts
make_tracks Metal1 -x_offset 0.0  -x_pitch 0.48 -y_offset 0.0 -y_pitch  0.48
make_tracks Metal2 -x_offset 0.0  -x_pitch 0.42 -y_offset 0.0 -y_pitch  0.42
make_tracks Metal3 -x_offset 0.0  -x_pitch 0.48 -y_offset 0.0 -y_pitch  0.48
make_tracks Metal4 -x_offset 0.0  -x_pitch 0.42 -y_offset 0.0 -y_pitch  0.42
make_tracks Metal5 -x_offset 0.0  -x_pitch 3.48 -y_offset 0.0 -y_pitch  0.48
make_tracks TopMetal1 -x_offset 1.46 -x_pitch 2.28 -y_offset 1.46 -y_pitch 2.28
make_tracks TopMetal2 -x_offset 2.0  -x_pitch 4.0  -y_offset 2.0 -y_pitch 4.0

####################################
## Tapcell insertion
####################################

#tapcell\
#    -distance [expr $row*16]\
#    -tapcell_master "$TAPCells"

####################################
## Power planning & SRAMs placement
####################################

add_global_connection -net VDD -inst_pattern .* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern .* -pin_pattern {^vss$} -ground
global_connect

define_pdn_grid \
    -name stdcell_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "TopMetal1 Metal5"

add_pdn_stripe \
    -grid stdcell_grid \
    -layer TopMetal1 \
    -width 3.2 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 1.64 \
    -starts_with POWER -extend_to_boundary

add_pdn_stripe \
    -grid stdcell_grid \
    -layer Metal5 \
    -width 3.2 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 1.6 \
    -starts_with POWER -extend_to_boundary

add_pdn_connect \
    -grid stdcell_grid \
        -layers "Metal5 TopMetal1"

add_pdn_stripe \
        -grid stdcell_grid \
        -layer Metal1 \
        -width 0.3 \
        -followpins \
        -extend_to_core_ring

add_pdn_connect \
    -grid stdcell_grid \
        -layers "Metal1 Metal5"

add_pdn_ring \
        -grid stdcell_grid \
        -layers "TopMetal1 Metal5" \
        -widths "3.2 3.0" \
        -spacings "1.64 1.64" \
        -core_offset "$row $row"

#define_pdn_grid \
#    -macro \
#    -default \
#    -name macro \
#    -starts_with POWER \
#    -halo "$::env(FP_PDN_HORIZONTAL_HALO) $::env(FP_PDN_VERTICAL_HALO)"

#add_pdn_connect \
#    -grid macro \
#    -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

pdngen

###################################
## Placement
####################################

place_pins -random \
	-random_seed 42 \
	-hor_layers Metal4 \
	-ver_layers Metal3

# -density 1.0 -overflow 0.9 -init_density_penalty 0.0001 -initial_place_max_iter 20 -bin_grid_count 64
global_placement -density 0.85

# TODO: Check resize.tcl, as it checks the size of the buffering

# TODO: This is zero in the config.tcl
set cell_pad_value 0
# TODO: Most of the time, diode_pad_value is 2
# set diode_pad_value 2
set cell_pad_side [expr $cell_pad_value / 2]
set_placement_padding -global -right $cell_pad_side -left $cell_pad_side
# set_placement_padding -masters $::env(CELL_PAD_EXCLUDE) -right 0 -left 0
# set_placement_padding -masters $DIODECells -left $diode_pad_value

detailed_placement -max_displacement [subst { "500" "100" }]
optimize_mirroring
if { [catch {check_placement -verbose} errmsg] } {
    puts stderr $errmsg
    exit 1
}
#detailed_placement -disallow_one_site_gaps

####################################
# CTS
####################################
set_global_routing_layer_adjustment Metal2-Metal5 0.05

set_routing_layers -signal Metal2-Metal5 -clock Metal2-Metal5

# correlateRC.py gcd,ibex,aes,jpeg,chameleon,riscv32i,chameleon_hier
# cap units pf/um
set_layer_rc -layer Metal1    -capacitance 3.49E-05 -resistance 0.135e-03
set_layer_rc -layer Metal2    -capacitance 1.81E-05 -resistance 0.103e-03
set_layer_rc -layer Metal3    -capacitance 2.14962E-04 -resistance 0.103e-03
set_layer_rc -layer Metal4    -capacitance 1.48128E-04 -resistance 0.103e-03
set_layer_rc -layer Metal5    -capacitance 1.54087E-04 -resistance 0.103e-03
set_layer_rc -layer TopMetal1 -capacitance 1.54087E-04 -resistance 0.021e-03
set_layer_rc -layer TopMetal2 -capacitance 1.54087E-04 -resistance 0.0145e-03
# end correlate

set_layer_rc -via Via1    -resistance 2.0E-3
set_layer_rc -via Via2    -resistance 2.0E-3
set_layer_rc -via Via3    -resistance 2.0E-3
set_layer_rc -via Via4    -resistance 2.0E-3
set_layer_rc -via TopVia1 -resistance 0.4E-3
set_layer_rc -via TopVia2 -resistance 0.22E-3

set_wire_rc -signal -layer Metal2
set_wire_rc -clock  -layer Metal5

estimate_parasitics -placement
repair_clock_inverters
clock_tree_synthesis -buf_list $BUFCells -root_buf [lindex $BUFCells 0] -sink_clustering_size 25 -sink_clustering_max_diameter 50 -sink_clustering_enable
set_propagated_clock [all_clocks]

estimate_parasitics -placement

repair_clock_nets -max_wire_length 0

estimate_parasitics -placement

detailed_placement
optimize_mirroring
if { [catch {check_placement -verbose} errmsg] } {
    puts stderr $errmsg
    exit 1
}

report_cts -out_file $PNR_DIR/reports/cts.rpt

###############################################
# Global routing
###############################################
set_propagated_clock [all_clocks]

set_macro_extension 0

global_route -congestion_iterations 50 -verbose -congestion_report_file $PNR_DIR/reports/congestion.rpt

###############################################
# Fillers
###############################################
filler_placement "$FILLERCells"

###############################################
# Detail routing
###############################################
catch
set_thread_count 10
detailed_route\
    -bottom_routing_layer "Metal2" \
    -top_routing_layer "Metal5" \
    -output_maze $PNR_DIR/reports/${TOP}_maze.log\
    -output_drc $PNR_DIR/reports/${TOP}.drc\
    -droute_end_iter 64 \
    -or_seed 42\
    -verbose 1

catch

#################################################
## Write out final files
#################################################
define_process_corner -ext_model_index 0 X
extract_parasitics -ext_model_file $RCX_RULES -lef_res

write_db DesignLib

write_verilog $PNR_DIR/outputs/${TOP}.v
write_verilog -include_pwr_gnd $PNR_DIR/outputs/${TOP}_pg.v
write_def $PNR_DIR/outputs/${TOP}.def
write_spef $PNR_DIR/outputs/${TOP}.spef
write_abstract_lef $PNR_DIR/outputs/${TOP}.lef
# write_timing_model $PNR_DIR/outputs/${TOP}.lib

 

