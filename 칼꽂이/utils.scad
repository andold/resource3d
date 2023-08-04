use <MCAD/boxes.scad>

module mark(name, height, size = 2) {
	linear_extrude(height, center = false)	text(name, size = size);
}
module hole(w, h) {
	translate([w / 2, h / 2, 0])		roundedBox(size=[w, h, 1024], radius = w / 4, sidesonly = true);
}
module ellipsis(w, h) {
	translate([w / 2, h / 2, 0])
		resize([w, h, 1024])
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
