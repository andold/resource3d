use <MCAD/boxes.scad>
use <wall.scad>
use <body.scad>
use <../etc/utils.scad>

// 상수
ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.01;

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

// 본체와의 결합 부위
function basis01Size(param, paramBody) = [
	bodySize(paramBody[0], paramBody[1], paramBody[2])[0] + param[0] * 2 + param[1],
	bodySize(paramBody[0], paramBody[1], paramBody[2])[1] + param[0] * 2 + param[1],
	param[2]
];
module basis01(param, paramBody) {
	echo("basis01 처음: ", param, paramBody);

	bodySize = bodySize(paramBody[0], paramBody[1], paramBody[2]);
	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];

	//	하층판과 기초판의 결합부위(이하 물체1)
	outter = [
		bodySize[0] + thick * 2 + margin,
		bodySize[1] + thick * 2 + margin,
		overlap
	];
	inner = [
		bodySize[0] + margin,
		bodySize[1] + margin,
		overlap
	];
	inner2 = [
		bodySize[0] - margin - paramBody[0] * 2,
		bodySize[1] - margin - paramBody[0] * 2,
		overlap
	];
	difference() {
		cube(outter);
		note(outter[0], outter[1], outter[2], fontSize = 4);
		translate([thick + margin / 2, thick + margin / 2, thick])
			cube(inner);
		translate([thick * 2 + margin / 2, thick * 2 + margin / 2, -thick])
			cube(inner2);
	}
	%translate([thick + margin, thick + margin, thick])
		assempleBody(paramBody[0], paramBody[1], paramBody[2], paramBody[3], paramBody[4], paramBody[5], 0);

	echo("basis01 끝: ", param, paramBody);
}

// 본체와의 결합 부위(basis01)를 받치는 기둥들
module basis02(param, paramBody) {
	echo("basis02 처음: ", param, paramBody);

	bodySize = bodySize(paramBody[0], paramBody[1], paramBody[2]);
	basis01Size = basis01Size(param, paramBody);
	echo(bodySize, basis01Size);
	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];
	anglex = param[4];
	anglez = param[5];

	// before
	points = [
		[thick / 2,						thick / 2,					thick / 2],
		[basis01Size[0] - thick / 2,	thick / 2,					thick / 2],
		[basis01Size[0] - thick / 2,	basis01Size[1] - thick / 2,	thick / 2],
		[thick / 2,						basis01Size[1] - thick / 2,	thick / 2],
	
//		[thick / 2,						thick / 2,					basis01Size[2] - thick / 2],
//		[basis01Size[0] - thick / 2,	thick / 2,					basis01Size[2] - thick / 2],
		[basis01Size[0] - thick / 2,	basis01Size[1] - thick / 2,	basis01Size[2] - thick / 2],
		[thick / 2,						basis01Size[1] - thick / 2,	basis01Size[2] - thick / 2],
		[0,								0,							0]	//	reserved
	];
	
	for (cx = [0:len(points) - 2]) {
		x = points[cx][0];
		y = points[cx][1];
		z = points[cx][2];
		
		rx = x;
		ry = -z * sin(anglex) + y * cos(anglex);
		rz = z * cos(anglex) + y * sin(anglex);
		
		rrx = -ry * sin(anglez) + rx * cos(anglez);
		rry = ry * cos(anglez) + rx * sin(anglez);
		rrz = rz;
		
		echo("회전: ", angle=anglex, cx=cx, str("(", x, ", ", y, ", ", z, ") => (", rx, ", ", ry, ", ", rz, ") => (", rrx, ", ", rry, ", ", rrz, ")"));
		rs = [rx, ry, rz + height];
		re = [rx, ry, 0];
		*color("red", 0.8)	line_sphere(rs, re, thick);
		rrs = [rrx, rry, rrz + height];
		rre = [rrx, rry, 0];
		color("blue", 0.8)	line_sphere(rrs, rre, thick);
	}

	translate([0, 0, height])
	rotate([0, 0, anglez])
	rotate([anglex, 0, 0])
	basis01(param, paramBody);
	
	echo("basis02 끝: ", param, paramBody);
}
module basis(paramBody, thick, overlap, margin, height, angle) {
	echo("basis start: ", thick, margin, delta);

	CONSTANT01 = 64;	//	하층판과 기초판이 겹치는 길이
	CONSTANT02 = 1;		//	하층판 결합부위 여유 공간
	CONSTANT03 = 180;	//	기초판의 높이
	CONSTANT04 = -30;	//	기울기

	color("Pink", 0.5)	basis01(paramBody, thick, CONSTANT01, CONSTANT02, CONSTANT03, CONSTANT04);
	color("Pink", 0.5)	basis02(thick, margin, delta, CONSTANT01, CONSTANT02, CONSTANT03, CONSTANT04);

	bodySize = bodySize(thick, margin, delta);	//	높이는 230mm 이상이어야 한다.
	echo("basis ...ing: ", bodySize=bodySize);
	full = [240, 128, bodySize[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	//color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);
	
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
	#color("Blue", 0.5)
		//rotate([0, 0, -30])
		translate([CONSTANT02 / 2, -CONSTANT02 / 2, CONSTANT03])
		rotate([CONSTANT04, 0, 0])
		translate([thick, thick, thick])
		translate([bodySize[0], bodySize[1], 0])
		rotate([0, 0, 180])
		assempleBody(thick, margin, delta, marginy, paddingx, paddingy, 0);
		cube(0);
	%rotate([0, 0, 90])	color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);


	echo("basis done: ", thick, margin, delta);
}

module build(target, prototype, param, paramBody) {
	echo("build basis start: ", target, prototype, param, paramBody);

	scale = prototype ? HALF : ONE;
	$fn = prototype ? 16 : 128;

	thick = param[0];
	if (target == 1) {
		scale(scale)
			basis01(param, paramBody);
	} else if (target == 2) {
		scale(scale)
			basis02(param, paramBody);
	} else if (target == 3) {
		scale(scale)
			basis(param, paramBody);
	} else {
		*rotate([0, 0, -$t * 360])
			rotate([-30, 0, 0])
			translate([param[0], thick, thick])
			translate([bodySize(paramBody[0], paramBody[1], paramBody[2])[0], bodySize(paramBody[0], paramBody[1], paramBody[2])[1], 0])
			rotate([0, 0, 180])
			assempleBody(paramBody[0], paramBody[1], paramBody[2], paramBody[3], paramBody[4], paramBody[5], 0);
	}

	echo("build basis done: ", target, prototype, param, paramBody);
}

paramBody = [
	4,	//thick
	8,	// margin
	8,	// delta
	12,	// marginy
	24,	// paddingx
	12	// paddingy
];
prototype = true;
target = 2;
param = [
	4,		//	thick = 4;
	1,		//	margin = 1;		//	하층판 결합부위 여유 공간
	bodySize(paramBody[0], paramBody[1], paramBody[2])[2],		//	overlap = 32;	//	하층판과 기초판이 겹치는 길이
	128,	//	height = 128;	//	기초판의 높이
	-30,	//	anglex = -30;	//	앞으로 기울어지는 정도
	-30,	//	anglez = -30;	//	옆으로 돌아가는 정도
	0,		//	reserved
];

build(target, prototype, param, paramBody);