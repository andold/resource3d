use <MCAD/boxes.scad>

BIG = [1024, 1024, 1024];
EPSILON = 0.01;

module note(x, y, z, centered = false, fontSize = 1) {
	mm = " mm";	//	"㎜";
	center = centered ? [-x / 2, -y / 2, -z / 2] : [0, 0, 0];
	%color("Black")
	translate(center)
	{
		// x, z view
		translate([x / 2, y - fontSize * 1.5, z + EPSILON])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");
		translate([x / 2, fontSize * 1.5, z + EPSILON])
			rotate([0, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");

		// x, -z view
		translate([x / 2, y - fontSize * 0.5, -EPSILON])
			rotate([180, 0, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");
		translate([x / 2, fontSize * 0.5, -EPSILON])
			rotate([180, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");

		// x, y view
		translate([x / 2, y + EPSILON, z - fontSize * 1.5])
			rotate([90, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");
		translate([x / 2, y + EPSILON, fontSize * 1.5])
			rotate([90, 180, 180])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");

		// x, -y view
		translate([x / 2, -EPSILON, z - fontSize * 1.5])
			rotate([90, 0, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");
		translate([x / 2, -EPSILON, fontSize * 1.5])
			rotate([90, 180, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = fontSize, halign = "center");

		// y, z view
		translate([fontSize * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, 90])
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = fontSize, halign = "center");
		translate([x - fontSize * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, -90])
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = fontSize, halign = "center");

		// z, -y view
		translate([fontSize * 1.5, -EPSILON, z / 2])
			rotate([90, -90, 0])
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = fontSize, halign = "center");
		translate([x - fontSize * 1.5, -EPSILON, z / 2])
			rotate([90, 90, 0])
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = fontSize, halign = "center");
	}
}
size = [64, 32, 8]; cube(size); note(size[0], size[1], size[2], fontSize = 1);

module boardPattern(size = [128, 64, 4], degree = 60, stick = [THICK, THICK, 32]) {
	intersection() {
		cube([size[0], size[1], stick[1]]);
		for (dx = [-1024: stick[2]: 1024]) {
			translate([dx, -cos(degree) * stick[1], -1])	rotate([0, 0, degree])	cube([1024, stick[0], stick[1]]);
			mirror([1, 0, 0])
			translate([dx, -cos(degree) * stick[1], -1])	rotate([0, 0, degree])	cube([1024, stick[0], stick[1]]);
		}
	}
}
module mark(name, height, size = 2) {
	linear_extrude(height, center = false)	text(name, size = size);
}
module hole(w, h, z) {
	translate([w / 2, h / 2, z / 2])		roundedBox(size=[w, h, z], radius = w / 4, sidesonly = true);
}
module ellipsis(w = 32, h = 16, z = 4) {
	translate([w / 2, h / 2, 0])
		resize([w, h, z])
			cylinder(1024, 1024, 1024);
}
module cornerHole(base, m, in, out, height) {
	delta = (out - in) / 2;
		translate([m,					m,					0])	ellipsis(in, in);
		translate([base[0] - m,	m,					0])	ellipsis(in, in);
		translate([base[0] - m,	base[1] - m,		0])	ellipsis(in, in);
		translate([m,					base[1] - m,		0])	ellipsis(in, in);

		translate([m - delta,					m - delta,					height])	ellipsis(out, out);
		translate([base[0] - m  - delta,	m - delta,					height])	ellipsis(out, out);
		translate([base[0] - m  - delta,	base[1] - m - delta,	height])	ellipsis(out, out);
		translate([m - delta,					base[1] - m - delta,	height])	ellipsis(out, out);
}
module lineBox(outter = [100, 100, 100], t = 2) {
	size = outter - [t*2, t*2, t*2];
	center = false;

	translate([t, t, t])	{
		
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
}
module hide(show = 0) {
	if (show > 0) children();
	else scale([0, 0, 0])	children();
}

module t() {
	c = [0.5, 0.5, 0.5, 0.5];
	d = [0.5, 0.5, 0.0, 0.5];
	
	color(c)	difference() {
		cube([4, 16, 2]);
		translate([2, -2, -1])	cube([4, 4, 4]);
	}
	color(d)	translate([8, 0, 0])	cube([16, 4, 2]);
}
