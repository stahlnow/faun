///////////////////////////////////////////////
//	FAUN LASER CUTTABLE BOX
//	v1.0
///////////////////////////////////////////////

// smooth curves
$fs = 0.5;

// material thickness
thickness = 3;

// pcb params
pcb_width = 83;
pcb_length = 71;
pcb_thickness = 1.6;
pcb_offset = 1; // offset from side panel
standoff = 10;	// pcb standoff

// transformer params
transformer_radius=35.5;
transformer_height=35;
transformer_offset=1;

// how big we want the volume inside the case
width = pcb_width+2*pcb_offset;
length = pcb_length+2*transformer_radius+pcb_offset+transformer_offset+1;
height = 36+standoff;

// some adjustable parameters
spacing = 2; 			// space between top/bottom plates and side panels
roundness = 2; 		// roundness of the corners
slot_count_fb = 3; 	// number of slots on the front and back (>=2)
slot_length_fb = 14;	// slot length front/back
slot_count_rl = 5; 	// number of slots on the sides (>=2)
slot_length_rl = 10;	// slot length right/left


// build it!!
faun_case();
// laser it!!
//faun_laser();

/**********************************************************************************************
 building
**********************************************************************************************/

module faun_case()
{
	//build_volume();
	build_bottom();
	build_top();
	build_right();
	build_left();
	build_front();
	build_back();

	build_pcb();
	build_transformer();
}

module faun_laser()
{
	proj_pad = 1;  						// space between panels for cutting
	projection() build_top();
	projection() translate([0,length+proj_pad+2*spacing+2*thickness,0]) build_bottom();
	projection() translate([0,-length/2-height/2-2*thickness-spacing-proj_pad, 0]) rotate([90,0,0]) build_front();
	projection() translate([0,-length/2-height-height/2-4*thickness-spacing-2*proj_pad, 0]) rotate([90,0,0]) build_back();
	projection() translate([width/2+height/2+2*thickness+spacing+proj_pad,0, 0]) rotate([0,90,0]) build_right();
	projection() translate([width/2+height/2+2*thickness+spacing+proj_pad,length+proj_pad+2*spacing+2*thickness, 0]) rotate([0,90,0]) build_left();
}

/**********************************************************************************************
 pcb and transformer
**********************************************************************************************/
module build_pcb()
{
	difference()
	{
		color("Green")
		translate([0, -length/2 + pcb_length/2 + pcb_offset, standoff-height/2+pcb_thickness/2])
		cube([pcb_width, pcb_length, pcb_thickness], center=true);
		
		cutout_pcb_holes();
	}
}

module build_transformer()
{
	color("Silver")
	translate([0, length/2 - transformer_radius - transformer_offset, -height/2])
	cylinder(r=transformer_radius, h=transformer_height);
}


/**********************************************************************************************
 the volume inside the box
**********************************************************************************************/
module build_volume()
{
	color("Pink")
	cube([width, length, height], center=true);
}


/**********************************************************************************************
 cutouts
**********************************************************************************************/
module build_cutouts_top()
{
	// transformer hole top
	r = 3; // M6 thread
	translate([0, length/2 - transformer_radius - transformer_offset, height/2-thickness*1.5])
	cylinder(r=r, h=thickness*4);
}

module build_cutouts_bottom()
{
	cutout_pcb_holes();

	// transformer hole bottom
	r = 3; // M6 thread
	translate([0, length/2 - transformer_radius - transformer_offset, -height/2-thickness*1.5])
	cylinder(r=r, h=thickness*4);
}


module build_cutouts_front()
{
	cutout_speakON();

	// hooks
	r = 2; // M4 thread
	x = 5;
	z = 13;
	translate([width/2-r-pcb_offset-x, -length/2+thickness/2, height/2-pcb_thickness-z])
	rotate([90,90,0])
	cylinder(r=r, h=thickness*2);
	translate([-width/2+r+pcb_offset+x, -length/2+thickness/2, height/2-pcb_thickness-z])
	rotate([90,90,0])
	cylinder(r=r, h=thickness*2);
}

module build_cutouts_left()
{
	cutout_jack();
	cutout_pot();
	cutout_switch();
}

module build_cutouts_right()
{
	cutout_dc();
	cutout_micro_usb();
}

module cutout_pcb_holes()
{
	// pcb mounting holes
	r = 1.5; // M3 thread
	x = 6;
	y = 18;
	translate([width/2-pcb_offset-x, -length/2 + pcb_offset + y, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);

	x2 = 33;
	y2 = 67;
	translate([width/2-pcb_offset-x2, -length/2 + pcb_offset + y2, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);

	x3 = 55;
	y3 = 7;
	translate([width/2-pcb_offset-x3, -length/2 + pcb_offset + y3, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);

	x4 = 66;
	y4 = 31;
	translate([width/2-pcb_offset-x4, -length/2 + pcb_offset + y4, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);

	// extra holes
	x5 = 5;
	y5 = 5;
	translate([width/2-pcb_offset-x5, length/2 - pcb_offset - y5, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);
	translate([-width/2+pcb_offset+x5, length/2 - pcb_offset - y5, -height/2-thickness*1.5])
	rotate([0,0,90])
	cylinder(r=r, h=standoff+thickness*4);
}

module cutout_jack()
{
	// Audio JACK
	r = 6.75;
	y = 14.5;		// y offset
	z = standoff+8.5-r;					// z offset
	translate([-width/2-thickness-0.25, -length/2 + pcb_offset + y, -height/2+r+pcb_thickness+ z])
	rotate([90,0,90])
	cylinder(r=r, h=thickness+0.5);
}

module cutout_pot()
{
	// Volume pot
	r = 3.5;
	y = 33;			// y offset
	z = standoff+6.5-r;						// z offset
	translate([-width/2-thickness-0.25, -length/2 + pcb_offset + y, -height/2+r+pcb_thickness+ z])
	rotate([90,0,90])
	cylinder(r=r, h=thickness+0.5);
}

module cutout_switch()
{
	// Power switch
	l = 8;		 	// length
	h = 4;	 		// height
	y = 57;			// y offset
	z = standoff+1.3;		// z offset
	translate([-width/2-thickness/2, -length/2 + pcb_offset + l/2 + y, -height/2+pcb_thickness+h/2+ z])
	cube([thickness*2, l, h], center=true);
}


module cutout_dc()
{
	// DC plug
	r = 6;						// radius
	y = 9;		// y offset
	z = standoff;						// z offset
	translate([width/2-thickness/2, -length/2 + pcb_offset + y, -height/2+r+pcb_thickness+ z])
	rotate([90,0,90])
	cylinder(r=r, h=thickness*2);
}

module cutout_speakON()
{
	// speakON
	r = 12;							// radius
	r2 = 1.6;						// radius screw
	x = 16;							// x offset from right side
	z = standoff+6;							// z offset

	translate([width/2-r-pcb_offset-x, -length/2+thickness/2, -height/2+r+pcb_thickness+z])
	rotate([90,90,0])
	cylinder(r=r, h=thickness*2);

	translate([width/2-r-pcb_offset-x-9.5, -length/2+thickness/2, -height/2+r+pcb_thickness+z+r])
	rotate([90,90,0])
	cylinder(r=r2, h=thickness*2);

	translate([width/2-r-pcb_offset-x+9.5, -length/2+thickness/2, -height/2+r+pcb_thickness+z-r])
	rotate([90,90,0])
	cylinder(r=r2, h=thickness*2);
}

module cutout_micro_usb()
{
	// micro USB
	l = 12;	 	// length
	h = 9;	 	// height
	y = 59; 	// y offset
	z = standoff-3;		// z offset
	translate([width/2+thickness/2, -length/2 + pcb_offset + l/2 + y, -height/2+pcb_thickness+h/2+ z])
	cube([thickness*2, l, h], center=true);
}

/**********************************************************************************************
 panels
**********************************************************************************************/
module build_bottom()
{
	color("LightGrey")
    difference()
    {
		translate([0,0,-height/2-thickness/2])
		panel_bottom_or_top();
		translate([0,0,-height/2-thickness/2])
		slots_bottom_or_top();
		build_cutouts_bottom();	
    }	
}

module build_top()
{
	color("LightGrey")
	difference()
	{
		translate([0,0,height/2+thickness/2])
		panel_bottom_or_top();
		translate([0,0,height/2+thickness/2])
		slots_bottom_or_top();
		build_cutouts_top();
	}
}

module build_front()
{
	color("Blue")
	difference()
	{
		build_panel_front();
		build_cutouts_front();
	}
}

module build_back()
{
	color("Red")
	difference()
	{
		build_panel_back();
		build_cutouts_back();
	}
}

module build_right()
{
	color("Yellow")
	difference()
	{
		build_panel_right();
		build_cutouts_right();		
	}
}

module build_left()
{
	color("Pink")
	difference()
	{
		build_panel_left();
		build_cutouts_left();
	}
}


/**********************************************************************************************
 sub routines panels
**********************************************************************************************/
module panel_bottom_or_top()
{
	minkowski()
    {
        // have to take into account the radius of the cylinder, so subtract from width and length
        cube([
				width + 2*thickness + 2*spacing - 2*roundness,
				length + 2*thickness + 2*spacing - 2*roundness,
				thickness], center=true);
        cylinder(r=roundness, h=0.001);
    }	
  	//cube([width + 2*thickness + 2*spacing, length + 2*thickness + 2*spacing, thickness], center=true);
}

module build_panel_left()
{
	union()
	{		
		translate([-width/2 - thickness/2, 0, 0])
		cube([thickness, length, height], center=true);
		build_slots_right_or_left(false);
	}
}

module build_panel_right()
{
	union()
	{			
		translate([width/2 + thickness/2, 0, 0])
		cube([thickness, length, height], center=true);
		build_slots_right_or_left(true);
	}
}

module build_panel_front()
{
	union()
	{	
		translate([0, -length/2 - thickness/2, 0])
		cube([width+2*thickness, thickness, height], center=true);
		build_slots_front_or_back(true);
	}
}

module build_panel_back()
{
	union()
	{	
		translate([0, length/2 + thickness/2, 0])
		cube([width+2*thickness, thickness, height], center=true);
		build_slots_front_or_back(false);
	}
}


/**********************************************************************************************
 slots
**********************************************************************************************/
module slots_bottom_or_top()
{
	build_slots_front_or_back(true);
	build_slots_front_or_back(false);
	build_slots_right_or_left(true);
	build_slots_right_or_left(false);
}
       
module build_slots_front_or_back(front)
{
	for (x = [-width/2+slot_length_fb : (width-2*slot_length_fb)/(slot_count_fb-1) : width/2-slot_length_fb])
	{
		if (front == true) {
			translate([x, -length/2 - thickness/2, 0])
			cube([slot_length_fb,thickness,height+2*thickness],center=true);
		} else {
			translate([x, +length/2 + thickness/2, 0])
			cube([slot_length_fb,thickness,height+2*thickness],center=true);
		}
	}
}

module build_slots_right_or_left(right)
{
	for (y = [-length/2+slot_length_rl : (length-2*slot_length_rl)/(slot_count_rl-1) : length/2-slot_length_rl])
	{
		if (right == true) {
			translate([width/2 + thickness/2, y, 0])
			cube([thickness,slot_length_rl,height+2*thickness],center=true);
		} else {
			translate([-width/2 - thickness/2, y, 0])
			cube([thickness,slot_length_rl,height+2*thickness],center=true);
		}
	}
}


