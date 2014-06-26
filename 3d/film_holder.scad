module holder() {
	
	m2_diameter = 2.5; // would be 2
	m2_nut_size = 4.3; // would be 4 acutally

	outer_diameter = 2;
	
	height = 8; // must be greater than nut_size

	screw_diameter = m2_diameter;
	nut_size = m2_nut_size;
	nut_height = 2;

	length = 10;
	screw_offset_x = 5;

	rod_diameter = 2.75;			

	gap = 0.9;	

	translate([-outer_diameter, -outer_diameter, -height/2])
	
	difference()
	{

		union()
		{
			translate([outer_diameter, outer_diameter, 0])
			cylinder(h = height, r = outer_diameter, $fn = 20);
			
			translate([outer_diameter, 0, 0])
			cube([length, outer_diameter*2, height]);
			
			// nut
			translate([screw_offset_x, outer_diameter*2+1.3, height/2])
			rotate([90,0,0])
			rotate([0,0,0])

			difference() {
	  		   	cylinder(r = height/sqrt(3), h=nut_height, $fn=6);	
				cylinder(r = nut_size/sqrt(3), h=height/2, center=true, $fn=6);
				// uncomment for smaller nut outline
				translate([-5, 1.5, 0])
				cube([10,15,20]);
			}

			// screw 
	  		translate([screw_offset_x, -0.9, height/2])
			rotate([-90,0,0])
	  		cylinder(r1=height/2, r2=height/2, h=nut_height, center=true, $fn=22);
		}	
	
		// gap
		translate([length/2-2, outer_diameter-gap/2, -1])
		cube([length, gap, height+1.1]);
	
		// rod hole
		translate([outer_diameter, outer_diameter, -0.1])
		cylinder(h=height*2, r=rod_diameter/2, $fn = 18);
		
		// screw hole
		translate([screw_offset_x, screw_offset_x, height/2])
		rotate([90, 0, 0])
		cylinder(h = 2 * (outer_diameter + nut_height * 2), r = screw_diameter/2, $fn = 10);
	
	
	}
}

holder();

