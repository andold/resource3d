use <MCAD/boxes.scad>
use <wall.scad>
use <body.scad>

// 상수
ZERO = [0, 0, 0];
ONE = [1, 1, 1];
EPSILON = 0.01;

module sides(base, t = 4, delta = 64, degree = 30) {
	translate([base[0],	0,					base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);
	translate([base[0],	base[1] - t,	base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);

	translate([0,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
	translate([base[0] - t,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
}

module side(base, thick, margin, delta, degree = 30) {
	inner = [base[0] - base[2] * 2, base[1] - base[2] * 2, base[2] + 2];
	stick = [1024, base[2], base[2]];
	difference() {
		cube(base);
		translate([base[2], base[2], -1])
			cube(inner);
	}
	intersection() {
		cube(base);
		for (dx=[-base[0] * 2:delta:base[0] * 2]) {
			translate([dx, 0, 0])			rotate([0, 0, degree])	cube(stick);
			translate([dx, base[1], 0])			rotate([0, 0, -degree])	cube(stick);
		}
	}
}
module body(thick, margin, delta) {
	echo("body start: ", thick, margin, delta);

	base = bodySize(thick, margin, delta);
	echo("body ...ing: ", base);
	
	echo("done start: ", thick, margin, delta);
}

module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
}

// 지지대 모델링 자료
module buttress(x, y, z) {
	points = [
		[0,	70.7],	//	70.7
		[0,	z],		//	dy
		[x,	z],		//	x
		[x,	0],		// y
		[167,	0],		// 167
		[167,	57.7]	,	// 57.7
		[180,	57.7],	// 13
		[180,	70.7],	// 20
		[180,	70.7],	// 20
		[0,	70.7]	//	70.7
	];
	translate([0, y, 0])	rotate([90, 0, 0])	linear_extrude(y)	polygon(points);
}
module basis(thick, margin, delta, marginy, paddingx, paddingy) {
	echo("basis start: ", thick, margin, delta);

	translate([512, 0, 0])
		rotate([30, 0, 0])
		//assempleBody(thick, margin, delta, marginy, paddingx, paddingy, 0);
		cube(0);

	bodySize = bodySize(thick, margin, delta);	//	높이는 230mm 이상이어야 한다.
	echo("basis ...ing: ", bodySize=bodySize);
	full = [240, 128, bodySize[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	//color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);

CONSTANT01 = 64;	//	하층판과 기초판이 겹치는 길이
CONSTANT02 = 1;		//	하층판 결합부위 여유 공간
CONSTANT03 = 180;	//	기초판의 높이
CONSTANT04 = -45;	//	기울기
	//	하층판과 기초판의 결합부위(이하 물체1)
	outter = [
		bodySize[0] + thick * 2 + CONSTANT02,
		bodySize[1] + thick * 2 + CONSTANT02,
		CONSTANT01
	];
	inner = [
		bodySize[0] - CONSTANT02,
		bodySize[1] - CONSTANT02,
		CONSTANT01
	];
	inner2 = [
		bodySize[0] - CONSTANT02 - thick * 2,
		bodySize[1] - CONSTANT02 - thick * 2,
		CONSTANT01
	];
	color("blue", 0.5)
		translate([0, 0, CONSTANT03])
		rotate([CONSTANT04, 0, 0])
		difference() {
			cube(outter);
			translate([thick + CONSTANT02 / 2, thick + CONSTANT02 / 2, thick])
				cube(inner);
			translate([thick * 2 + CONSTANT02 / 2, thick * 2 + CONSTANT02 / 2, -thick])
				cube(inner2);
		}

	// 물체1을 받치는 기둥들
//	color("Red", 0.8)
	{
		translate([
			0,
			thick + CONSTANT01 - CONSTANT01 * sin(CONSTANT04)+ CONSTANT03,
			0
		])
			cube([
				thick,
				thick,
				CONSTANT03 - CONSTANT01 * cos(CONSTANT04)
			]);
		translate([bodySize[0] + thick + CONSTANT02, thick + CONSTANT01-CONSTANT01 * sin(CONSTANT04), 0])
			cube([thick, thick, CONSTANT03 - CONSTANT01 * cos(CONSTANT04)]);
		translate([0, 0, 0])
			cube([thick, thick, CONSTANT03]);
		translate([bodySize[0] + thick + CONSTANT02, 0, 0])
			cube([thick, thick, CONSTANT03]);
	}
	// 기둥들의 지지대
	translate([0, 0, CONSTANT03 - CONSTANT01 * cos(CONSTANT04)])
	difference() {
		cube([
			bodySize[0] + thick * 2 + CONSTANT02,
			thick * 2 + CONSTANT01-CONSTANT01 * sin(CONSTANT04) + CONSTANT02,
			thick
		]);
		translate([thick + CONSTANT02 / 2, thick + CONSTANT02 / 2, -EPSILON])
			cube([bodySize[0] + CONSTANT02, CONSTANT01-CONSTANT01 * sin(CONSTANT04) + CONSTANT02, thick * 2]);
	}
	difference() {
		cube([
			bodySize[0] + thick * 2 + CONSTANT02,
			thick * 2 + CONSTANT01-CONSTANT01 * sin(CONSTANT04) + CONSTANT02,
			thick
		]);
		translate([thick + CONSTANT02 / 2, thick + CONSTANT02 / 2, -EPSILON])
			cube([bodySize[0] + CONSTANT02, CONSTANT01-CONSTANT01 * sin(CONSTANT04) + CONSTANT02, thick * 2]);
	}

	// 본체
	translate([0, 0, CONSTANT03])
		rotate([CONSTANT04, 0, 0])
		translate([thick, thick, thick])
		color([0.8, 0.8, 0.0, 0.8])
		assempleBody(thick, margin, delta, marginy, paddingx, paddingy, 0);
		cube(0);
	rotate([0, 0, 90])	color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);

	//color([0.8, 0.0, 0.8, 0.5])	lineBox(full, 1);	//	점유 영역?
	translate(nature)
		color("Red", 0.5)
		//buttress(full[0], full[1], full[2]);	//	지지대
		cube(0);

	echo("basis done: ", thick, margin, delta);
}

prototype = true;
target = 8;
thick = 8;
margin = 8;
delta = 8;
marginy = 12;
paddingx = 24;
paddingy = 12;
basis(thick, margin, delta, marginy, paddingx, paddingy);
