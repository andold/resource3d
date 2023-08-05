use <top-plate.scad>
use <utils.scad>

// 몸통
function bodySize()  = [topPlateSize()[0] + 2, topPlateSize()[1] + 2, 240];
module body() {
	base = bodySize();
	if (base[2] < 235)	echo("................. ERROR ............ 너무 낮아서 칼이 들어가질 않아요 ........................................................................");

	s = [base[0] + 4, base[1] + 4, base[2]];
	translate([base[1], 0, 0])		rotate([0, 0, 90]) {
		difference() {
			sides(s, 4);
			translate([3, 3, base[2] - 2])	topPlate();
		}
	}
}

module sides(base, t = 4, delta = 64, degree = 30) {
	translate([base[0],	0,					base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);
	translate([base[0],	base[1] - t,	base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);

	translate([0,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
	translate([base[0] - t,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
}

module side(base, delta = 64, degree = 30) {
	inner = [base[0] - base[2] * 2, base[1] - base[2] * 2, base[2] + 2];
	stick = [1024, base[2], base[2]];
	difference() {
		cube(base);
		translate([base[2], base[2], -1])
			cube(inner);
	}
	intersection() {
		cube(base);
		for (dx=[-base[0] * 2:delta:base[0] * 2]) {
			translate([dx, 0, 0])			rotate([0, 0, degree])	cube(stick);
			translate([dx, base[1], 0])			rotate([0, 0, -degree])	cube(stick);
		}
	}
}

// rotate([0, 0, 90])		body();
