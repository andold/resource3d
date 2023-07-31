module test1() {
	linear_extrude(16, center = false) union() {
		translate([8, 0, 0])	square([32, 24], center = false);
		translate([64, 0, 0])	circle(8);
	}
}
module test2() {
	union() {
		//translate([32, 0, 0])	rotate([0, 0, 30])		square([4, 24], center = false);
		//translate([64, 0, 0])	circle(8);
		//text("010-6810-6479");
		translate([8, 2, 0])	text("010-4240-6479");
	}
}
module testExtrude() {
	color("brown", 0.5)	linear_extrude(6, center = false)	test2();
	color("gray", 0.5)	translate([0, 0, 0])	cube([64 + 32 + 16, 4, 1], center = false);
}
module test() {
	translate([100, 0, 0])	test2();
	rotate_extrude(angle = 360)	test2();
}

//test();
testExtrude();

