include	<../../common/constants.scad>
use <../../common/utils.scad>

//	벽 모델링 자료
module wall(x, y, z) {
	translate([0, -y / 2, 0]) {
		cube([167, y, 57.7]);
		note(167, y, 57.7);
		
	}
	translate([0, -y / 2, 57.7]) {
		cube([180, y, 13]);
		note(180, y, 13);
	}
	translate([-EPSILON, -y / 2, 0])	cube([EPSILON, y, z]);
}

module samples() {
	wall(128, 128, 128);
}
samples();