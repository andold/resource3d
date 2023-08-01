use <MCAD/boxes.scad>

module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
}

module lineBox(outter = [128, 128, 128], t = 4) {
	size = outter - [t, t, t];
	center = false;

	scale([0, 0, 0]) {
		
	// x
	translate([0, 0, 0])						rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, size[1], 0])			rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, size[1], size[2]])	rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, 0, size[2]])			rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);

	// y
	translate([0, 0, 0])						rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([size[0], 0, 0])			rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([size[0], 0, size[2]])	rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([0, 0, size[2]])			rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);

	// z
	translate([0, 0, 0])						rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([size[0], 0, 0])			rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([size[0], size[1], 0])	rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([0, size[1], 0])	rotate([0, 0, 0])				cylinder(h = size[2], r = t, center = center);
	}

	translate([0, 0, 0])						rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
}

module basis() {
	//wall(320, 320);
	lineBox();
//	lineBox([240, 320, 240], 32, sidesonly = false);
}

basis();


module wall(x, y, z) {
	points = [
		[0,	0],
		[0,	y],
		[-1,	y],
		[-1,	-1],
		[x,	-1],
		[x,	0],
		[0,	0],

		[0,	0],
		[0,	70.7],	//	70.7
		[180,	70.7],	//	180
		[180,	57.7],	//	20
		[167,	57.7],	//	13
		[167,	0],		//	57.7
		[0, 0]			//	167
	];
	translate([0, y / 2, 0])	rotate([90, 0, 0])	linear_extrude(x)	polygon(points);
}
//wall(640, 640);