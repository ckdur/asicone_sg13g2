proc find_pad {inst_obj} {
	global ::block
	global top_metal
	foreach iterm [$inst_obj getITerms] {
		set mterm [$iterm getMTerm]
		foreach mpins [$mterm getMPins] {
			foreach geom [$mpins getGeometry] {
				if {[$geom yMin] != 0 || [[$geom getTechLayer] getName] != $top_metal} {
					continue
				}
				# Found it
				return $iterm
				break
			}
		}
	}
	return "NULL"
}

proc set_pins_as_special {} {
	global ::block
	global top_metal
	
  foreach inst_obj [$::block getInsts] {
		set name [[$inst_obj getMaster] getName]
		if {![regexp [list sg13g2_IOPad.*] $name]} {
			continue
		}
		# Find the outside-most pin
		set pin_iterm [find_pad $inst_obj]
		if {$pin_iterm == "NULL" || [$pin_iterm getNet] == "NULL"} {
			# No net in this iterm. skip
			continue
		}
		set netobj [$pin_iterm getNet]
		$netobj setSpecial
	}
}

proc put_pins_on_bondpad {size_bond} {
	global ::block
	global top_metal
	
  foreach inst_obj [$::block getInsts] {
		set name [[$inst_obj getMaster] getName]
		if {![regexp [list sg13g2_IOPad.*] $name]} {
			continue
		}
		# Find the outside-most pin
		set pin_iterm [find_pad $inst_obj]
		if {$pin_iterm == "NULL" || [$pin_iterm getNet] == "NULL"} {
			# No net in this iterm. skip
			continue
		}
		set pin_net_name [[$pin_iterm getNet] getName]
		set orient [$inst_obj getOrient]
		if {$orient == "R0"} {
			set x [expr [::ord::dbu_to_microns [[$inst_obj getBBox] xMin]] + [::ord::dbu_to_microns [[$inst_obj getBBox] getDX]]/2]
			set y [expr [::ord::dbu_to_microns [[$inst_obj getBBox] yMin]] - $size_bond/2]
		} elseif {$orient == "R90"} {
			set x [expr [::ord::dbu_to_microns [[$inst_obj getBBox] xMax]] + $size_bond/2]
			set y [expr [::ord::dbu_to_microns [[$inst_obj getBBox] yMin]] + [::ord::dbu_to_microns [[$inst_obj getBBox] getDY]]/2]
		} elseif {$orient == "R180"} {
			set x [expr [::ord::dbu_to_microns [[$inst_obj getBBox] xMin]] + [::ord::dbu_to_microns [[$inst_obj getBBox] getDX]]/2]
			set y [expr [::ord::dbu_to_microns [[$inst_obj getBBox] yMax]] + $size_bond/2]
		} elseif {$orient == "R270"} {
			set x [expr [::ord::dbu_to_microns [[$inst_obj getBBox] xMin]] - $size_bond/2]
			set y [expr [::ord::dbu_to_microns [[$inst_obj getBBox] yMin]] + [::ord::dbu_to_microns [[$inst_obj getBBox] getDY]]/2]
		}
		place_pin -pin_name $pin_net_name -layer $top_metal -location [list $x $y] -pin_size [list 20 20]
	}
}
