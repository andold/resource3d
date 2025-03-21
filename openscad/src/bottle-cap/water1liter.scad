// water1liter.scad
include <../openscad/libraries/BOSL/constants.scad>
use <../openscad/libraries/BOSL/threading.scad>

include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/library_trimmer.scad>

MEASURE = [
//	52,		//	1. 외경 1 - 최소 지름
	53 + 1,		//	7. 외경 1 - 최소 지름, 병뚜껑에서 잰 거+
	55 + 1,		//	2. 외경 2 - 나사선을 포함한 지름+
	2.2,	//	3. 나사선의 두께
	6.6,	//	4. 나사선간의 간격 - 2개의 나사선의 외경
	60,		//	5. 외경 3 - 두껑이 더이상 진행하지 못하게 하는 막는 부분의 지름
	16,		//	6. 최상에서 외경 3까지의 거리 - 뚜껑의 깊이

	0		//	reserved
];

DEFINE = [
	3,	//	두께
	4,	//	나사선이 아예 없는 부분
	0	//	reserved
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
				cylinder(t + t, r + t, r, $fn = fnRound(r));
		}

		let(
			r = MEASURE[0] / 2,
			h = z - t,

			reserved = 0
		) {
			translate([0, 0, t])
				cylinder(h + EPSILON, r, r, $fn = fnRound(r));
			translate([0, 0, NOZZLE + 0.4 / 2]) rotate([180, 0, 0])
				linear_extrude(0.4, center = true, slices = $preview ? 20 : 16 * 4)	text("andold", size = 4, halign = "center", $fn = fnRound(r));
		}
		conchoid();
	}
}
module conchoid() {
	t = DEFINE[0];
	x1 = MEASURE[0];
	x2 = MEASURE[1];
	dx = x2 - x1;
	h = MEASURE[5];
	h1 = DEFINE[1];
	p = MEASURE[3] - MEASURE[2];

	translate([0, 0, t]) {
		//	나사선
		acme_threaded_rod(d=x2, thread_depth = dx, thread_angle=30, l = h - h1, pitch = p, $fn = fnRound(x2), orient=ORIENT_Z, align=V_ABOVE);

		//	나사선이 아예 없는 부분
		let(
			r = x2 / 2,

			reserved = 0
		) {
			translate([0, 0, h - h1])
				cylinder(h1, r, r, $fn = fnRound(r));
		}
	}

	*projection(cut=true)
	acme_threaded_rod(d=x2, thread_depth = dx, thread_angle=30, l = h, pitch = p, $fn = fnRound(x2), orient=ORIENT_X, align=V_CENTER);
}
module cap_assemble() {
	cap();
//	conchoid();
}

cap_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\bottle-cap\water1liter#41.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\bottle-cap\water1liter.scad
*/
