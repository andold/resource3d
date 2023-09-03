include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/metric_screws.scad>

include	<../../common/constants.scad>

module diagnose_degree(w, upto) {
	difference() {
		cube([w * 2, w, w * 2]);
		translate([0, w + 1, w])	rotate([90, 0, 0])	cylinder(w  + 2, w, w);
		translate([-1 , -1, w + w * sin(upto)])	cube(1024);
	}
	//translate([0, 0, 0])	cube([w * 2, w, w]);
}

module sample(target, step) {
	bolt_size = 4;

	if (target == 1) {
		echo("75도까지 오버행 테스트트");
		diagnose_degree(16, 75);
	} else if (target == 2) {
		echo("볼트 4mm");
		rotate([180, 0, 0])
			metric_bolt(headtype="countersunk", size=bolt_size, l=16, shank=8, details=true, phillips="#2", $fn = $preview ? 16 : 360);
	} else if (target == 3) {
		echo("너트 4mm");
		metric_nut(size=bolt_size, hole=true, pitch=1.5, details=true, $fn = $preview ? 16 : 360);
	} else if (target == 4) {
		nut_radius = 3.2 /2;
		nut_height = 25;
		rotate([0, 90, 0])
		difference() {
			cylinder(nut_height * 2, 4, 4, $fn = $preview ? 16 : 360);
			translate([0, 0, -EPSILON])
			cylinder(nut_height, nut_radius, nut_radius, $fn = $preview ? 16 : 360);
		}
	} else if (target == 5) {
	} else if (target == 6) {
	} else if (target == 7) {
	} else {
		diagnose_degree(16, 75);
	}
}

target = 4;
sample(target, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\diagnose_degree75.stl -D target=1	C:\src\eclipse-workspace\resource3d\knife\diag\diagnose.scad
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\metric_bolt4.stl -D target=2		C:\src\eclipse-workspace\resource3d\knife\diag\diagnose.scad
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\metric_nut4.stl -D target=3		C:\src\eclipse-workspace\resource3d\knife\diag\diagnose.scad
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\nut3225.stl -D		target=4	C:\src\eclipse-workspace\resource3d\knife\diag\diagnose.scad
*/