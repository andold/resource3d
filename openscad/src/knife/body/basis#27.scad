use <MCAD/boxes.scad>

include	<../../common/constants.scad>
use <../../common/library.scad>
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
		30,	//	anglex = -30;	//	앞으로 기울어지는 정도
		-30,	//	anglez = -30;	//	옆으로 돌아가는 정도
		0		//	reserved
];

function topSize(param) = landscapeSize(param[0], param[1], param[2]);

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
	ps = type == 1 ? [for (cx = [0:len(tps) - 1]) rotate_vector([0, 180, 0], tps[cx])] : tps;

	if (type == 0 || type == 1) {	//	왼쪽 오른쪽 지지대
		translate([radious, radious, radious])
		difference() {
			union() {
				line_type_1(ps[0], ps[1], radious);
				line_type_1(ps[1], ps[2], radious);
				line_type_1(ps[2], ps[3], radious);
				line_type_1(ps[3], ps[4], radious);
				line_type_1(ps[4], ps[0], radious);

				line_type_1(ps[1], ps[5], radious);
				line_type_1(ps[5], ps[3], radious);
				for (cx = [0:len(ps) - 1]) {
					translate(ps[cx] - [0, 0, radious])
						cylinder(radious, radious, radious);
				}
			}
			union() {
				for (cx = [0:len(ps) - 1]) {
					translate(ps[cx] + [0, 0, depth_bolt])
						rotate([0, 180, 0])
						casting_black_25(radious * 2 - 3 - depth_bolt);
				}
			}
		}
	} else if (type == 2 || type == 4) {	//	원형 육면체형 연결 막대
		dyCasting = radious * 2 - 3 - depth_bolt;
		translate([radious, 0, radious])
		for (cx = [0:3]) {
			translate([cx * radious * 3, 0, 0])
				rotate([-90, 0, 0])
					difference() {
						if (type == 2) {
							cylinder(x, radious, radious, $fn = FN);
						} else if (type == 4) {
							translate([-radious, -radious, 0])	cube([radious * 2, radious * 2, x]);
						} else {
							echo("ERROR!!! ----------------------- 없는 요청입니다");
						}
						translate([0, 0, -dyCasting - 3])
							casting_black_25(dyCasting);
						translate([0, 0, x + dyCasting + 3])
							rotate([180, 0, 0])
								casting_black_25(dyCasting);
					}
		}
		// 가이드
		guide = [40, 1.6, 0.28];
		cube(guide);
		translate([0, x - guide.y, 0])	cube(guide);
	} else if (type == 5) {	//	원형 연결 막대 1개
		dyCasting = radious * 2 - 3 - depth_bolt;
		translate([radious, 0, radious])
			rotate([-90, 0, 0])
			difference() {
				cylinder(x, radious, radious, $fn = FN);
				translate([0, 0, -dyCasting - 3])							casting_black_25(dyCasting);
				translate([0, 0, x + dyCasting + 3])	rotate([180, 0, 0])	casting_black_25(dyCasting);
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

module prototype_basis01_type_3() {
	topSize = topSize(PARAM_TOP);
	radious = DEFAULT_PARAM[0];
	x = DEFAULT_PARAM[2];
	y = topSize.y - radious * 2;
	depth_bolt = radious / 4 * 3;

	p0 = [0, 0, 0];
	p1 = [0, y, 0];
	p2 = [x, y, 0];
	p3 = [x, 0, 0];
	tps = [p0, p1, p2, p3];

	difference() {
		union() {
			translate([-radious, -radious, -radious])	cube([radious * 2, y + radious * 2, radious * 2]);
			translate([-radious, y -radious, -radious])	cube([x + radious * 2, radious * 2, radious * 2]);
			translate([x-radious, -radious, -radious])	cube([radious * 2, y + radious * 2, radious * 2]);
			translate([-radious, -radious, -radious])	cube([x + radious * 2, radious * 2, radious * 2]);

			for (cx = [0:len(tps) - 1]) {
				translate(tps[cx] - [0, 0, radious])
					cylinder(radious, radious, radious);
			}
		}
		union() {
			for (cx = [0:len(tps) - 1]) {
				translate(tps[cx] + [0, 0, depth_bolt])
					rotate([0, 180, 0])
					{
						casting_black_25(radious * 2 - 3 - depth_bolt);
					}
			}
		}
	}

	dyCasting = radious * 2 - 3 - depth_bolt;
	translate([topSize.y + radious * 4, topSize.y / 2, 0])
		rotate([-90, 0, 90])
			difference() {
				union()
				{
					translate([-radious, radious, -0])	rotate([90, 0, 0])	cube([radious * 2, topSize.y, radious * 2]);
				}
				translate([0, 0, -dyCasting - 3])
					casting_black_25(dyCasting);
				translate([0, 0, topSize.y + dyCasting + 3])
					rotate([180, 0, 0])
						casting_black_25(dyCasting);
			}
}

module assemble() {
	h = 57.7 + 13;
	inner = DEFAULT_PARAM[0] * 1.05;

	translate([0, 0, 0])										rotate([90, 0, 0])		basis01_type_3(0);
	translate([DEFAULT_PARAM[0] * 2, topSize(PARAM_TOP).x, 0])	rotate([90, 0, 180])	basis01_type_3(1);
	translate([0, 0, 0])																basis01_type_3(5);
	translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]), 0, 0])							basis01_type_3(5);
	translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]) + (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * cos(DEFAULT_PARAM[4]), 0, 0])	basis01_type_3(5);
	translate([DEFAULT_PARAM[2] * sin(DEFAULT_PARAM[4]) + (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * cos(DEFAULT_PARAM[4]), 0, (topSize(PARAM_TOP).y  - DEFAULT_PARAM[0] * 2) * sin(DEFAULT_PARAM[4])])	basis01_type_3(5);
	translate([inner, -inner, -h])	basis01_type_3_foot();

	%translate([0, topSize(PARAM_TOP).x, DEFAULT_PARAM[2] * cos(DEFAULT_PARAM[4])])
		rotate([DEFAULT_PARAM[4], 0, -90])
		landscape(PARAM_TOP[0], PARAM_TOP[1], PARAM_TOP[2]);
}
module samples() {
	translate([0, 0, 0])											rotate([90, 0, 0])		basis01_type_3(0);
	translate([0, topSize(PARAM_TOP).x + DEFAULT_PARAM[0] * 2, 0])	rotate([90, 0, 180])	basis01_type_3(1);
	translate([0, DEFAULT_PARAM[0], 0])														basis01_type_3(2);
	translate([0, topSize(PARAM_TOP).x + DEFAULT_PARAM[0], -DEFAULT_PARAM[0] + DEFAULT_PARAM[2] * cos(DEFAULT_PARAM[4])])
		rotate([DEFAULT_PARAM[4], 0, -90])
		landscape(PARAM_TOP[0], PARAM_TOP[1], PARAM_TOP[2]);
	!prototype_basis01_type_3();
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
	} else if (target == 4) {
		prototype_basis01_type_3();
	} else if (target == 5) {
		basis01_type_3(4);
	} else if (target == 6) {
		basis01_type_3(5);
	} else if (target == 7) {
		assemble();
	} else {
		samples();
	}
}


target = 7;
build(target, $t);

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-right.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-left.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-stick.stl -D target=2 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-foot.stl -D target=3 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-prototype.stl -D target=4 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-cstick.stl -D target=5 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\basis#27-1stick.stl -D target=6 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#27.scad
*/