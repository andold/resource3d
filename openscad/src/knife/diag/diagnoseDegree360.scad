
// size: 외경 radius: 구멍반지름
module diagnoseDegree360(size = [32, 32, 16], radius = 8) {
	difference() {
		cube(size);
		translate([size[0] / 2, size[1] / 2 + radius + 1, size[2] / 2])
		rotate([90, 0, 0])
		cylinder(size[2] + 2, radius, radius);
	}
		//translate([size[0] / 2, size[1] / 2 + radius + 1, size[2] / 2])		rotate([90, 0, 0])		cylinder(size[1] + 2, radius, radius);
}
diagnoseDegree360([32, 16, 32], 12);
