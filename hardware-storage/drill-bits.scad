use <MCAD/boxes.scad>

include	<../common/constants.scad>
use <../common/library.scad>
use <../common/library_cube.scad>

// 상수
EPSILLON = 0.01;
MARGIN = [4, 4, 4];
A0 = [1189, 841];
A1 = [A0.y, floor(A0.x / 2)];
A2 = [A1.y, floor(A1.x / 2)];
A3 = [A2.y, floor(A2.x / 2)];
A4 = [A3.y, floor(A3.x / 2)];
A5 = [A4.y, floor(A4.x / 2)];
A6 = [A5.y, floor(A5.x / 2)];
A7 = [A6.y, floor(A6.x / 2)];
A8 = [A7.y, floor(A7.x / 2)];
DRILL_BITS = [7.5, 15];

module basis(v, h) {
	cube([v.x, v.y, h]);
}

module drill_bits(r, h) {
	cylinder(h, r, r);
}

module build(target, step) {
	difference() {
		basis(A8, DRILL_BITS[1] + MARGIN.z);
		for (cy =[MARGIN.y + DRILL_BITS[0] / 2: DRILL_BITS[0] + MARGIN.y : A8.y - MARGIN.y - DRILL_BITS[0] / 2]) {
			for (cx =[MARGIN.x + DRILL_BITS[0] / 2: DRILL_BITS[0] + MARGIN.x : A8.x - MARGIN.x - DRILL_BITS[0] / 2]) {
				translate([cx, cy, MARGIN.z + EPSILLON]) {
					drill_bits(DRILL_BITS[0] / 2, DRILL_BITS[1]);
				}
			}
		}
	}
}

target = 7;
build(target, $t);
