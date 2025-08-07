proc addStripe { args } {
  sta::parse_key_args "addStripe" args \
    keys {-nets -layer -direction -width -spacing -set_to_set_distance -start_from -start_offset -area} \
    flags {}

  if { ![info exists keys(-layer)] } {
    utl::error PDN 1007 "The -layer argument is required."
  }
  if { ![info exists keys(-nets)] } {
    utl::error PDN 1007 "The -nets argument is required."
  }
  
  set nets $keys(-nets)
  set layer $keys(-layer)

  set direction "horizontal"
  if { [info exists keys(-direction)] } {
    set direction $keys(-direction)
  }

  set width 0
  if { [info exists keys(-width)] } {
    set width $keys(-width)
  }

  set spacing 0
  if { [info exists keys(-spacing)] } {
    set spacing $keys(-spacing)
  }

  set ssdistance 0
  if { [info exists keys(-set_to_set_distance)] } {
    set ssdistance $keys(-set_to_set_distance)
  }

  set offset 0
  if { [info exists keys(-start_offset)] } {
    set offset $keys(-start_offset)
  }

  set area 0
  if { [info exists keys(-area)] } {
    set area $keys(-area)
  }

  puts "add_stripe_over_area $nets $layer $direction $width $spacing $ssdistance $offset $area"
  add_stripe_over_area $nets $layer $direction $width $spacing $ssdistance $offset $area
}

proc add_stripe_over_area {nets layer direction width spacing ssdistance offset area} {
  # Ahh yes. Is coming all together
  global ::block
  global tech
  global dbu
  set core_area [$::block getCoreArea]
  set metal_obj [$tech findLayer $layer]
  #set x0 [expr [lindex $area 0] + 1.0*[$core_area xMin] / $dbu]
  #set y0 [expr [lindex $area 1] + 1.0*[$core_area yMin] / $dbu]
  #set x1 [expr [lindex $area 2] + 1.0*[$core_area xMin] / $dbu]
  #set y1 [expr [lindex $area 3] + 1.0*[$core_area yMin] / $dbu]
  set x0 [lindex $area 0]
  set y0 [lindex $area 1]
  set x1 [lindex $area 2]
  set y1 [lindex $area 3]
  if {$direction == "horizontal"} {
    set send [expr abs($y1-$y0)]
  } else {
    set send [expr abs($x1-$x0)]
  }
  set soffset $offset
  set s $offset
  set nnets [llength $nets]
  set inet 0
  if {$direction == "horizontal"} {
    set isver 0
  } else {
    set isver 1
  }
  while {1} {
    set s0 [expr $s]
    set s1 [expr $s+$width]

    # See if we need to break
    if {$s0 > $send || $s1 > $send} {
      break
    }

    # What is the actual box for drawing?
    if {$direction == "horizontal"} {
      set xl0 [expr int(round($x0*$dbu))]
      set xl1 [expr int(round($x1*$dbu))]
      set yl0 [expr int(round(($s0+$y0)*$dbu))]
      set yl1 [expr int(round(($s1+$y0)*$dbu))]
    } else {
      set xl0 [expr int(round(($s0+$x0)*$dbu))]
      set xl1 [expr int(round(($s1+$x0)*$dbu))]
      set yl0 [expr int(round($y0*$dbu))]
      set yl1 [expr int(round($y1*$dbu))]
    }

    # Just to be sure, we will use the fake connection of the net here
    set netobj [$::block findNet [lindex $nets $inet]]
    set sigTyp [$netobj getSigType]
    if {!($sigTyp == "GROUND" || $sigTyp == "POWER")} {
      $netobj setSigType "POWER"
    }

    # draw the stripe like a box (extracted from PdnGen.i:368)
    set new_swire [odb::dbSWire_create $netobj ROUTED]
    puts "odb::dbSBox_create $new_swire $metal_obj $xl0 $yl0 $xl1 $yl1 STRIPE $isver"
    odb::dbSBox_create $new_swire $metal_obj $xl0 $yl0 $xl1 $yl1 STRIPE $isver

    # go for the next stripe
    set inet [expr ($inet+1) % $nnets]
    if {$inet == 0} {
      set s [expr $soffset + $ssdistance]
      set soffset [expr $soffset + $ssdistance] 
    } else {
      set s [expr $s1 + $spacing]
    }
  }
}

proc create_sw_conn {x y path sizex w s nsw} {
  # setAddStripeMode -ignore_nondefault_domains true
  global metal2
  global metal2_px
  global metal2_w
  global metal2_s
  global metal3
  global abutsizey
  global row
  global ::block
  global dbu
  # Extract all the instances
  set all_sw "pgp_lz1 pgn_lz1 pgp_lz2 pgn_lz2"
  set all_inst {}
  for {set i 0} {$i < $nsw} {incr i} {
    foreach sw $all_sw {
      set inst $path.impl\\\[${i}\\\].impl/$sw
      if {[inst_exist $inst] == 1} {
        lappend all_inst $inst
      }
    }
  }
  # setAddStripeMode -orthogonal_only false
  set all_zsnnets {}
  foreach inst $all_inst {
    # Extract the ZN, VDD, and VSS pins
    set instobj [$::block findInst $inst]
    # set mastobj [$instobj getMaster]
    set znipin [$instobj findITerm zn]
    set vddipin [$instobj findITerm vdd]
    set vssipin [$instobj findITerm vss]
    set znpin [[$znipin getMTerm] getMPins]
    set vddpin [[$vddipin getMTerm] getMPins]
    set vsspin [[$vssipin getMTerm] getMPins]
    set znnet [[$znipin getNet] getName]
    set vddnet [[$vddipin getNet] getName]
    set vssnet [[$vssipin getNet] getName]
    
    # Get the ZN pin shape that matters
    # For now, the longest in y is the shape we need
    set znshapes [$znpin getGeometry]
    set znshape [lindex $znshapes 0]
    set znmaxdy 0
    foreach znsp $znshapes {
      set zns $znsp
      set zny1 [expr 1.0*[$zns yMin] / $dbu]
      set zny2 [expr 1.0*[$zns yMax] / $dbu]
      set zndy [expr $zny2 - $zny1]
      if {$zndy > $znmaxdy} {
        set znshape $zns
        set znmaxdy $zndy
      }
    }
    
    # Get VDD and VSS lower and high points
    set vddshapes [$vddpin getGeometry]
    set vdduy [expr 1.0*[ [lindex $vddshapes 0] yMax] / $dbu]
    foreach vddsp $vddshapes {
      set vddy [expr 1.0*[$vddsp yMax] / $dbu]
      if {$vddy > $vdduy} {
        set vdduy $vddy
      }
    }
    set vssshapes [$vsspin getGeometry]
    set vssdy [expr 1.0*[[lindex $vssshapes 0] yMin] / $dbu]
    foreach vsssp $vssshapes {
      set vssy [expr 1.0*[$vsssp yMin] / $dbu]
      if {$vssy < $vssdy} {
        set vssdy $vssy
      }
    }
    
    # Get xy for both zn and not zn
    set zncx1 [expr 1.0*[$znshape xMin] / $dbu]
    # set zncx2 [lindex $znshape 2] Possibly wrong. This has a M1 width, and we need to connect M2
    set zncx2 [expr $zncx1 + $metal2_w]
    set znnx1 [expr $zncx1 - $metal2_px]
    set znnx2 [expr $zncx2 - $metal2_px]
    
    # Get the pin that is not connected to zn
    set zsnnet [expr {$znnet == $vddnet? $vssnet : $vddnet}]
    
    # Append both nets to the list if existent
    if {[lsearch -exact $all_zsnnets $zsnnet] < 0} {
      lappend all_zsnnets $zsnnet
    }
    if {[lsearch -exact $all_zsnnets $znnet] < 0} {
      lappend all_zsnnets $znnet
    }
    
    # Get the current instance's origin point
    set inst_llx [expr 1.0*[[$instobj getBBox] xMin] / $dbu]
    set inst_lly [expr 1.0*[[$instobj getBBox] yMin] / $dbu]
    set inst_ury [expr 1.0*[[$instobj getBBox] yMax] / $dbu]
    
    # Trace the two stripes for the switches
    # ZN Rail vertical
    set x1 [expr $inst_llx + $zncx1]
    set x2 [expr $inst_llx + $zncx2]
    set y1 [expr $inst_lly + $vssdy]
    set y2 [expr $inst_lly + $vdduy]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $znnet -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
      -start_from left -start_offset 0 -area $area
     
    # not ZN Rail vertical
    set x1 [expr $inst_llx + $znnx1]
    set x2 [expr $inst_llx + $znnx2]
    set y1 [expr $inst_lly + $vssdy]
    set y2 [expr $inst_lly + $vdduy]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $zsnnet -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 100.0 \
      -start_from left -start_offset 0 -area $area
  }
  set nall_zsnnets [llength $all_zsnnets]
  set zsnspan [expr ($nall_zsnnets-1) * ($w+$s) + $w]
  set zsnst [expr $inst_lly+($row - $zsnspan)/2.0]
  for {set i 0} {$i < $nall_zsnnets} {incr i} {
    set net [lindex $all_zsnnets $i]
    set x1 [expr $x]
    set x2 [expr $x + $sizex]
    set y1 [expr $zsnst + $i*($w+$s)]
    set y2 [expr $zsnst + $i*($w+$s) + $w]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $net -layer $metal3 -direction horizontal \
      -width [expr $y2 - $y1] -spacing 0.0 -set_to_set_distance 100.0 \
      -start_from bottom -start_offset 0 -area $area
  }
  # setAddStripeMode -reset
}

# Procedure for creating the following connections
# for each of the CDACs in this order:
# 1. Connection from VDD, VSS, and Z of the Cap through FL (or whatever name)
# 1. Connection from I of the Cap through VSH (or whatever name)
# 3. Connection from the Switch to the Cap through VSH (or whatever name)
# 4. An extension of the stripes through Metal3 in horizontal to VSH and FL
# 5. Connections of the global vertical stripes
# It takes the result of positiong from the last call of "pos_cdac_circle" or similar
proc create_sw_cap_conn {x y pos lst pw ph sizex sizey strip} {
  # setAddStripeMode -ignore_nondefault_domains true
  global metal2
  global metal2_px
  global metal2_w
  global metal2_s
  global metal3
  global metal3_py
  global metal3_w
  global metal3_s
  global metal4
  global metal4_px
  global metal4_w
  global metal4_s
  global abutsizey
  global row
  # Iterate all CDACs
  set npos [llength $pos]
  for {set k 0} {$k < $npos} {incr k} {
    # setAddStripeMode -orthogonal_only false
    set p [lindex $pos $k]
    set pi [lindex $p 0]
    set pj [lindex $p 1]
    set l [lindex $lst $k]
    set path [lindex $l 0]
    set ind [lindex $l 1]
    
    # Extract all the instances
    set types "vi2cap cap2vouth cap2voutl"
    set all_sw "pgp_lz1 pgn_lz1 pgp_lz2 pgn_lz2"
    set all_inst {}
    foreach type $types {
      foreach sw $all_sw {
        set inst $path.${type}\\\[${ind}\\\].sw_${type}/$sw
        if {[inst_exist $inst] == 1} {
          lappend all_inst $inst
        }
      }
    }
    
    # Extract down capacitor and up capacitor (0 and end)
    set cap_index [expr $ind*$pw*$ph]
    set cap_inst "$path.cap\\\[${cap_index}\\\].cap/impl"
    set cap_instobj [$::block findInst $cap_inst]
    set cap_indexu [expr ($ind+1)*$pw*$ph - 1]
    set cap_instu "$path.cap\\\[${cap_indexu}\\\].cap/impl"
    set cap_instobju [$::block findInst $cap_instu]
    
    # Extract from all capacitors the actual llx, lly
    set cap_llx [expr 1.0*[[$cap_instobj getBBox] xMin] / $dbu]
    set cap_lly [expr 1.0*[[$cap_instobj getBBox] yMin] / $dbu]
    set capu_llx [expr 1.0*[[$cap_instobju getBBox] xMin] / $dbu]
    set capu_lly [expr 1.0*[[$cap_instobju getBBox] yMin] / $dbu]
    set capu_urx [expr 1.0*[[$cap_instobju getBBox] xMax] / $dbu]
    set capu_ury [expr 1.0*[[$cap_instobju getBBox] yMax] / $dbu]
    
    # Get the power rails for the capacitor
    set cap_powu_ury [expr $capu_ury + $abutsizey/2.0]
    set cap_powu_lly [expr $cap_lly - $abutsizey/2.0]
    
    # Extract the net of the VSH net capacitor, which is attached to the I
    set cap_ipin [dbGet -p $cap_instobj.pgInstTerms.name I]
    set vsh_name [dbGet $cap_ipin.net.name]
    set cap_ipin_shapes [dbGet $cap_ipin.term.pins.allShapes.shapes]
    set vsh_i_lly [dbGet [lindex $cap_ipin_shapes 0].rect_lly]
    set vsh_i_llx [dbGet [lindex $cap_ipin_shapes 0].rect_llx]
    set vsh_i_urx [dbGet [lindex $cap_ipin_shapes 0].rect_urx]
    foreach sp $cap_ipin_shapes {
      set lly [dbGet $sp.rect_lly]
      set llx [dbGet $sp.rect_llx]
      set urx [dbGet $sp.rect_urx]
      if {$lly < $vsh_i_lly} {
        set vsh_i_lly $lly
      }
      if {$llx < $vsh_i_llx} {
        set vsh_i_llx $llx
      }
      if {$urx > $vsh_i_urx} {
        set vsh_i_urx $urx
      }
    }
    set vsh_lly [expr $cap_lly+$vsh_i_lly]
    
    # Extract the FL net, attached mainly to ZN
    set cap_znpin [dbGet -p $cap_instobj.pgInstTerms.name ZN]
    set fl_name [dbGet $cap_znpin.net.name]
    set cap_znpin_shapes [dbGet $cap_znpin.term.pins.allShapes.shapes]
    set fl_zn_llx [dbGet [lindex $cap_znpin_shapes 0].rect_llx]
    set fl_zn_urx [dbGet [lindex $cap_znpin_shapes 0].rect_urx]
    foreach sp $cap_znpin_shapes {
      set llx [dbGet $sp.rect_llx]
      set urx [dbGet $sp.rect_urx]
      if {$llx < $fl_zn_llx} {
        set fl_zn_llx $llx
      }
      if {$urx > $fl_zn_urx} {
        set fl_zn_urx $urx
      }
    }
    # We need to shift the position of I if ZN is too near
    set vsh_i_llx_aft_fl [expr $fl_zn_llx + $metal2_px]
    set vsh_i_llx [expr {$vsh_i_llx < $vsh_i_llx_aft_fl ? $vsh_i_llx_aft_fl : $vsh_i_llx}]
    set vsh_i_urx_aft_fl [expr $fl_zn_urx - $metal2_px]
    set vsh_i_urx [expr {$vsh_i_urx > $vsh_i_urx_aft_fl ? $vsh_i_urx_aft_fl : $vsh_i_urx}]
    
    # Iterate all the instances
    set all_zsnnets {}
    foreach inst $all_inst {
      # Extract the ZN, VDD, and VSS pins
      set instobj [dbGet -p top.insts.name $inst]
      set znpin [dbGet -p $instobj.pgInstTerms.name ZN]
      set vddpin [dbGet -p $instobj.pgInstTerms.name VDD]
      set vsspin [dbGet -p $instobj.pgInstTerms.name VSS]
      set znnet [dbGet $znpin.net.name]
      set vddnet [dbGet $vddpin.net.name]
      set vssnet [dbGet $vsspin.net.name]
      
      # Get the ZN pin shape that matters
      # For now, the longest in y is the shape we need
      set znshapes [dbGet $znpin.term.pins.allShapes.shapes]
      set znshape [dbGet [lindex $znshapes 0].rect]
      set znmaxdy 0
      foreach znsp $znshapes {
        set zns [lindex [dbGet $znsp.rect] 0]
        set zny1 [lindex $zns 1]
        set zny2 [lindex $zns 3]
        set zndy [expr $zny2 - $zny1]
        if {$zndy > $znmaxdy} {
          set znshape $zns
          set znmaxdy $zndy
        }
      }
      
      # Get VDD and VSS lower and high points
      set vddshapes [dbGet $vddpin.term.pins.allShapes.shapes]
      set vdduy [dbGet [lindex $vddshapes 0].rect_ury]
      foreach vddsp $vddshapes {
        set vddy [dbGet $vddsp.rect_ury]
        if {$vddy > $vdduy} {
          set vdduy $vddy
        }
      }
      set vssshapes [dbGet $vsspin.term.pins.allShapes.shapes]
      set vssdy [dbGet [lindex $vssshapes 0].rect_lly]
      foreach vsssp $vssshapes {
        set vssy [dbGet $vsssp.rect_lly]
        if {$vssy < $vssdy} {
          set vssdy $vssy
        }
      }
      
      # Get xy for both zn and not zn
      set zncx1 [lindex $znshape 0]
      # set zncx2 [lindex $znshape 2] Possibly wrong. This has a M1 width, and we need to connect M2
      set zncx2 [expr $zncx1 + $metal2_w]
      set znnx1 [expr $zncx1 - $metal2_px]
      set znnx2 [expr $zncx2 - $metal2_px]
      
      # Get the pin that is not connected to zn
      set zsnnet [expr {$znnet == $vddnet? $vssnet : $vddnet}]
      
      # Append both nets to the list if existent
      if {[lsearch -exact $all_zsnnets $zsnnet] < 0} {
        lappend all_zsnnets $zsnnet
      }
      if {[lsearch -exact $all_zsnnets $znnet] < 0} {
        lappend all_zsnnets $znnet
      }
      
      # Get the current instance's origin point
      set inst_llx [dbGet $instobj.box_llx]
      set inst_lly [dbGet $instobj.box_lly]
      set inst_ury [dbGet $instobj.box_ury]
      
      # Trace the two stripes for the switches
      # ZN Rail vertical
      set x1 [expr $inst_llx + $zncx1]
      set x2 [expr $inst_llx + $zncx2]
      set y1 [expr $inst_lly + $vssdy]
      set y2 [expr $inst_lly + $vdduy]
      if {$znnet == $vsh_name} {
        set y1 $vsh_lly
      }
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $znnet -layer $metal2 -direction vertical \
        -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from left -start_offset 0 -area $area
       
      # not ZN Rail vertical
      set x1 [expr $inst_llx + $znnx1]
      set x2 [expr $inst_llx + $znnx2]
      set y1 [expr $inst_lly + $vssdy]
      set y2 [expr $inst_lly + $vdduy]
      if {$znnet != $vsh_name} {
        set y1 $vsh_lly
      }
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $zsnnet -layer $metal2 -direction vertical \
        -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from left -start_offset 0 -area $area
    }
    
    # Assuming that ZN extends more than I, we draw ZN then I
    # Two ZN Rail vertical (A.K.A. FL)
    set x1 [expr $cap_llx + $fl_zn_llx]
    set x2 [expr $cap_llx + $fl_zn_llx + $metal2_w]
    set y1 [expr $cap_powu_lly]
    set y2 [expr $inst_ury - $abutsizey/2.0]
    #set y2 [expr $cap_powu_ury]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $fl_name -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
      -start_from left -start_offset 0 -area $area
    set x1 [expr $capu_llx + $fl_zn_urx - $metal2_w]
    set x2 [expr $capu_llx + $fl_zn_urx]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $fl_name -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
      -start_from left -start_offset 0 -area $area
    # We need to connect the ZN for the middle caps
    for {set l 1} {$l < [expr $pw-1]} {incr l} {
      set cap_indexm [expr $ind*$pw*$ph+$l]
      set cap_instm $path/cap_${cap_indexm}_cap/impl
      set cap_instobjm [dbGet -p top.insts.name $cap_instm]
      set capm_llx [dbGet $cap_instobjm.box_llx]
      set capm_lly [dbGet $cap_instobjm.box_lly]
      set x1 [expr $capm_llx + $fl_zn_llx]
      set x2 [expr $capm_llx + $fl_zn_llx + $metal2_w]
      set y1 [expr $cap_powu_lly]
      set y2 [expr $cap_powu_ury]
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $fl_name -layer $metal2 -direction vertical \
        -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from left -start_offset 0 -area $area
      set x1 [expr $capm_llx + $fl_zn_urx - $metal2_w]
      set x2 [expr $capm_llx + $fl_zn_urx]
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $fl_name -layer $metal2 -direction vertical \
        -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from left -start_offset 0 -area $area
    }
    # Two I Rail vertical (AKA VSH)
    set x1 [expr $cap_llx + $vsh_i_llx]
    set x2 [expr $cap_llx + $vsh_i_llx + $metal2_w]
    set y1 [expr $cap_powu_lly]
    set y2 [expr $inst_ury - $abutsizey/2.0]
    #set y2 [expr $cap_powu_ury]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $vsh_name -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
      -start_from left -start_offset 0 -area $area
    set x1 [expr $capu_llx + $vsh_i_urx - $metal2_w]
    set x2 [expr $capu_llx + $vsh_i_urx]
    set area "$x1 $y1 $x2 $y2"
    addStripe -nets $vsh_name -layer $metal2 -direction vertical \
      -width [expr $x2 - $x1] -spacing 0.0 -set_to_set_distance 1.0 \
      -start_from left -start_offset 0 -area $area
    # NOTE: As for the middle cap... we hope the switch connect it. Crossing fingers xoxo
    
    setAddStripeMode -orthogonal_only true
    
    # Search for the left and right neighboors
    # The criteria for now is comparing the vsh_name with the neighboor
    set posl "[expr $pi-1] $pj"
    set posr "[expr $pi+1] $pj"
    set kl [lsearch -exact $pos $posl]
    set kr [lsearch -exact $pos $posr]
    set marginl 0.0
    set marginr 0.0
    if {$kl >= 0} {
      set ll [lindex $lst $kl]
      set pathl [lindex $ll 0]
      set indl [lindex $ll 1]
      set capl_index [expr $indl*$pw*$ph]
      set capl_inst $pathl/cap_${capl_index}_cap/impl
      set capl_instobj [dbGet -p top.insts.name $capl_inst]
      set capl_ipin [dbGet -p $capl_instobj.pgInstTerms.name I]
      set vshl_name [dbGet $capl_ipin.net.name]
      if {$vshl_name != $vsh_name} {
        # Add the margin. Just a single metal2 pitch
        set marginl $metal2_px
      }
    }
    if {$kr >= 0} {
      set lr [lindex $lst $kr]
      set pathr [lindex $lr 0]
      set indr [lindex $lr 1]
      set capr_index [expr $indr*$pw*$ph]
      set capr_inst $pathr/cap_${capr_index}_cap/impl
      set capr_instobj [dbGet -p top.insts.name $capr_inst]
      set capr_ipin [dbGet -p $capr_instobj.pgInstTerms.name I]
      set vshr_name [dbGet $capr_ipin.net.name]
      if {$vshr_name != $vsh_name} {
        # Add the margin. Just a single metal2 pitch
        set marginr $metal2_px
      }
    }
    
    # The previous procedure extracted all the nets that connect into "all_zsnnets"
    # There shall be around 4 nets maximum. We create rails in metal3 from side to side
    if {[lsearch -exact $all_zsnnets $fl_name] < 0} {
      lappend all_zsnnets $fl_name
    }
    if {[lsearch -exact $all_zsnnets $vsh_name] < 0} {
      lappend all_zsnnets $vsh_name
    }
    set nall_zsnnets [llength $all_zsnnets]
    set zsnspan [expr ($nall_zsnnets-1) * $metal3_py + $metal3_w]
    set zsnst [expr $inst_lly+($row - $zsnspan)/2.0]
    for {set i 0} {$i < $nall_zsnnets} {incr i} {
      set net [lindex $all_zsnnets $i]
      set x1 [expr $x + ($pi)*$sizex + $marginl]
      set x2 [expr $x + ($pi+1)*$sizex - $marginr]
      set y1 [expr $zsnst + $i*$metal3_py]
      set y2 [expr $zsnst + $i*$metal3_py + $metal3_w]
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $net -layer $metal3 -direction horizontal \
        -width [expr $y2 - $y1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from bottom -start_offset 0 -area $area
    }
    
    # Connect the nets from the capacitor
    set all_capnets "$vsh_name $fl_name"
    set nall_capnets [llength $all_capnets]
    set capspan [expr ($nall_capnets-1) * $metal3_py + $metal3_w]
    set capst [expr $cap_lly+($row*$ph - $capspan)/2.0]
    for {set i 0} {$i < $nall_capnets} {incr i} {
      set net [lindex $all_capnets $i]
      set x1 [expr $x + ($pi)*$sizex + $marginl]
      set x2 [expr $x + ($pi+1)*$sizex - $marginr]
      set y1 [expr $capst + $i*$metal3_py]
      set y2 [expr $capst + $i*$metal3_py + $metal3_w]
      set area "$x1 $y1 $x2 $y2"
      addStripe -nets $net -layer $metal3 -direction horizontal \
        -width [expr $y2 - $y1] -spacing 0.0 -set_to_set_distance 1.0 \
        -start_from bottom -start_offset 0 -area $area
    }
  }
  setAddStripeMode -reset

  setAddStripeMode -ignore_nondefault_domains true
  setAddStripeMode -orthogonal_only true -stacked_via_top_layer M4 -stacked_via_bottom_layer M3
  set npos [llength $pos]
  for {set k 0} {$k < $npos} {incr k} {
    set p [lindex $pos $k]
    set pi [lindex $p 0]
    set pj [lindex $p 1]
    set l [lindex $lst $k]
    set path [lindex $l 0]
    set ind [lindex $l 1]
    
    # Extract down capacitor and up capacitor (0 and end)
    set cap_index [expr $ind*$pw*$ph]
    set cap_inst $path/cap_${cap_index}_cap/impl
    set cap_instobj [dbGet -p top.insts.name $cap_inst]
    
    # Extract the net of the VSH net capacitor, which is attached to the I
    set cap_ipin [dbGet -p $cap_instobj.pgInstTerms.name I]
    set vsh_name [dbGet $cap_ipin.net.name]
    
    # Extract the FL net, attached mainly to ZN
    set cap_znpin [dbGet -p $cap_instobj.pgInstTerms.name ZN]
    set fl_name [dbGet $cap_znpin.net.name]
    
    # Search for the up and down neighboors
    # The criteria for now is comparing the vsh_name with the neighboor
    set posd "[expr $pi] [expr $pj-1]"
    set posu "[expr $pi] [expr $pj+1]"
    set kd [lsearch -exact $pos $posd]
    set ku [lsearch -exact $pos $posu]
    set margind 0.0
    set marginu 0.0
    if {$kd >= 0} {
      set ld [lindex $lst $kd]
      set pathd [lindex $ld 0]
      set indd [lindex $ld 1]
      set capd_index [expr $indd*$pw*$ph]
      set capd_inst $pathd/cap_${capd_index}_cap/impl
      set capd_instobj [dbGet -p top.insts.name $capd_inst]
      set capd_ipin [dbGet -p $capd_instobj.pgInstTerms.name I]
      set vshd_name [dbGet $capd_ipin.net.name]
      if {$vshd_name != $vsh_name} {
        # Add the margin. Just a single metal4 pitch
        set margind $metal4_px
      }
    }
    if {$ku >= 0} {
      set lu [lindex $lst $ku]
      set pathu [lindex $lu 0]
      set indu [lindex $lu 1]
      set capu_index [expr $indu*$pw*$ph]
      set capu_inst $pathu/cap_${capu_index}_cap/impl
      set capu_instobj [dbGet -p top.insts.name $capu_inst]
      set capu_ipin [dbGet -p $capu_instobj.pgInstTerms.name I]
      set vshu_name [dbGet $capu_ipin.net.name]
      if {$vshu_name != $vsh_name} {
        # Add the margin. Just a single metal4 pitch
        set marginu $metal4_px
      }
    }
    
    set all_capnets "$vsh_name $fl_name"

    # Create and connect the global vertical
    set wthird [expr 4*$metal4_w]
    set sthird [expr 2*$metal4_s]
    set nets "[lindex $all_capnets 0] [lindex $all_capnets 1]"
#    set nets "[lindex $all_capnets 0] $strip [lindex $all_capnets 1]"
    set nnets [expr [llength $nets] + [llength $strip] + 2]
    set netspan [expr ($nnets-1) * ($sthird+$wthird) + $wthird]
    set offset [expr ($sizex - $netspan)/2.0]

    set x1 [expr $x + ($pi)*$sizex]
    set x2 [expr $x + ($pi+1)*$sizex]
    set y1 [expr $y + ($pj)*$sizey + $margind]
    set y2 [expr $y + ($pj+1)*$sizey - $marginu]
    set area "$x1 $y1 $x2 $y2"
    setAddStripeMode -ignore_nondefault_domains true
    setAddStripeMode -orthogonal_only true -stacked_via_top_layer M4 -stacked_via_bottom_layer M3
    addStripe -nets $nets -layer $metal4 -direction vertical \
      -width $wthird -spacing $sthird -set_to_set_distance $sizex \
      -start_from left -start_offset $offset -area $area
  }
  setAddStripeMode -reset
}

proc create_stripes_vdd_vss {x y sizex nx abssizey tapcap netvdd netvss w} {
  global metal2
  global abutsizey
  global dbu
  set tap_lib [[::ord::get_db] findLib $tapcap]
  set tap_master [$tap_lib findMaster $tapcap]
  set sizetap [expr 1.0*[$tap_master getWidth] / $dbu]
  
  set x1 [expr $x - $sizetap]
  set x2 [expr $x + $sizex*$nx + $sizetap]
  set y1 [expr $y - $abutsizey/2]
  set y2 [expr $y + $abssizey]
  set area "$x1 $y1 $x2 $y2"
  
  set offset [expr $sizetap/2.0 - $w/2.0 + $sizetap]
  #setAddStripeMode -ignore_nondefault_domains true
  #setAddStripeMode -orthogonal_only true -stacked_via_top_layer M4 -stacked_via_bottom_layer M1
  add_stripe_over_area [list $netvdd] $metal2 vertical $w 0.0 $sizex $offset $area
  #addStripe -nets $netvdd -layer $metal2 -direction vertical \
  #  -width $w -spacing 0.0 -set_to_set_distance $sizex \
  #  -start_from left -start_offset $offset -area $area
  set offset [expr $sizetap/2.0 - $w/2.0]
  #addStripe -nets $netvss -layer $metal2 -direction vertical \
  #  -width $w -spacing 0.0 -set_to_set_distance $sizex \
  #  -start_from left -start_offset $offset -area $area
  add_stripe_over_area [list $netvss] $metal2 vertical $w 0.0 $sizex $offset $area
  #setAddStripeMode -reset
}

proc create_stripes {x y sizex nx uy nets w s} {
  global metal4
  global abutsizey
  set nnets [llength $nets]
  set netspan [expr ($nnets-1) * ($s+$w) + $w] 
  set offset [expr ($sizex - $netspan)/2.0]
  
  set x1 [expr $x]
  set x2 [expr $x + $sizex*$nx]
  set y1 [expr $y - $abutsizey/2]
  set y2 [expr $uy]
  set area "$x1 $y1 $x2 $y2"
  setAddStripeMode -ignore_nondefault_domains true
  setAddStripeMode -orthogonal_only true -stacked_via_top_layer M4 -stacked_via_bottom_layer M3
  addStripe -nets $nets -layer $metal4 -direction vertical \
    -width $w -spacing $s -set_to_set_distance $sizex \
    -start_from left -start_offset $offset -area $area
  setAddStripeMode -reset
}

