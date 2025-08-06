##############################################################################
## Preset global variables and attributes
##############################################################################
set TOP $env(TOP)
set SYN_DIR $env(SYN_DIR)
set SYN_SRC $env(SYN_SRC)
set PNR_DIR $env(PNR_DIR)
set X $env(X)
set Y $env(Y)

###############################################################
## Library setup
###############################################################
source $env(ROOT_DIR)/cells/settings.tcl

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

puts "Reading: $env(SYN_NET)"
read_verilog $env(SYN_NET)
puts "Reading: $env(SYN_DIG_NET)"
read_verilog $env(SYN_DIG_NET)
link_design ${TOP}

puts "SDC reading: ${TOP}.sdc.tcl"
read_sdc $SYN_DIR/tcl/${TOP}.sdc.tcl

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

set BUFCells [list BUFFD1]
set INVCells [list INVD1]
# TODO
set FILLERCells [list FILL1 FILL2 FILL4 FILL8]
set TAPCells [list TAPCELL]
set DCAPCells [list ]
set DIODECells [list ]

####################################
## Floor Plan
####################################
# TODO: Is there a way to extract from a command?
set row   6.12
set track 0.34
set pitch [expr 32*$row]
set margin [expr 3*$row]

set dig_to_ana 0.8
set corearea "[expr $margin] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set digcorearea "[expr $X*$dig_to_ana] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set anacorearea "[expr $margin] [expr $margin] [expr $X*$dig_to_ana] [expr $Y-$margin]"
set corex [expr $margin]
set corey [expr $margin]

read_upf -file $PNR_DIR/tcl/${TOP}.upf.tcl

set_domain_area CORE -area $digcorearea
set_domain_area ANALOG -area $anacorearea

initialize_floorplan -site obssite -die_area "0 0 $X $Y" -core_area $corearea

# Only add the global connection to the digitals
add_global_connection -net VDD -inst_pattern digital/.* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern digital/.* -pin_pattern {^vss$} -ground

#set_voltage_domain -region ANALOG -power AVDD -ground VSS
set_voltage_domain -region ANALOG -power AVDD -ground VSS
set_voltage_domain -power VDD -ground VSS

insert_tiecells "TIEL/zn" -prefix "TIE_ZERO_"
insert_tiecells "TIEH/z" -prefix "TIE_ONE_"

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
## Macro placement
####################################
#set_dont_touch [dbGet [dbGet -p top.insts.name "analog/*"].name]
#set_dont_touch [dbGet [dbGet -p top.insts.name "analog/buflogic/*"].name]

# Set some globals that are necessary for the SARADC pos utilities
set saradc_fill_nopower SARADC_FILL1_NOPOWER
set saradc_fill SARADC_FILL1
set saradc_tap SARADC_FILLTIE2
set metal1 Metal1
set metal1_py [expr 1.0*[[$tech findLayer Metal1] getPitchY] / $dbu]
set metal1_w [expr 1.0*[[$tech findLayer Metal1] getWidth] / $dbu]
set metal1_s [expr 1.0*[[$tech findLayer Metal1] getSpacing] / $dbu]
set metal2 Metal2
set metal2_px [expr 1.0*[[$tech findLayer Metal2] getPitchX] / $dbu + 0.02]
set metal2_w [expr 1.0*[[$tech findLayer Metal2] getWidth] / $dbu]
set metal2_s [expr 1.0*[[$tech findLayer Metal2] getSpacing] / $dbu]
set metal3 Metal3
set metal3_py [expr 1.0*[[$tech findLayer Metal3] getPitchY] / $dbu]
set metal3_w [expr 1.0*[[$tech findLayer Metal3] getWidth] / $dbu]
set metal3_s [expr 1.0*[[$tech findLayer Metal3] getSpacing] / $dbu]
set metal4 Metal4
set metal4_px [expr 1.0*[[$tech findLayer Metal4] getPitchX] / $dbu]
set metal4_w [expr 1.0*[[$tech findLayer Metal4] getWidth] / $dbu]
set metal4_s [expr 1.0*[[$tech findLayer Metal4] getSpacing] / $dbu]
set metal5 Metal5
set metal5_py [expr 1.0*[[$tech findLayer Metal5] getPitchY] / $dbu]
set metal5_w [expr 1.0*[[$tech findLayer Metal5] getWidth] / $dbu]
set metal5_s [expr 1.0*[[$tech findLayer Metal5] getSpacing] / $dbu]

# Configuration of the ADC
# Capacitor WxH (3x2 in this case)
set pw 3
set ph 2
# Number of bits of the ADC
set nbits 5
# Number of rows (in stdcells) for the distance between a CDAC and the switch
set nrow_hl_sw 5
# Number in tracks of the distance between the CAP and the SW in the CDAC unit
set ntrack_capsw 3
# sw number
set nsw_vouthl 3

# Get the abutment VDD size from the filler
#set fill_obj [dbGet -p head.libCells.name SARADC_FILL1]
#set fill_rail_obj [dbGet $fill_obj.pgTerms.pins.allShapes.shapes]
#set abutsizey [dbGet [lindex $fill_rail_obj 0].rect_sizey]

# Put the power domain for Analog before anything else
set tie_lib [[::ord::get_db] findLib $saradc_tap]
set tie_master [$tie_lib findMaster $saradc_tap]
set sizetap [expr 1.0*[$tie_master getWidth] / $dbu]
# setObjFPlanBox Group {Analog} [expr $corex-$sizetap] $corey $coreux $coreuy

source tcl/saradc_pos.tcl
#source tcl/saradc_conn.tcl

# Positioning of MSB/LSB H in the lower bound
set posx_cdach [expr $sizetap+$corex]
set posy_cdach [expr $corey]
set ret_h [pos_cdac_circle $posx_cdach $posy_cdach analog.lsb_cdac_h analog.msb_cdac_h analog.dummy_h $nbits $pw $ph $saradc_tap 1 1]

set cdacx_h [lindex [lindex $ret_h 0] 0]
set cdacy_h [lindex [lindex $ret_h 0] 1]
set nx_h [lindex [lindex $ret_h 1] 0]
set ny_h [lindex [lindex $ret_h 1] 1]
set pos_h [lindex $ret_h 2]
set lst_h [lindex $ret_h 4]
set posd_h [lindex $ret_h 3]
set lstd_h [lindex $ret_h 5]
set posa_h [concat $pos_h $posd_h]
set lsta_h [concat $lst_h $lstd_h]
set nrow_h [expr ceil($cdacy_h*$ny_h / $row)]

# Positioning of the additional switch that joins VOUTH and VOUTL
# Just above the H CDAC by a distance
set posx_sw $posx_cdach
set posy_sw [expr $corey + $row*($nrow_h+$nrow_hl_sw)]
set ret_sw [pos_sw_wtap $posx_sw $posy_sw analog.sw_vouth2voutl $cdacx_h $saradc_tap $nsw_vouthl]

# Height of the sw is always 1. 
set nrow_sw 1
# The distance between h and l is always 1 + 2*spc (usually 7 if config is not changed)
set nrow_asw [expr 2*$nrow_hl_sw+$nrow_sw]

# Positioning of MSB/LSB H above the switch
set posx_cdacl [expr $sizetap + $corex]
set posy_cdacl [expr $corey + $row*($nrow_h+$nrow_asw)]
set ret_l [pos_cdac_circle $posx_cdacl $posy_cdacl analog.lsb_cdac_l analog.msb_cdac_l analog.dummy_l $nbits $pw $ph $saradc_tap 1 0]

set cdacx_l [lindex [lindex $ret_l 0] 0]
set cdacy_l [lindex [lindex $ret_l 0] 1]
set nx_l [lindex [lindex $ret_l 1] 0]
set ny_l [lindex [lindex $ret_l 1] 1]
set pos_l [lindex $ret_l 2]
set lst_l [lindex $ret_l 4]
set posd_l [lindex $ret_l 3]
set lstd_l [lindex $ret_l 5]
set posa_l [concat $pos_l $posd_l]
set lsta_l [concat $lst_l $lstd_l]
set nrow_l [expr ceil($cdacy_l*$ny_l / $row)]

set nrow_all [expr $nrow_h + $nrow_l + $nrow_asw]

catch
# Positioning of the comparator
source tcl/comp_pos.tcl
set sw_w [lindex $ret_sw 0]
set ret_poscmp [pos_stdcell_comp [expr $posx_sw + $sw_w + 20*$track] $posy_sw analog/cmp]
set compx [lindex $ret_poscmp 0]
set compy [lindex $ret_poscmp 1]



####################################
## Tapcell insertion
####################################

tapcell\
    -distance [expr $row*16]\
    -endcap_master "$TAPCells"\
    -tapcell_master "$TAPCells"

proc is_inside {or area} {
    global dbu
    set x [expr 1.0*[lindex $or 0] / $dbu]
    set y [expr 1.0*[lindex $or 1] / $dbu]
    set x0 [lindex $area 0]
    set y0 [lindex $area 1]
    set x1 [lindex $area 2]
    set y1 [lindex $area 3]
    set inside [expr ($x0 <= $x) && ($x <= $x1) && ($y0 <= $y) && ($y <= $y1)]
    # puts "$dbu $x $y $area $inside"
    return $inside
}
proc do_global_from_areas {} {
    global digcorearea
    set all_inst [$::block getInsts]
    foreach inst $all_inst {
        if {[$inst isPlaced] == 0} {
            continue
        }
        set name [$inst getName]
        set or [$inst getOrigin]
        if {[is_inside $or $digcorearea] == 0} {
            # Analog
            # puts "analog for $name in $or"
            add_global_connection -net AVDD -inst_pattern $name -pin_pattern {^vdd$} -power
            add_global_connection -net VSS -inst_pattern $name -pin_pattern {^vss$} -ground
        } else {
            # Digital
            # puts "digital for $name in $or"
            add_global_connection -net VDD -inst_pattern $name -pin_pattern {^vdd$} -power
            add_global_connection -net VSS -inst_pattern $name -pin_pattern {^vss$} -ground
        }
    }
}
#do_global_from_areas
#global_connect

catch



####################################
## Power planning & SRAMs placement
####################################




define_pdn_grid \
    -name stdcell_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "TopMetal1 Metal5"

set pitch2 [expr $pitch*2]
if {$die_width > $pitch2} {
    add_pdn_stripe \
        -grid stdcell_grid \
        -layer TopMetal1 \
        -width 3.2 \
        -pitch $pitch \
        -offset $pitch \
        -spacing 1.64 \
        -starts_with POWER -extend_to_boundary
}

if {$die_width > $pitch2} {
    add_pdn_stripe \
        -grid stdcell_grid \
        -layer Metal5 \
        -width 3.2 \
        -pitch $pitch \
        -offset $pitch \
        -spacing 1.6 \
        -starts_with POWER -extend_to_boundary
}

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
set_global_routing_layer_adjustment Metal1-Metal5 0.05

set_routing_layers -signal Metal1-Metal5 -clock Metal1-Metal5

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
clock_tree_synthesis -buf_list $BUFCells -root_buf BUFFD1 -sink_clustering_size 25 -sink_clustering_max_diameter 50 -sink_clustering_enable
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

add_global_connection -net VDD -inst_pattern .* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern .* -pin_pattern {^vss$} -ground
global_connect

###############################################
# Detail routing
###############################################
#catch
set_thread_count 10
detailed_route\
    -bottom_routing_layer "Metal1" \
    -top_routing_layer "Metal5" \
    -output_maze $PNR_DIR/reports/${TOP}_maze.log\
    -output_drc $PNR_DIR/reports/${TOP}.drc\
    -droute_end_iter 64 \
    -or_seed 42\
    -verbose 1

#################################################
# Metal fill
#################################################
density_fill -rules $env(ROOT_DIR)/lib/$env(TECH)_fill.json

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
write_cdl -masters ${CDLS} $PNR_DIR/outputs/${TOP}.cdl
