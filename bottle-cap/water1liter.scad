// water1liter.scad
include <BOSL/constants.scad>
use <BOSL/threading.scad>

include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/library_trimmer.scad>

MEASURE = [
	52,
	54,
	2.4,
	6.7,
	59,
	18,
	0		//	reserved
];

DEFINE = [
	3,	//	두께
	0		//	reserved
];

/*
*/
module cap() {
	t = DEFINE[0];
	x = MEASURE[4];
	y = x;
	z = MEASURE[5] + t;

	difference() {
		let(
			r = x / 2,
			h = z,
		
			reserved = 0
		) {
			color("Yellow", 0.5)
			cylinder(h, r, r, $fn = fnRound(r));
		}

		let(
			r = MEASURE[0] / 2,
			h = z - t,

			reserved = 0
		) {
			translate([0, 0, t])
				cylinder(h + EPSILON, r, r, $fn = fnRound(r));
		}
		conchoid();
	}
}
module conchoid1() {
	trapezoidal_threaded_rod(l=250, d=10, pitch=2, thread_angle=15, starts=3, $fa=1, $fs=1, orient=ORIENT_X, align=V_UP);
}
module conchoid() {
	t = DEFINE[0];
	x1 = MEASURE[0];
	x2 = MEASURE[1];
	dx = x2 - x1;
	h = MEASURE[5];

	translate([0, 0, t])
	acme_threaded_rod(d=x2, thread_depth = dx, thread_angle=30, l = h, pitch = MEASURE[3] - MEASURE[2], $fn = fnRound(x2), orient=ORIENT_Z, align=V_ABOVE);

	//projection(cut=true)
	//acme_threaded_rod(d=x2 - EPSILON, thread_depth = dx, thread_angle=30, l=h, pitch=MEASURE[3] - MEASURE[2], $fn=fnRound(x2), orient=ORIENT_X, align=V_CENTER);
}
module cap_assemble() {
	cap();
}

cap_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\water1liter.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\bottle-cap\water1liter.scad
*/
