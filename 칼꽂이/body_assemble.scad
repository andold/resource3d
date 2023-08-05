use <top-plate.scad>
use <utils.scad>

ZERO = [0, 0, 0];
ONE = [1, 1, 1];

// 몸통
THICK = 4;
module board(x, y, z, even = false) {
	difference() {
		union() {
			cube([x, y, z]);
			for (cy = [(even ? z : z * 2):z * 2:y - z]) {
				translate([z / 2, cy, z])	cube([z * 2, z, z]);
			}
			for (cy = [(even ? z : z * 2):z * 2:y - z]) {
				translate([x - z * 2, cy, z])	cube([z * 2, z, z]);
			}
		}
		translate([-1024 + z / 2, -1, z / 2])	cube(1024);
		translate([x - z / 2, -1, z / 2])	cube(1024);
		scale(ONE)
		for (cy=[z * 3:z * 3:(y - z * 5) / 2]) {
			for (cx=[z * 3:z * 3:(x - z * 5) / 2]) {
				translate([cx,					cy,				-1])	cube(z * 2);
				translate([x - z * 2 - cx,	cy,				-1])	cube(z * 2);
				translate([cx,					y - z * 2 - cy,	-1])	cube(z * 2);
				translate([x - z * 2 - cx,	y - z * 2 - cy,	-1])	cube(z * 2);
			}
		}
	}
}
function bodyAssembleSize()  = [topPlateSize()[0] + THICK * 2, topPlateSize()[1] + THICK * 2, 240];
module body_assemble() {
	base = bodyAssembleSize();
	board(base[0] + THICK, base[2], THICK, false);
	translate([0, base[2] + 8, 0])	board(base[1], base[2], THICK, true);
}

//body_assemble();

module quater() {
	origin = bodyAssembleSize();
	base = [origin[0], origin[1], origin[2] / 4];
	board(base[0] + THICK, base[2], THICK, false);
	translate([0, base[2] + 8, 0])	board(base[1], base[2], THICK, true);
}
quater();

