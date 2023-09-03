use <MCAD/boxes.scad>

include	<../../common/constants.scad>
use <../../common/library.scad>
use <../top/landscape.scad>
use <../etc/utils.scad>
use <wall.scad>
use <body.scad>

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
function topSize(param) = landscapeSize(param[0], param[1], param[2]);
module basis01_type_1(param) {
	echo("basis01_type_1 처음: ", param);

	bodySize = bodySize(PARAM_BODY, PARAM_TOP);
	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];
	anglex = param[4];
	anglez = param[5];

	points = [
		// 외경 기준
		[0,				0,				0],
		[bodySize[0],	0,				0],
		[bodySize[0],	bodySize[1],	0],
		[0,				bodySize[1],	0],

		[0,				0,				bodySize[2]],
		[bodySize[0],	0,				bodySize[2]],
		[bodySize[0],	bodySize[1],	bodySize[2]],
		[0,				bodySize[1],	bodySize[2]],

		[0,				0,				0]	//	reserved

	];
	
	// 벽의 중심 기준
	tps = [
		// 아래쪽
		[thick / 2,					thick / 2,					0],
		[bodySize[0] - thick / 2,	thick / 2,					0],
		[bodySize[0] - thick / 2,	bodySize[1] - thick / 2,	0],
		[thick / 2,					bodySize[1] - thick / 2,	0],
		// 위쪽 앞쪽
		[thick / 2,					thick / 2,					bodySize[2]],
		[bodySize[0] - thick / 2,	thick / 2,					bodySize[2]],
		[0,							0,							0]				//	reserved for comma
	];
	rpoints = [for (cx = [0:len(points) - 1])	rotate_vector([anglex, 0, anglez], points[cx])];
	rtps = [for (cx = [0:len(tps) - 1])	rotate_vector([anglex, 0, anglez], tps[cx])];

	// 아래쪽
	line_type_1(tps[0], tps[1], thick * 1.5);
	line_type_1(tps[1], tps[2], thick * 1.5);
	line_type_1(tps[2], tps[3], thick * 1.5);
	line_type_1(tps[3], tps[0], thick * 1.5);

	// 위쪽 앞쪽
	radious2 = thick * (1.5 + sqrt(2) / 2) / 2;
	dxy = -(thick / 2 * 3 - radious2) * sqrt(2) / 2;
	line_type_1(tps[0] + [dxy, dxy, dxy],			tps[4] + [dxy, dxy, thick - radious2],	radious2);
	line_type_1(tps[4] + [0, -thick / 2, -thick],		tps[5] + [0, -thick / 2, -thick],			thick);
	line_type_1(tps[5] + [-dxy, dxy, thick - radious2],	tps[1] + [-dxy, dxy, dxy],			radious2);
	// 몸체 프로토타입
	translate([bodySize[0], bodySize[1], 0])
		rotate([0, 0, 180])
		%bodyPrototype(PARAM_BODY, PARAM_TOP);

	echo("basis01_type_1 끝: ", param);
}



// 실린더 모양의 라인 구조체
module basis01_type_2(param) {
	echo("basis01_type_1 처음: ", param);

	HEIGHT = 200;

	thick = param[0];
	margin = param[1];
	overlap = param[2];
	height = param[3];
	anglex = 0;
	angley = param[4];
	anglez = param[5];

	radious = thick;

	expand = [-radious * 2, +radious * 2, 0];
	delta = [expand.x / 2, expand.y / 2, expand.z / 2];

	// 육면체 형태로
	// 외경을 내경으로 index: 0 ~ 7
	points = vectors_from_cube([topSize(PARAM_TOP)[1], topSize(PARAM_TOP)[0], HEIGHT] + expand);
	
	// 연결점 추가
	height_joint_top = thick * 2;
	depth_bolt = radious / 4 * 3;
	points_appended = concat(points, [
		for (cx = [4:len(points) - 1])	[0, 0, height_joint_top] + points[cx]	//	index 8 ~ 11, 위쪽
	], [
		for (cx = [0:len(points) - 1])	[0, -depth_bolt, 0] + points[cx]	//	index 12 ~ 19, 왼쪽
	], [
		for (cx = [0:len(points) - 1])	[0, depth_bolt, 0] + points[cx]	//	index 20 ~ 27, 오른쪽
	]);

	// 회전
	points_rotated = [for (cx = [0:len(points_appended) - 1])	rotate_vector([anglex, angley, anglez], points_appended[cx])];

	// 원점 조정	[4, 86.909, 38]
	min_vector = [
		-min(points_rotated[0].x, points_rotated[3].x, points_rotated[4].x, points_rotated[7].x) + radious,
		-min(points_rotated[1].y, points_rotated[2].y, points_rotated[5].y, points_rotated[6].y) + radious,
		-min(points_rotated[0].z, points_rotated[1].z, points_rotated[2].z, points_rotated[3].z) + 0
	];
	echo("min vector", min_vector);
	points_normalized = [for (cx = [0:len(points_rotated) - 1])	min_vector + points_rotated[cx]];

	// 작은 선반위로 [0, 0, 74.7]
	up = [0, 0, 57.7 + 13 + radious];
	echo("up", up);
	points_upward = [for (cx = [0:len(points_normalized) - 1])	up + points_normalized[cx]];

	difference() {
		// 일단 만들고
		union() {
			//	메인
			//color("Gold", 0.1)
				cube_type_3(points_upward, radious);

			//상하기둥
			union() {
				line_type_1(points_upward[0], set_z(points_upward[0], up.z), radious);
				line_type_1(points_upward[3], set_z(points_upward[3], up.z), radious);
				line_type_1(points_upward[5], points_upward[5].x > 180 ? set_z(points_upward[5], 0) : set_z(points_upward[5], up.z), radious);
				line_type_1(points_upward[6], set_z(points_upward[6], 0), radious);

				//	전후기둥
				line_type_1(set_z(points_upward[0], up.z), set_z(points_upward[5], up.z), radious);
				line_type_1(set_z(points_upward[3], up.z), set_z(points_upward[6], up.z), radious);
				
				//	좌우기둥
				line_type_1(set_z(points_upward[0], up.z), set_z(points_upward[3], up.z), radious);
				line_type_1(set_z(points_upward[5], up.z), set_z(points_upward[6], up.z), radious);
			}
		}
		// 나사 구멍
		union() {
			//	index 12 ~ 19, 왼쪽
			translate(points_upward[12])
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[13])
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[16])
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[17])
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);

			translate(set_z(points_upward[12], 70.7 + radious))
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(set_z(points_upward[17], 70.7 + radious))
				rotate([anglex, angley, anglez])
				rotate([-90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
				
			//	index 20 ~ 27, 오른쪽
			translate(points_upward[22])
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[23])
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[26])
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(points_upward[27])
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);

			translate(set_z(points_upward[23], 70.7 + radious))
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
			translate(set_z(points_upward[26], 70.7 + radious))
				rotate([anglex, angley, anglez])
				rotate([90, 0, 0])
				casting_black_25(radious * 2 - 3 - depth_bolt);
		}
	}

	// 프로토타입
	translate([0, 0, -radious])
	translate(up)
	translate(min_vector)
	rotate([anglex, angley, anglez])
	translate([topSize(PARAM_TOP)[1], 0, HEIGHT - 0])
	translate(delta)
		rotate([0, 0, 90])
		#landscapePrototype(PARAM_TOP);

	translate([0, 128, 0])
	rotate([0, 0, 0])
	%wall(320, 320, 320);

	echo("basis01_type_1 끝: ", param);
}

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

		[thick / 2,						thick / 2,					basis01Size[2] - thick / 2],
		[basis01Size[0] - thick / 2,	thick / 2,					basis01Size[2] - thick / 2],

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
			#line_sphere([
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
	
//	rotate([anglex, 0, anglez])
//		translate([0, 0, height])
	translate(rpoints[0])
	rotate([anglex, 0, anglez])
				translate([bodySize[0] + thick / 2, bodySize[1] + thick / 2, 0])
				rotate([0, 0, 180])
				topPrototype(PARAM_TOP);

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
		30,	//	anglex = -30;	//	앞으로 기울어지는 정도
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
			basis01_type_1(param);
	} else if (target == 4) {
			basis01_type_2(param);
	} else if (target == 5) {
		translate([0, 0, 0])	metric_bolt(headtype="countersunk", size=10, l=16, shank=8, details=true, phillips="#2", $fn=32);
		#translate([10, 0, 0])	metric_nut(size=10, hole=true, pitch=1.5, details=true, $fn=32);
	} else if (target == 6) {
			basis(param);
	} else if (target == 7) {
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

target = 4;
build(target, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis.stl -D target=2 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis-type-2.stl -D target=4 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis.scad
*/