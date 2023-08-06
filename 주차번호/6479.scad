module mark(name, height, size = 2) {
	linear_extrude(height, center = true)	text(name, size = size);
}
//mark("010-6810-6479", 1);
module lines2(first, second, height, size = 1) {
	cube([size * 7.5, size * 3, height / 3]);
	for (dx = [0:0.01:0.1]) {
		translate([size / 2 + dx, size * 0.6, 0])	{
			color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
			color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
		}
	}
	translate([size / 2, size * 0.6, 0])	{
		color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
		color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
	}
	translate([size / 2 + 0.05, size * 0.6, 0])	{
		color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
		color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
	}
}

module andold() {
	base = [8, 3, 1];
	lines2("010", "6810-6479", 1);
}
andold();