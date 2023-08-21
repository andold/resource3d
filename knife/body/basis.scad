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
	%translate([bodySize[0] + thick + margin, bodySize[1] + thick + margin, thick])
		rotate([0, 0, 180])
		assempleBody(paramBody[0], paramBody[1], paramBody[2], paramBody[3], paramBody[4], paramBody[5], 0);

	echo("basis01 끝: ", param, paramBody);
}

// 본체와의 결합 부위(basis01)를 받치는 기둥들
function basis02translate(param, paramBody) = [
	0,
	-rotate_vector([
		param[4],
		0,
		param[5]
	], [
		basis01Size(param, paramBody)[0] - param[0] / 2,
		param[0] / 2,
		param[0] / 2])[1],
	param[3]
];
module basis02(param, paramBody) {
	echo("basis02 처음: ", param, paramBody);

	bodySize = bodySize(paramBody[0], paramBody[1], paramBody[2]);
	basis01Size = basis01Size(param, paramBody);

	thick = param[0] * 2;
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

	rpoints = [for (cx = [0:len(points) - 1])	rotate_vector([anglex, 0, anglez], points[cx])];
	translate([0, -rpoints[1][1], 0]) {
		for (cx = [0:len(rpoints) - 2]) {
			start = [rpoints[cx][0], rpoints[cx][1], rpoints[cx][2] + height];
			end = [rpoints[cx][0], rpoints[cx][1], 0];
			color("blue", 0.8)	line_sphere(start, end, thick);
		}
		color("blue", 0.8) {
			// 밑판 둘레
			line_sphere([
				rpoints[0][0],
				rpoints[0][1],
				rpoints[0][2] + height
			], [
				rpoints[1][0],
				rpoints[1][1],
				rpoints[1][2] + height
			], thick);
			line_sphere([
				rpoints[1][0],
				rpoints[1][1],
				rpoints[1][2] + height
			], [
				rpoints[2][0],
				rpoints[2][1],
				rpoints[2][2] + height
			], thick);
			line_sphere([
				rpoints[2][0],
				rpoints[2][1],
				rpoints[2][2] + height
			], [
				rpoints[3][0],
				rpoints[3][1],
				rpoints[3][2] + height
			], thick);
			line_sphere([
				rpoints[3][0],
				rpoints[3][1],
				rpoints[3][2] + height
			], [
				rpoints[0][0],
				rpoints[0][1],
				rpoints[0][2] + height
			], thick);

			// 앞쪽위로
			line_sphere([
				rpoints[2][0],
				rpoints[2][1],
				rpoints[2][2] + height
			], [
				rpoints[4][0],
				rpoints[4][1],
				rpoints[4][2] + height
			], thick);
			line_sphere([
				rpoints[3][0],
				rpoints[3][1],
				rpoints[3][2] + height
			], [
				rpoints[5][0],
				rpoints[5][1],
				rpoints[5][2] + height
			], thick);
			
			//	위쪽 앞
			line_sphere([
				rpoints[4][0],
				rpoints[4][1],
				rpoints[4][2] + height
			], [
				rpoints[5][0],
				rpoints[5][1],
				rpoints[5][2] + height
			], thick);

			line_sphere([
				rpoints[4][0],
				rpoints[4][1],
				rpoints[2][2] + height
			], [
				rpoints[1][0],
				rpoints[1][1],
				rpoints[2][2] + height
			], thick);
			line_sphere([
				rpoints[1][0],
				rpoints[1][1],
				rpoints[2][2] + height
			], [
				rpoints[0][0],
				rpoints[0][1],
				rpoints[2][2] + height
			], thick);
			line_sphere([
				rpoints[0][0],
				rpoints[0][1],
				rpoints[2][2] + height
			], [
				rpoints[5][0],
				rpoints[5][1],
				rpoints[2][2] + height
			], thick);
			line_sphere([
				rpoints[5][0],
				rpoints[5][1],
				rpoints[2][2] + height
			], [
				rpoints[4][0],
				rpoints[4][1],
				rpoints[2][2] + height
			], thick);
		}
	}
	
	echo("basis02 끝: ", param, paramBody);
}
module basis(param, paramBody) {
	echo("basis start: ", param, paramBody);

	bodySize = bodySize(paramBody[0], paramBody[1], paramBody[2]);

	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];
	anglex = param[4];
	anglez = param[5];

	color("Pink", 0.5)
		translate(basis02translate(param, paramBody))
		rotate([anglex, 0, anglez])
//		basis01(param, paramBody);
		%translate([bodySize[0] + thick + margin, bodySize[1] + thick + margin, thick])
			rotate([0, 0, 180])
			assempleBody(paramBody[0], paramBody[1], paramBody[2], paramBody[3], paramBody[4], paramBody[5], 0);

	basis02(param, paramBody);


	echo("basis ...ing: ", bodySize=bodySize);
	full = [240, 128, bodySize[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	*rotate([0, 0, 90])	color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);

	echo("basis done: ", param, paramBody);
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
target = 3;
param = [
	4,		//	thick = 4;
	1,		//	margin = 1;		//	하층판 결합부위 여유 공간
	bodySize(paramBody[0], paramBody[1], paramBody[2])[2],		//	overlap = 32;	//	하층판과 기초판이 겹치는 길이
	128,	//	height = 128;	//	기초판의 높이
	-30,	//	anglex = -30;	//	앞으로 기울어지는 정도
	-45,	//	anglez = -30;	//	옆으로 돌아가는 정도
	0,		//	reserved
];

build(target, prototype, param, paramBody);