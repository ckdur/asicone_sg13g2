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
set ::chip [[::ord::get_db] getChip]
set ::tech [[::ord::get_db] getTech]
set ::block [$::chip getBlock]
set dbu [$tech getDbUnitsPerMicron]

# TODO: Is there a way to extract from a command?
set siteobj [[[::ord::get_db] findLib sg13g2f] findSite obssite]
set row   [expr 1.0*[$siteobj getHeight] / $dbu]
set track [expr 1.0*[$siteobj getWidth] / $dbu]
set pitch [expr 32*$row]
set margin [expr 3*$row]

set dig_to_ana 0.8
set corearea "[expr $margin] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set digcorearea "[expr $X*$dig_to_ana] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set anacorearea "[expr $margin] [expr $margin] [expr $X*$dig_to_ana] [expr $Y-$margin]"
set corex [expr $margin]
set corey [expr $margin]
set coreuy [expr $Y-$margin]

read_upf -file $PNR_DIR/tcl/${TOP}.upf.tcl

set_domain_area CORE -area $digcorearea
set_domain_area ANALOG -area $anacorearea
initialize_floorplan -site obssite -die_area "0 0 $X $Y" -core_area $corearea

# Only add the global connection to the digitals
add_global_connection -net VDD -inst_pattern digital/.* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern digital/.* -pin_pattern {^vss$} -ground
# Just to declare AVDD as a power net
add_global_connection -net AVDD -pin_pattern {nothinghere} -power

#set_voltage_domain -region ANALOG -power AVDD -ground VSS
set_voltage_domain -region ANALOG -power AVDD -ground VSS -secondary_power VDD
set_voltage_domain -power VDD -ground VSS -secondary_power AVDD

insert_tiecells "TIEL/zn" -prefix "TIE_ZERO_"
insert_tiecells "TIEH/z" -prefix "TIE_ONE_"

set die_area [$::block getDieArea]
set core_area [$::block getCoreArea]

set die_area [list [$die_area xMin] [$die_area yMin] [$die_area xMax] [$die_area yMax]]
set core_area [list [$core_area xMin] [$core_area yMin] [$core_area xMax] [$core_area yMax]]

set mgrid [$tech getManufacturingGrid]

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
## ADC Macro placement
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

# Get the abutment VDD (or VSS) size from the filler
set fill_lib [[::ord::get_db] findLib SARADC_FILL1]
set fill_obj [$fill_lib findMaster SARADC_FILL1]
set fill_rail_obj [lindex [$fill_obj getMTerms] 0]
set abutsizey [expr 1.0*[[$fill_rail_obj getBBox] dy] / $dbu]

# Put the power domain for Analog before anything else
set tie_lib [[::ord::get_db] findLib $saradc_tap]
set tie_master [$tie_lib findMaster $saradc_tap]
set sizetap [expr 1.0*[$tie_master getWidth] / $dbu]
# setObjFPlanBox Group {Analog} [expr $corex-$sizetap] $corey $coreux $coreuy

source tcl/stripe.tcl
source tcl/saradc_pos.tcl
source tcl/saradc_conn.tcl
source tcl/comp_pos.tcl
source tcl/filler_utils.tcl

# Positioning of MSB/LSB H in the lower bound
set posx_cdach [expr $sizetap+$corex]
set posy_cdach [expr $corey]
set ret_h [pos_cdac_circle $posx_cdach $posy_cdach analog/lsb_cdac_h analog/msb_cdac_h analog/dummy_h $nbits $pw $ph $saradc_tap 1 1]

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
set ret_sw [pos_sw_wtap $posx_sw $posy_sw analog/sw_vouth2voutl $cdacx_h $saradc_tap $nsw_vouthl]

# Height of the sw is always 1. 
set nrow_sw 1
# The distance between h and l is always 1 + 2*spc (usually 7 if config is not changed)
set nrow_asw [expr 2*$nrow_hl_sw+$nrow_sw]

# Positioning of MSB/LSB H above the switch
set posx_cdacl [expr $sizetap + $corex]
set posy_cdacl [expr $corey + $row*($nrow_h+$nrow_asw)]
set ret_l [pos_cdac_circle $posx_cdacl $posy_cdacl analog/lsb_cdac_l analog/msb_cdac_l analog/dummy_l $nbits $pw $ph $saradc_tap 1 0]

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

# Blockage of the middle switch
set sw_w [lindex $ret_sw 0]
set cmp_x [expr $posx_sw + $sw_w + 20*$track]
set x1 [expr $posx_sw-$sizetap]
set y1 [expr $posy_sw-4*$row]
set x2 [expr $cmp_x-$sizetap]
set y2 [expr $posy_sw+5*$row]
set area "$x1 $y1 $x2 $y2"
create_blockage -region $area

# The blockages for avoiding std cells
set x1 $corex
set y1 $posy_cdach
set x2 [expr $X*$dig_to_ana]
set y2 [expr $posy_cdach + $row*($nrow_h+1)]
set area "$x1 $y1 $x2 $y2"
create_blockage -region $area

set y1 [expr $posy_cdacl - $row]
set y2 [expr $posy_cdacl + $row*$nrow_h]
set area "$x1 $y1 $x2 $y2"
create_blockage -region $area

# Put a blockage to avoid joining
# TODO: Maybe this can be achieved using ENDCAP?
set x1 [expr $corex + $cdacx_h * $nx_h - 2*$row]
set x2 [expr $corex + $cdacx_h * $nx_h + 2*$row]
set y1 [expr $corey]
set area "$x1 $y1 $x2 $y2"
#create_blockage -region $area

# Re-initialize the floorplan with the new height
set Y [expr $posy_cdacl + $row*$nrow_h + $margin]
set corearea "[expr $margin] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set digcorearea "[expr $X*$dig_to_ana] [expr $margin] [expr $X-$margin] [expr $Y-$margin]"
set anacorearea "[expr $margin] [expr $margin] [expr $X*$dig_to_ana] [expr $Y-$margin]"
set coreuy [expr $Y-$margin]
set fPlan_height [expr $Y-2*$margin]

set_domain_area CORE -area $digcorearea
set_domain_area ANALOG -area $anacorearea
initialize_floorplan -site obssite -die_area "0 0 $X $Y" -core_area $corearea

## Tapcell insertion
tapcell \
    -distance [expr $row*16] \
    -endcap_master "$TAPCells" \
    -tapcell_master "$TAPCells"

# connect the fillers
add_global_connection -net AVDD -inst_pattern analog\./.* -pin_pattern {^vdd$} -power
add_global_connection -net VSS -inst_pattern analog\./.* -pin_pattern {^vss$} -ground
do_global_from_areas
global_connect

####################################
## Power planning
####################################

# Do first the pdngen
define_pdn_grid \
    -name stdcell_core_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "TopMetal1 Metal5"

define_pdn_grid \
    -name stdcell_analog_grid \
    -starts_with POWER \
    -voltage_domain ANALOG \
    -pins "TopMetal1 Metal5"

add_pdn_stripe \
    -grid stdcell_core_grid \
    -layer Metal5 \
    -width 3.2 \
    -pitch $pitch \
    -offset [expr $X*$dig_to_ana-2*$margin+$row] \
    -spacing 1.6 \
    -starts_with POWER -extend_to_boundary

add_pdn_connect \
    -grid stdcell_core_grid \
        -layers "Metal5 TopMetal1"

#add_pdn_stripe \
#    -grid stdcell_analog_grid \
#    -layer Metal5 \
#    -width 3.2 \
#    -pitch $pitch \
#    -offset $pitch \
#    -spacing 1.6 \
#    -starts_with POWER -extend_to_boundary

add_pdn_connect \
    -grid stdcell_analog_grid \
        -layers "Metal5 TopMetal1"

add_pdn_stripe \
        -grid stdcell_core_grid \
        -layer Metal1 \
        -width 0.3 \
        -followpins \
        -extend_to_core_ring

add_pdn_stripe \
        -grid stdcell_analog_grid \
        -layer Metal1 \
        -width 0.3 \
        -followpins \
        -extend_to_core_ring

add_pdn_connect \
    -grid stdcell_core_grid \
        -layers "Metal1 Metal5"

add_pdn_connect \
    -grid stdcell_analog_grid \
        -layers "Metal1 Metal5"

add_pdn_ring \
        -grid stdcell_core_grid \
        -layers "TopMetal1 Metal5" \
        -widths "3.2 3.0" \
        -spacings "1.64 1.64" \
        -core_offset "$metal5_py $metal5_py" \
        -starts_with GROUND \
        -allow_out_of_die

add_pdn_ring \
        -grid stdcell_analog_grid \
        -layers "TopMetal1 Metal5" \
        -widths "3.2 3.0" \
        -spacings "1.64 1.64" \
        -core_offset "$metal5_py $metal5_py" \
        -starts_with GROUND \
        -allow_out_of_die

pdngen

####################################
## ADC Routing
####################################

# Positioning of the comparator
set ret_poscmp [pos_stdcell_comp $cmp_x $posy_sw analog/cmp]
set compx [lindex $ret_poscmp 0]
set compy [lindex $ret_poscmp 1]

# Dummy positioning of the buffers
# source tcl/comp_pos.tcl
pos_stdcell_box [expr $cmp_x+$compx+$row] [expr $posy_sw-2*$row] [expr $X*$dig_to_ana-($cmp_x+$compx+$row)-2*$margin] analog/buflogic
pos_stdcell_box [expr $X*$dig_to_ana+$row+2*$margin] [expr $posy_sw-10*$row] [expr $X*(1-$dig_to_ana)-3*$margin-$row] digital

# Go for routing
puts "\[Routing\] Creating vdd and vss for ties"
create_stripes_vdd_vss $posx_cdach $corey $cdacx_h $nx_h $fPlan_height $saradc_tap AVDD VSS [expr 2*$metal2_w]

# Trace horizontal stripes for connecting VREFH, VIN, VIP for down, and VREFL, VIN, VIP for up
puts "\[Routing\] Trace horizontal stripes for connecting VREFH, VIN, VIP for down, and VREFL, VIN, VIP for up"
set midoff [expr $metal3_s+$metal3_py]
set midspc [expr 2*$midoff]
set midwidth [expr $row - $midspc]
set x1 [expr 0]
set x2 [expr $die_width]
set y1 [expr $corey+$row*$nrow_h]
set y2 [expr $y1 + $row*$nrow_hl_sw]
set area "$x1 $y1 $x2 $y2"
#setAddStripeMode -ignore_nondefault_domains true
setAddStripeMode -orthogonal_only true
add_stripe_over_area {analog/VOUTH analog/VOUTL VREFH VIN VIP} $metal3 horizontal \
  $midwidth $midspc 100 \
  $midoff $area
place_pin -pin_name VREFH -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+2*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]
place_pin -pin_name VIN -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+3*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]
place_pin -pin_name VIP -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+4*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]

set y1 [expr $corey+$row*($nrow_h+$nrow_hl_sw+$nrow_sw)]
set y2 [expr $corey+$row*($nrow_h+$nrow_asw)]
set area "$x1 $y1 $x2 $y2"
add_stripe_over_area {VIP VIN VREFL analog/VOUTL analog/VOUTH} $metal3 horizontal \
  $midwidth $midspc 100 \
  $midoff $area
place_pin -pin_name VIP -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+0*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]
place_pin -pin_name VIN -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+1*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]
place_pin -pin_name VREFL -layer $metal3 -location [list [expr $midwidth/2] [expr $y1+$midwidth/2+$midoff+2*($midwidth+$midspc)]] -pin_size [list $midwidth $midwidth]

set strip_h {analog/VOUTH analog/VOUTL VREFH VIP VIN}
set strip_l {analog/VOUTH analog/VOUTL VREFL VIP VIN}

# This creates all the internal connections (Takes a LOT of time)
puts "\[Routing\] This creates all the internal connections (Takes a LOT of time)"
set wthird [expr 4*$metal4_w]
set sthird [expr 2*$metal4_s]
create_sw_conn $posx_sw $posy_sw analog/sw_vouth2voutl $cdacx_h $wthird $sthird $nsw_vouthl
create_sw_cap_conn $posx_cdach $posy_cdach $posa_h $lsta_h $pw $ph $cdacx_h $cdacy_h $strip_h
create_sw_cap_conn $posx_cdacl $posy_cdacl $posa_l $lsta_l $pw $ph $cdacx_h $cdacy_h $strip_l

puts "\[Routing\] Stripes for global connections"
# Stripes for global connections
# The first one should span from the bottom, up to the first three rows that overshoots
#set y_hstripe [expr $posy_cdach + $cdacy_h*$ny_h]
set y_hstripe [expr $posy_cdach]
set uy_hstripe [expr $posy_cdach + ($nrow_h+$nrow_hl_sw)*$row - $midoff]
create_stripes $posx_cdach $y_hstripe $cdacx_h $nx_h $uy_hstripe $strip_h $wthird $sthird
# The second one should span from L origin minus three rows, up to the top
set y_lstripe [expr $posy_cdacl - $row*$nrow_hl_sw + $midoff]
#set uy_lstripe [expr $posy_cdacl]
set uy_lstripe [expr $corey + $row*$nrow_all]
create_stripes $posx_cdacl $y_lstripe $cdacx_l $nx_l $uy_lstripe $strip_l $wthird $sthird

puts "\[Routing\] Create the rings for fixing bits 1 and 3 of the ring DACs"
# Create the rings for fixing bits 1 and 3 of the ring DACs
set wforth [expr 6*$metal5_w]
set sforth [expr 6*$metal5_s]
setAddStripeMode -stacked_via_top_layer TopMetal1 -stacked_via_bottom_layer $metal5

puts "\[Routing\]    Phase 1"
set nx_l_2 [expr int($nx_l / 2)]
set offset [expr $cdacy_l/2 - (2*$wforth+$sforth)/2]
set x1 [expr $posx_cdacl + ($nx_l_2-2)*$cdacx_l]
set x2 [expr $posx_cdacl + ($nx_l_2+2)*$cdacx_l]
set y1 [expr $posy_cdacl + (1)*$cdacy_l]
set y2 [expr $posy_cdacl + (2)*$cdacy_l]
set area "$x1 $y1 $x2 $y2"
# Get "analog/LSB_L_VSH[2] analog/LSB_L_FL[2]"
set capobj [$::block findInst "analog/lsb_cdac_l.cdac_bit\\\[1\\\].cdac_unit.cap\\\[0\\\].cap/impl"]
set LSB_L_VSH_FL_2 [list [[[$capobj findITerm i] getNet] getName] [[[$capobj findITerm zn] getNet] getName]]
add_stripe_over_area $LSB_L_VSH_FL_2 $metal5 horizontal \
    $wforth $sforth $cdacy_l \
    $offset $area
if {$nbits >= 5} {
  # Get "analog/LSB_L_VSH[4] analog/LSB_L_FL[4]"
  set capobj [$::block findInst "analog/lsb_cdac_l.cdac_bit\\\[3\\\].cdac_unit.cap\\\[0\\\].cap/impl"]
  set LSB_L_VSH_FL_4 [list [[[$capobj findITerm i] getNet] getName] [[[$capobj findITerm zn] getNet] getName]]
  set x1 [expr $posx_cdacl + ($nx_l_2-3)*$cdacx_l]
  set x2 [expr $posx_cdacl + ($nx_l_2+3)*$cdacx_l]
  set y1 [expr $posy_cdacl + (2)*$cdacy_l]
  set y2 [expr $posy_cdacl + (4)*$cdacy_l]
  set area "$x1 $y1 $x2 $y2"
  add_stripe_over_area $LSB_L_VSH_FL_4 $metal5 horizontal \
      $wforth $sforth $cdacy_l \
      $offset $area
  set x1 [expr $posx_cdacl + ($nx_l_2-1)*$cdacx_l]
  set x2 [expr $posx_cdacl + ($nx_l_2+1)*$cdacx_l]
  set offset [expr $cdacx_l/2 - (2*$wforth+$sforth)/2]
  set area "$x1 $y1 $x2 $y2"
  add_stripe_over_area $LSB_L_VSH_FL_4 TopMetal1 vertical \
      $wforth $sforth $cdacx_l \
      $offset $area
}

puts "\[Routing\]    Phase 2"
set nx_h_2 [expr int($nx_h / 2)]
set offset [expr $cdacy_h/2 - (2*$wforth+$sforth)/2]
set x1 [expr $posx_cdach + ($nx_h_2-2)*$cdacx_h]
set x2 [expr $posx_cdach + ($nx_h_2+2)*$cdacx_h]
set y1 [expr $posy_cdach + ($ny_h-2)*$cdacy_h]
set y2 [expr $posy_cdach + ($ny_h-1)*$cdacy_h]
set area "$x1 $y1 $x2 $y2"
# Get "analog/LSB_H_VSH[2] analog/LSB_H_FL[2]"
set capobj [$::block findInst "analog/lsb_cdac_h.cdac_bit\\\[1\\\].cdac_unit.cap\\\[0\\\].cap/impl"]
set LSB_H_VSH_FL_2 [list [[[$capobj findITerm i] getNet] getName] [[[$capobj findITerm zn] getNet] getName]]
add_stripe_over_area $LSB_H_VSH_FL_2 $metal5 horizontal \
    $wforth $sforth $cdacy_h \
    $offset $area
if {$nbits >= 5} {
  # Get "analog/LSB_H_VSH[4] analog/LSB_H_FL[4]"
  set capobj [$::block findInst "analog/lsb_cdac_h.cdac_bit\\\[3\\\].cdac_unit.cap\\\[0\\\].cap/impl"]
  set LSB_H_VSH_FL_4 [list [[[$capobj findITerm i] getNet] getName] [[[$capobj findITerm zn] getNet] getName]]
  set x1 [expr $posx_cdach + ($nx_h_2-3)*$cdacx_h]
  set x2 [expr $posx_cdach + ($nx_h_2+3)*$cdacx_h]
  set y1 [expr $posy_cdach + ($ny_h-4)*$cdacy_h]
  set y2 [expr $posy_cdach + ($ny_h-2)*$cdacy_h]
  set area "$x1 $y1 $x2 $y2"
  add_stripe_over_area $LSB_H_VSH_FL_4 $metal5 horizontal \
      $wforth $sforth $cdacy_h \
      $offset $area
  set x1 [expr $posx_cdach + ($nx_h_2-1)*$cdacx_h]
  set x2 [expr $posx_cdach + ($nx_h_2+1)*$cdacx_h]
  set offset [expr $cdacx_h/2 - (2*$wforth+$sforth)/2]
  set area "$x1 $y1 $x2 $y2"
  add_stripe_over_area $LSB_H_VSH_FL_4 TopMetal1 vertical \
      $wforth $sforth $cdacx_h \
      $offset $area
}
setAddStripeMode -reset

puts "\[Routing\]    Phase 3"
# A third one just for the switch. Only VOUTH and VOUTL
set y_swstripe [expr $corey + $row*$nrow_h + $midoff]
set uy_swstripe [expr $corey + $row*($nrow_h+$nrow_asw) - $midoff]
set x1 [expr $posx_sw]
set x2 [expr $x1 + 2*$wthird + 1*$sthird]
set y1 [expr $y_swstripe]
set y2 [expr $uy_swstripe]
set area "$x1 $y1 $x2 $y2"
setAddStripeMode -orthogonal_only true
add_stripe_over_area {analog/VOUTH analog/VOUTL} $metal4 vertical \
  $wthird $sthird 100 \
  0 $area

# Put a blockage around all of $row width
# addHaloToBlock -allBlock $row $row $row $row

# Source if exists the pin file
if {[file exists $PNR_DIR/tcl/$TOP.pins.tcl]} {
  source $PNR_DIR/tcl/$TOP.pins.tcl
}

write_def $PNR_DIR/outputs/${TOP}.pre.def

# Yeah this doesn't work. Is just a way to connect some pin to the outer ring
# We still are a LOONG way until we have sroute compat
#add_sroute_connect -net "AVDD" -outerNet "AVDD" -layers "Metal1 Metal2" -cut_pitch {0 0} -insts [list {analog/dummy_h.dummy\[4\].dummy.cdac_unit_0_CAP_TAPB_0_0}] -metalwidths {100} -metalspaces {50} -ongrid {Metal1 Metal2}

#add_sroute_connect -net "AVDD" -outerNet "AVDD" -layers "Metal1 Metal2" -cut_pitch {0 0} -insts [list {analog/dummy_h.dummy\[4\].dummy.cdac_unit_0_CAP_TAPBB_0_0}] -metalwidths {1000 1000} -metalspaces {800 800} -ongrid {Metal1 Metal2}

###################################
## Placement
####################################

# Before checking placement, delete all blockages
# ... why there is a function to create them, but not for deleting them?
foreach blockage [$::block getBlockages] {
  odb::dbBlockage_destroy $blockage
}

set pin_group_right {CLK RST GO VALID SAMPLE}
for {set i 0} {$i < $nbits} {incr i} {
  lappend pin_group_left "RESULT\\\[$i\\\]"
}

place_pins -hor_layers Metal4 \
	-ver_layers Metal3 \
  -exclude top:* -exclude left:* -exclude bottom:*

# We actually do not care
if { [catch {global_placement -skip_initial_place -density 0.82} errmsg] } {
    puts stderr $errmsg
    puts "Global placement failed, but is ignored on purpose"
}

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
    puts "Check placement failed, but is ignored on purpose"
    puts "May god forgive our actions"
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
    puts "Check placement failed, but is ignored on purpose"
    puts "May god forgive our actions"
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
