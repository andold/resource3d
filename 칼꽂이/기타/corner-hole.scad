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
