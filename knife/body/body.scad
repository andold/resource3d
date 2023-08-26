use <MCAD/boxes.scad>
include <../../common/constants.scad>
use <../top/landscape.scad>
use <../../common/library.scad>
use <../../common/utils.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.2;

// 주요 상수
HEIGHT = 210;
HEIGHT_TOP = 210;
OVERLAP = 0;
OPACITY = 0.75;

module joint_male(r1, z) {
	r2 = min(r1 * 0.95, r1 - MINIMUM);
	x1 = r1 * 1.5;
	x2 = min(x1 * 0.95, x1 - MINIMUM);
	translate([r1, r1, 0])	cylinder(z, r1, r2);
	translate([(x1 - r1) / 2, 0, 0])	cube_type_1([x1, r1, z], x2);
}
module joint_males(r, z, x, count) {
	dx = (x - r * 2) / (count - 1);
	assert(dx > r * 2);
	for (cx = [0: dx: x]) {
		translate([cx, 0, 0])	joint_male(r, z);
	}
}

module joint_female(r, z) {
	preview = $preview ? EPSILON : 0;

	translate([r * 2 + z, 0, z])
	rotate([0, 180, 0])
	difference() {
		cube([r * 2 + z * 2, r * 2 + z, z]);
		translate([z, 0, -preview])	joint_male(r, z + preview * 2);
	}
}
module joint_females(r, z, x, count) {
	dx = (x - r * 2) / (count - 1);
	assert(dx > r * 2);
	for (cx = [0: dx: x]) {
		echo(r, z, x, count, dx, cx);
		translate([cx, 0, 0])	joint_female(r, z);
	}
}
function topSize(param) = landscapeSize(param[0], param[1], param[2]);
// 외경
function bodySize(param, paramTop)  = [
	topSize(paramTop)[0] + param[0] * 2,
	topSize(paramTop)[1] + param[0] * 2,
	HEIGHT_TOP
];

module bodyFront(param, paramTop) {
//	echo("bodyFront start: ", param, paramTop);

	thick = param[0];
	marginy = param[1];
	paddingx = param[2];
	paddingy = param[3];

	base = bodySize(param, paramTop);
	BIG = big(base);

	difference() {
		r = 8;
		dy = paddingy + thick + r;
		union() {
			//	윤곽
			cube([base[0], HEIGHT, thick]);
			note(base[0], HEIGHT, thick);
			
			//	상판 지지대
			translate([thick, marginy, thick])
				difference() {
					rotate([0, 90, 0])	cylinder(base[0] - thick * 2, thick, thick);
					translate([-BIG[0] / 2, -BIG[1], -BIG[2] / 2])	cube(BIG);
				}
			translate([thick, HEIGHT - marginy, thick])
				difference() {
					rotate([0, 90, 0])	cylinder(base[0] - thick * 2, thick, thick);
					translate([-BIG[0] / 2, 0, -BIG[2] / 2])	cube(BIG);
				}

			//	조립 부속
			translate([thick / 2 * 3, HEIGHT - dy, thick])
				rotate([90, 0, -90])
				joint_males(r, thick, HEIGHT - dy * 2, 5);
			translate([base[0] - thick / 2 * 3, dy, thick])
				rotate([90, 0, 90])
				joint_males(r, thick, HEIGHT - dy * 2, 5);
		}
		
		//	body side 결합 경계
		translate([-BIG[0] + thick / 2, -BIG[1] / 2, thick / 2])	cube(BIG);
		translate([base[0] - thick / 2, -BIG[1] / 2, thick / 2])	cube(BIG);
		
		wx = base[0] - (thick * 6);
		wy = HEIGHT - dy * 2;
		translate([(thick * 6) / 2, dy, 0])
			windows(wx, wy, thick, 4, 4, 4, 2);
	}
//	echo("bodyFront done: ", param, paramTop);
}

// 조립시 안쪽
module bodySide(param, paramTop, step = 0) {
//	echo("bodySide start: ", param, paramTop);

	thick = param[0];
	marginy = param[1];
	paddingx = param[2];
	paddingy = param[3];

	bodySize = bodySize(param, paramTop);
	base = bodySize - [0, thick, 0];

	difference() {
		r = 8;
		dy = marginy;
		union() {
			cube([base[1], HEIGHT, thick]);
			note(base[1], HEIGHT, thick);

			x = r * 2.5;
			translate([thick / 2, dy, thick])
				cube([x, HEIGHT - dy * 2, thick / 2]);
			translate([base[1] - x - thick / 2, dy, thick])
				cube([x, HEIGHT - dy * 2, thick / 2]);
		}

		translate([-thick / 2, 0, base[0]])
			rotate([0, 90, 0])
			bodyFront(param, paramTop);
		translate([base[1] + thick / 2, 0, 0])
			rotate([0, -90, 0])
			bodyFront(param, paramTop);

		wx = base[1] - (thick + r * 5);
		wy = HEIGHT - dy * 2;
		translate([(thick + r * 5) / 2, dy, 0])
			windows(wx, wy, thick, 4, 4, 1, 2);
	}

//	echo("bodySide done: ", param, paramTop);
}


module bodyPrototype(param, paramTop) {
	thick = param[0];
	base = bodySize(param, paramTop);
	
	cube([base[0], thick, HEIGHT]);
	note(base[0], thick, HEIGHT);
	translate([0, base[1] - thick, 0])
		cube([base[0], thick, HEIGHT]);
	translate([0, 0, 0]) {
		cube([thick, base[1], HEIGHT]);
		note(thick, base[1], HEIGHT);
	}
	translate([base[0]- thick, 0, 0])
		cube([thick, base[1], HEIGHT]);
}
//bodyPrototype(param, paramTop);

module assempleBody(param, paramTop, help = 8) {
	echo("assempleBody 처음: ", param, paramTop, help);

	thick = param[0];
	marginy = param[1];
	paddingx = param[2];
	paddingy = param[3];

	base = topSize(paramTop);

	//	앞판
	translate([help, 0, HEIGHT])
		rotate([-90, 0, 0])
		bodyFront(param, paramTop);
	translate([base[0] + thick * 2 + help, base[1] + thick * 2 + help, HEIGHT - thick * 2])
		rotate([0, 0, 180])
		translate([0, 0, base[2]])
		rotate([-90, 0, 0])
		bodyFront(param, paramTop);

	//	옆판
	translate([base[0] + thick, base[1] + thick * 2, -thick])
		rotate([0, 0, 180])
		translate([base[0] + thick, thick / 2, HEIGHT + base[2] - thick])
		rotate([-90, 0, 90])
		bodySide(param, paramTop);
	translate([base[0] + thick * 2 + help * 2, thick / 2, HEIGHT + base[2] - thick * 2])
		rotate([-90, 0, 90])
		bodySide(param, paramTop);

	if ($preview) {
		%translate([thick + help, thick, HEIGHT - thick * 1.5])
			landscape(paramTop[0], paramTop[1], paramTop[2]);
	}

	echo("assempleBody 끝: ", param, paramTop, help);
}

module build(target = 1, renderMode = false, step = 0) {
	echo("build body 처음: ", target, renderMode, step);

	paramTop = [
		8,	//	thick = 8;	//	상판의 두께
		12,	//	margin = 8;	//	상판의 가장자리 여유 거리
		8,	//	delta = 8;	//	상판의 구멍 표준 간격
		0	//	reserved
	];
	param = [
		4,	//	thick = 4;	//	두께
		10,	//	marginy = 12;
		24,	//	paddingx = 24;
		12,	//	paddingy = 12;
		0	//	reserved
	];

	thick = paramTop[0];
	margin = paramTop[1];
	delta = paramTop[2];

	echo("상판: ", topSize(paramTop));
	echo("몸체: ", bodySize(param, paramTop));

	if (renderMode) {
		$fn = 256;
	}

	if (target == 1) {
		bodyFront(param, paramTop);
	} else if (target == 2) {
		bodySide(param, paramTop, step);
	} else if (target == 3) {
		bodyFront(param, paramTop);
		translate([topSize(paramTop)[0] + 8 - 8 * step, 0, thick / 2])
			rotate([0, -90, 0])
			bodySide(param, paramTop);
	} else if (target == 4) {
		bodyFront(param, paramTop);
		translate([bodySize(param, paramTop)[0] + 4, 0, 0])
			bodySide(param, paramTop);
	} else if (target == 5) {
		assempleBody(param, paramTop, 0);
	} else if (target == 6) {
		joint_males(8, 4, 200, 5);
	} else {
		bodyPrototype(param, paramTop);
	}

	echo("build body 끝: ", target, renderMode, step);
}

renderMode = false;
target = 0;
build(target, renderMode, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o stl\body-front-#24.stl -D target=1 -D renderMode=true knife\body\body.scad
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o stl\body-side-#24.stl -D target=2 -D renderMode=true knife\body\body.scad
*/