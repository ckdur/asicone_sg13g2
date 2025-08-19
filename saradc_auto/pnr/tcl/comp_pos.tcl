proc filter_by_regex {pattern lst} {
    set result {}
    foreach item $lst {
        if {[regexp $pattern [$item getName]]} {
            lappend result $item
        }
    }
    return $result
}

proc pos_stdcell_comp {x y path} {
  global track
  global row
  global metal1_py
  global saradc_fill_nopower
  global ::block
  global dbu
  
  set vp_cmp_objs [filter_by_regex [list ${path}.vp_cmp\..*] [$::block getInsts]]
  set vn_cmp_objs [filter_by_regex [list ${path}.vn_cmp\..*] [$::block getInsts]]
  set vp_n2p_objs [filter_by_regex [list ${path}.n2p\..*] [$::block getInsts]]
  set vn_p2n_objs [filter_by_regex [list ${path}.p2n\.*] [$::block getInsts]]
  set vp_buf_objs [filter_by_regex [list ${path}.buf_p.*] [$::block getInsts]]
  set vn_buf_objs [filter_by_regex [list ${path}.buf_n.*] [$::block getInsts]]
  
  set vp_cmp_objs [list {*}$vp_cmp_objs {*}$vp_n2p_objs {*}$vp_buf_objs]
  set vn_cmp_objs [list {*}$vn_cmp_objs {*}$vn_p2n_objs {*}$vn_buf_objs]
  
  set n [llength $vp_cmp_objs]
  set upx $x
  set dwx $x
  set upy $y
  set dwy [expr $y+$row]
  for {set i 0} {$i < $n} {incr i} {
    set up_obj [lindex $vp_cmp_objs $i]
    set dw_obj [lindex $vn_cmp_objs $i]
    set up_inst [$up_obj getName]
    set dw_inst [$dw_obj getName]
    set up_sizex [expr 1.0*[[$up_obj getMaster] getWidth] / $dbu]
    set dw_sizex [expr 1.0*[[$dw_obj getMaster] getWidth] / $dbu]

    if {[[$::block findInst $up_inst] isPlaced] == 0} {
      # puts "place_inst -name \[list $up_inst\] -location \"$upx $upy\" -orientation R0 -status LOCKED"
      place_inst -name [list $up_inst] -location "$upx $upy" -orientation R0 -status LOCKED
    }
    if {[[$::block findInst $dw_inst] isPlaced] == 0} {
      # puts "place_inst -name \[list $dw_inst\] -location \"$dwx $dwy\" -orientation MX -status LOCKED"
      place_inst -name [list $dw_inst] -location "$dwx $dwy" -orientation MX -status LOCKED
    }
    set upx [expr $upx + $up_sizex]
    set dwx [expr $dwx + $dw_sizex]
  }
  
  set compx [expr $upx - $x]
  set compy [expr 2*$row]
  return "$compx $compy"
}

proc pos_stdcell_box {x y width path} {
  global dbu
  global row
  # A very simple and dummy stdcell placement
  set stdcell_objs [filter_by_regex [list ${path}\..*] [$::block getInsts]]
  set curx 0.0
  set cury 0.0
  set currot "R0"
  foreach obj $stdcell_objs {
    set inst [$obj getName]
    set sizex [expr 1.0*[[$obj getMaster] getWidth] / $dbu]
    set nextx [expr $curx+$sizex]
    if {$nextx > $width} {
      if {$currot == "R0"} {
        set currot "MX"
      } else {
        set currot "R0"
      }
      set curx 0
      set cury [expr $cury+$row]
      set nextx [expr $sizex]
    }
    if {[[$::block findInst $inst] isPlaced] == 0} {
      place_inst -name [list $inst] -location "[expr $x+$curx] [expr $y+$cury]" -orientation $currot -status PLACED
    }
    set curx $nextx
  }
}