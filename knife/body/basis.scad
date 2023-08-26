use <MCAD/boxes.scad>
include	<../../common/constants.scad>
use <wall.scad>
use <body.scad>
use <../etc/utils.scad>

// 상수
PARAM_TOP = [
	8,	//	thick = 8;	//	상판의 두께
	12,	//	margin = 8;	//	상판의 가장자리 여유 거리
	8,	//	delta = 8;	//	상판의 구멍 표준 간격
	0	//	reserved
];
PARAM_BODY = [
	4,	//thick
	8,	// margin
	8,	// delta
	12,	// marginy
	24,	// paddingx
	12	// paddingy
];

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
function basis01Size(param) = [
	bodySize(PARAM_BODY, PARAM_TOP)[0] + param[0] * 2 + param[1],
	bodySize(PARAM_BODY, PARAM_TOP)[1] + param[0] * 2 + param[1],
	param[2]
];
module basis01(param) {
	echo("basis01 처음: ", param);

	bodySize = bodySize(PARAM_BODY, PARAM_TOP);
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
		bodySize[0] - margin - PARAM_BODY[0] * 2,
		bodySize[1] - margin - PARAM_BODY[0] * 2,
		overlap
	];
	difference() {
		cube(outter);
		note(outter[0], outter[1], outter[2]);
		translate([thick + margin / 2, thick + margin / 2, thick])
			cube(inner);
		translate([thick * 2 + margin / 2, thick * 2 + margin / 2, -thick])
			cube(inner2);
	}
	translate([bodySize[0] + thick + margin, bodySize[1] + thick + margin, thick])
		rotate([0, 0, 180])
		bodyPrototype(PARAM_BODY, PARAM_TOP, 0);

	echo("basis01 끝: ", param);
}

// 본체와의 결합 부위(basis01)를 받치는 기둥들
function basis02translate(param, PARAM_BODY) = [
	0,
	-rotate_vector([
		param[4],
		0,
		param[5]
	], [
		basis01Size(param, PARAM_BODY)[0] - param[0] / 2,
		param[0] / 2,
		param[0] / 2])[1],
	param[3]
];
module basis02(param) {
	echo("basis02 처음: ", param);

	bodySize = bodySize(PARAM_BODY, PARAM_TOP);
	basis01Size = basis01Size(param);

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
	
		[basis01Size[0] - thick / 2,	basis01Size[1] - thick / 2,	basis01Size[2] - thick / 2],
		[thick / 2,						basis01Size[1] - thick / 2,	basis01Size[2] - thick / 2],

//		[thick / 2,						thick / 2,					basis01Size[2] - thick / 2],
//		[basis01Size[0] - thick / 2,	thick / 2,					basis01Size[2] - thick / 2],

		[0,								0,							0]	//	reserved
	];
//	rotate([anglex, 0, anglez])
		translate([0, 0, height])
			translate(points[0])
	rotate([anglex, 0, anglez])
				translate([bodySize[0] + thick / 2, bodySize[1] + thick / 2, 0])
				rotate([0, 0, 180])
				bodyPrototype(PARAM_BODY, PARAM_TOP);

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
			#line_sphere([
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
	
	echo("basis02 끝: ", param, PARAM_BODY);
}
module basis(param) {
	echo("basis 시작: ", param);

	bodySize = bodySize(PARAM_BODY, PARAM_TOP);

	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];
	anglex = param[4];
	anglez = param[5];

	color("Pink", 0.5)
		translate(basis02translate(param, PARAM_BODY))
		rotate([anglex, 0, anglez]) {
			translate([bodySize[0] + thick + margin, bodySize[1] + thick + margin, thick])
				rotate([0, 0, 180]) {
					basis01(param);
					assempleBody(PARAM_BODY, PARAM_TOP, 0);
				}
		}

	basis02(param);


	echo("basis ...ing: ", bodySize=bodySize);
	full = [240, 128, bodySize[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	rotate([0, 0, 90])	color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);

	echo("basis 끝: ", param);
}

module build(target, step) {
	echo("build basis 처음: ", target, step);

	param = [
		4,		//	thick = 4;
		1,		//	margin = 1;		//	하층판 결합부위 여유 공간
		200,	//	overlap = 32;	//	하층판과 기초판이 겹치는 길이
		128,	//	height = 128;	//	기초판의 높이
		-30,	//	anglex = -30;	//	앞으로 기울어지는 정도
		-30,	//	anglez = -30;	//	옆으로 돌아가는 정도
		0,		//	reserved
	];

	thick = param[0];
	bodySize = bodySize(PARAM_BODY, PARAM_TOP);
	if (target == 1) {
			basis01(param);
	} else if (target == 2) {
			basis02(param);
	} else if (target == 3) {
			basis(param);
	} else {
		rotate([0, 0, -$t * 360])
			rotate([-30, 0, 0])
			translate([param[0], thick, thick])
			translate([bodySize[0], bodySize[1], 0])
			rotate([0, 0, 180])
			assempleBody(PARAM_BODY, PARAM_TOP, 0);
	}

	echo("build basis 끝: ", target, step);
}

target = 2;
build(target, $t);