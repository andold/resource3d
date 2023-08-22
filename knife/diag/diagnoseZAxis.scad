use <MCAD/boxes.scad>

// Z축 곧게 출력하는지 확인
module diagnoseZAxis() {
	$fn = 1024;
	thick = 2;
	difference() {
		cylinder(235, 64, 64);
		translate([0, 0, -1])	cylinder(237, 64 - thick, 64 - thick);
	}
	translate([-64 + thick, 0, 0])	cube([128 - thick, thick, 235]);
}
diagnoseZAxis();
