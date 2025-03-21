/*
	지지대 45도 기울기면 더 좋을 듯 #29
*/
use <MCAD/boxes.scad>

include	<../../common/constants.scad>
use <../../common/library.scad>
use <../../common/library_cube.scad>

use <../top/landscape.scad>
use <foot#28.scad>
use <wall.scad>

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
DEFAULT_PARAM = [
		4,		//	thick = 4;
		1,		//	margin = 1;		//	하층판 결합부위 여유 공간
		200,	//	overlap = 32;	//	하층판과 기초판이 겹치는 길이
		128,	//	height = 128;	//	기초판의 높이
		45,	//	anglex = -30;	//	앞으로 기울어지는 정도
		-30,	//	anglez = -30;	//	옆으로 돌아가는 정도
		0		//	reserved
];

function topSize(param) = landscapeSize(param[0], param[1], param[2]);

module stick(start, end, r, c) {
	//line_type_1(start, end, r);
	
	d = end - start;
	length = sqrt(pow(d.x, 2) + pow(d.y, 2) + pow(d.z, 2));
	cut = is_undef(c) ? r / 16 : c;

	translate(end.x > start.x ? start : end.y > start.y ? start : end.z > start.z ? start : end)
		rotate([0, 0, d.x == 0 ? 90 : atan(d.y / d.x)])
		translate([-r, -r, -r])
		union() {
			translate([r, r, 0])			cylinder_type_1(r * 2, r, cut);
			translate([r, 0, 0])			cube_type_4([length, r * 2, r * 2], cut);
			translate([length + r, r, 0])	cylinder_type_1(r * 2, r, cut);
		}
}
/*
	실린더 모양의 라인 구조체
	type
		0: 오른쪽 지지대
		1: 왼쪽 지지대
		2: 연결 막대 원형
		3: 높이 받침대
		4: 연결 막대 육면체형
		5: 원형 연결 막대 1개
		6: 
*/
module basis01_type_3(type = 2) {
	echo("basis01_type_3 처음: ", DEFAULT_PARAM, type);

	topSize = topSize(PARAM_TOP);

	thick = DEFAULT_PARAM[0];
	margin = DEFAULT_PARAM[1];
	overlap = DEFAULT_PARAM[2];
	height = DEFAULT_PARAM[3];
	anglex = 0;
	angley = DEFAULT_PARAM[4];
	anglez = DEFAULT_PARAM[5];

	radious = thick;

	x = topSize.x;
	y = topSize.y - radious * 2;
	z = overlap;

	// 연결점 추가
	height_joint_top = thick * 2;
	depth_bolt = radious / 4 * 3;

	p0 = [0, 0, 0];
	p1 = [0, cos(angley) * z, 0];
	p2 = [cos(angley) * y, p1.y + sin(angley) * y, 0];
	p3 = [p2.x + sin(angley) * z, sin(angley) * y, 0];
	p4 = [p3.x, 0, 0];
	p5 = [sin(angley) * z, 0, 0];
	tps = [p0, p1, p2, p3, p4, p5];
	ps = tps;
	vm = type == 0 ? [0, 0, 0] : [1, 0, 0];
	vt = type == 0 ? [radious, radious, radious] : [200, radious, radious];
	cut = radious / 16;

	if (type == 0 || type == 1) {	//	왼쪽 오른쪽 지지대
		translate(vt)
		mirror(vm)
		difference() {
			union() {
				stick(ps[0], ps[1], radious);
				stick(ps[1], ps[2], radious);
				stick(ps[2], ps[3], radious);
				stick(ps[3], ps[4], radious);
				stick(ps[4], ps[0], radious);

				stick(ps[1], ps[5], radious);
				stick(ps[5], ps[3], radious);
			}
			union() {
				for (cx = [0:len(ps) - 1]) {
					translate(ps[cx] + [0, 0, depth_bolt])
						rotate([0, 180, 0])
						casting_black_25(radious * 2 - 3 - depth_bolt);
				}
			}
		}
	} else if (type == 2) {	//	신형 연결 막대
		dyCasting = radious * 2 - 3 - depth_bolt;
		translate([radious, 0, radious])
		for (cx = [0:3]) {
			translate([cx * (radious * 2 + 1), 0, 0])
				rotate([-90, 0, 0])
					difference() {
						translate([radious, -radious, 0])	rotate([0, -90, 0])	cube_type_4([x, radious * 2, radious * 2]);
						translate([0, 0, -dyCasting - 3])
							casting_black_25(dyCasting);
						translate([0, 0, x + dyCasting + 3])
							rotate([180, 0, 0])
								casting_black_25(dyCasting);
					}
		}
	} else if (type == 5) {	//	원형 연결 막대 1개
		dyCasting = radious * 2 - 3 - depth_bolt;
		translate([radious, 0, radious])
			rotate([-90, 0, 0])
					difference() {
						translate([radious, -radious, 0])
							rotate([0, -90, 0])
							cube_type_4([x, radious * 2, radious * 2]);
						translate([0, 0, -dyCasting - 3])
							casting_black_25(dyCasting);
						translate([0, 0, x + dyCasting + 3])
							rotate([180, 0, 0])
								casting_black_25(dyCasting);
					}
	} else if (type == 3) {	//	높이 받침대
		outter = radious * 4;
		h = 57.7 + 13;
		inner = radious * 1.05;
		difference() {
			translate([inner, inner, 0])	line_type_1([0, 0, 0], [0, 0, h], radious, outter);
			hull() {
				line_type_1([0, 0, h], [radious * 8, 0, h], inner);
				translate([0, 0, radious * 8])	line_type_1([0, 0, h], [radious * 8, 0, h], inner);
			}
			hull() {
				line_type_1([0, 0, h], [0, radious * 8, h], inner);
				translate([0, 0, radious * 8])	line_type_1([0, 0, h], [0, radious * 8, h], inner);
			}
		}
	} else {
		echo("ERROR!!! ----------------------- 없는 요청입니다");
	}

	echo("basis01_type_3 끝: ", DEFAULT_PARAM, type);
}

module basis01_type_3_assemble() {
	size = topSize(PARAM_TOP);
	h = 57.7 + 13;
	inner = DEFAULT_PARAM[0] * 1.05;
	maxx = DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]) + (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * cos(DEFAULT_PARAM[4]);

	translate([maxx + DEFAULT_PARAM[0] * 2, 0, 0])
	rotate([0, 0, 180]) {
		translate([0, 0, 0])										rotate([90, 0, 0])		basis01_type_3(0);
		translate([DEFAULT_PARAM[0] * 2 + maxx, size.x, 0])			rotate([90, 0, 180])	basis01_type_3(1);
		translate([0, 0, 0])																basis01_type_3(5);
		translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]), 0, 0])							basis01_type_3(5);
		translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]) + (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * cos(DEFAULT_PARAM[4]), 0, 0])	basis01_type_3(5);
		translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]) + (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * cos(DEFAULT_PARAM[4]), 0, (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * sin(DEFAULT_PARAM[4])])	basis01_type_3(5);
		translate([inner, -inner, -h])	basis01_type_3_foot();

		translate([PARAM_TOP[0] / 2, topSize(PARAM_TOP).x, PARAM_TOP[0] / 2 + DEFAULT_PARAM[2] * cos(DEFAULT_PARAM[4])])
			rotate([DEFAULT_PARAM[4], 0, -90])
			translate([0, -PARAM_TOP[0] / 2, -PARAM_TOP[0] / 2])
			landscape(PARAM_TOP[0], PARAM_TOP[1], PARAM_TOP[2]);
	}

	%wall(320, 320, 320);
}
module samples() {
	translate([0, 0, 0])											rotate([90, 0, 0])		basis01_type_3(0);
	translate([0, topSize(PARAM_TOP).x + DEFAULT_PARAM[0] * 2, 0])	rotate([90, 0, 180])	basis01_type_3(1);
	translate([0, DEFAULT_PARAM[0], 0])														basis01_type_3(2);
	translate([0, topSize(PARAM_TOP).x + DEFAULT_PARAM[0], -DEFAULT_PARAM[0] + DEFAULT_PARAM[2] * cos(DEFAULT_PARAM[4])])
		rotate([DEFAULT_PARAM[4], 0, -90])
		landscape(PARAM_TOP[0], PARAM_TOP[1], PARAM_TOP[2]);
}

module build(target, step) {
	if (target == 0) {
		basis01_type_3(0);
	} else if (target == 1) {
		basis01_type_3(1);
	} else if (target == 2) {
		basis01_type_3(2);
	} else if (target == 3) {
		basis01_type_3(3);
	} else if (target == 5) {
		basis01_type_3(4);
	} else if (target == 6) {
		basis01_type_3(5);
	} else if (target == 7) {
		basis01_type_3_assemble();
	} else {
		samples();
	}
}


target = 7;
build(target, $t);

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-right.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-left.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-stick.stl -D target=2 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-foot.stl -D target=3 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-1stick.stl -D target=6 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#29-assemble.stl -D target=7 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#29.scad
*/