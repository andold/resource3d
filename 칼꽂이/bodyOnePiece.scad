use <MCAD/boxes.scad>
use <landscape.scad>
use <utils.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];

// 주요 상수
THICK = 4;
HEIGHT = 240;
OPACITY = 0.75;

function bodyOnePieceSize()  = [landscapeSize()[0] + THICK, landscapeSize()[1] + THICK, HEIGHT];

module board(size, degree) {
	{
		for (dx = [-size[0]: size[2] / sin(degree) * 4: size[0] * 2]) {
			translate([dx, 0, -1])	rotate([0, 0, degree])	cube([1024, size[2], size[2] + 2]);
		}
		for (dx = [-size[1]: size[2] / cos(degree) * 4: size[1] * 2]) {
			translate([0, dx, -1])	rotate([0, 0,  - degree])	cube([1024, size[2], size[2] + 2]);
		}
		//cube(size);
	}
}
module boards(size, degree) {
	board([size[0], size[2], THICK], degree);
}

module pillar(size, radius) {
	translate([radius,				radius,				0])	cylinder(size[2], radius, radius);
	translate([size[0] - radius,	radius, 0])	cylinder(size[2], radius, radius);
	translate([size[0] - radius,	size[1] - radius, 0])	cylinder(size[2], radius, radius);
	translate([radius,				size[1] - radius, 0])	cylinder(size[2], radius, radius);

	translate([size[0] / 2, radius, 0])	cylinder(size[2], radius, radius);
	translate([size[0] / 2, size[1] - radius, 0])	cylinder(size[2], radius, radius);
}
module main() {
	size = bodyOnePieceSize();
	scale(ZERO) {
		cube(size - [0, 0, size[2] - THICK]);
		translate([0, 0, size[2] - THICK * 2])	cube(size - [0, 0, size[2] - THICK]);
		pillar(size, THICK);
	}
	
	boards(size, 75);
}

main();
