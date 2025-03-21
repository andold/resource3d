// rectangle.scad
include <BOSL/constants.scad>
use <BOSL/threading.scad>

include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/library_trimmer.scad>

MEASURE = [
	//	사각 티슈
	240,	//	1. 가로
	120,	//	2. 세로
	100,	//	3. 높이
	120,	//	4. 중앙 타원 구멍
	158,	//	5. 중앙 타원 가로
	42,		//	6. 중앙 타원 세로
	//	식탁 고정 대상
	14,		//	1. 걸이 높이 가까운 쪽
	25,		//	2. 걸이 높이 먼 쪽
	47,		//	3. 걸이 너비
	62,		//	4. 걸이 상단과의 공간 높이
	// 사각 티슈 걸이 - 너무 크다 조립형태로 #43
	1.5,	//	밑판 두께

	0		//	reserved
];

DEFINE = [
	2,	//	두께
	8,	//	너비
	8,	//	걸게 높이
	// 사각 티슈 걸이 - 너무 크다 조립형태로 #43
	16,	//	고정물 너비

	0	//	reserved
];

function dx_cube_type_2(dx, dy, distance) =
	distance * dy / sqrt(dx * dx + dy * dy)
;
function ddx(dx, dy, ddy) =
	dx * ddy / dy
;

//	식탁에 고정 - 사각 티슈 걸이 - 너무 크다 조립형태로 #43
module holder431() {
	t = DEFINE[0];
	t2 = t * 2;
	x = MEASURE[6];
	x1 = MEASURE[7];
	y = DEFINE[3];
	z = MEASURE[8];

	translate([z + t2, 0, 0])
	{
		//translate([-t, 0, t])	basis();
		color("Yellow", 0.5)
		difference()
		{
			//	피부처럼 감싸는 완전체
			rotate([0, -90, 0])
			difference()
			{
				size = [
					x + t + ddx(x1 - x, z, -t) + dx_cube_type_2(x1 - x, z, t),
					y,
					z + t2
				];
				//	14: 25 = (14 + 4) : x
				xx = x1 + t + ddx(x1 - x, z, t) + dx_cube_type_2(x1 - x, z, t);
				// 식탁 고정 대상 외벽
				// TODO x1 + t * 2 계산을 비례식으로 다시해야 한다
				cube_type_2(size, xx);
				// 식탁 고정 대상
				translate([t, -EPSILON, t])
					cube_type_2([x, y + EPSILON2, z], x1);
			}
			//	집어넣는 구조를 위한 틈
			translate([-(z + t2 + EPSILON), -EPSILON, t + DEFINE[2]])
				cube_type_0([t + EPSILON2, y + EPSILON2, x1 - DEFINE[2] * 2]);
		}
	}
}



//	사각 티슈 받침대
module holder432() {
	t = DEFINE[0];
	t2 = t * 2;
	x = MEASURE[1] + t2;
	y = DEFINE[3];
	z = t;
	dt = MEASURE[10];

	translate([t, t, t])
	{
		//tissue_box();
		{
			// 앞
			translate([-t, -t, -t])
			cube_type_0([x, t, y]);
			// 왼쪽
			translate([-t, -t, -t])
			cube_type_0([t, y, y]);
			// 오른쪽
			translate([x - t2, -t, -t])
			cube_type_0([t, y, y]);
			// 아래
			translate([-t, -t, -t])
			cube_type_0([x, y, z]);
			// 위
			translate([-t, -t, dt])
			translate([0, 0, t])
			rotate([1, 0, 0])
			translate([0, 0, -t])
			cube_type_0([x, y, z]);
		}
	}
}

//	식탁에 고정
module holder1() {
	t = DEFINE[0];
	t2 = t * 2;
	x = MEASURE[6];
	x1 = MEASURE[7];
	y = DEFINE[1];
	z = MEASURE[8];

	translate([z + t2, 0, 0])
	{
		translate([-t, 0, t])
			%basis();
		color("Yellow", 0.5)
		difference()
		{
			//	피부처럼 감싸는 완전체
			rotate([0, -90, 0])
			difference()
			{
				size = [
					x + t + ddx(x1 - x, z, -t) + dx_cube_type_2(x1 - x, z, t),
					y,
					z + t2
				];
				//	14: 25 = (14 + 4) : x
				xx = x1 + t + ddx(x1 - x, z, t) + dx_cube_type_2(x1 - x, z, t);
				// 식탁 고정 대상 외벽
				// TODO x1 + t * 2 계산을 비례식으로 다시해야 한다
				cube_type_2(size, xx);
				// 식탁 고정 대상
				translate([t, -EPSILON, t])
					cube_type_2([x, y + EPSILON2, z], x1);
			}
			//	집어넣는 구조를 위한 틈
			translate([-(z + t + EPSILON), -EPSILON, t + DEFINE[2]])
				cube_type_0([t + EPSILON2, y + EPSILON2, x1 - DEFINE[2] * 2]);
		}
		// 티슈 받침
		//cube_type_0([MEASURE[1], y, t]);
	}
}

//	사각 티슈 받침대
module holder2() {
	t = DEFINE[0];
	t2 = t * 2;
	x = MEASURE[1];
	y = MEASURE[0];
	z = MEASURE[1];
	w = DEFINE[2] + (MEASURE[1] - MEASURE[2]) / 2;

	translate([t, 0, t])
	{
		%tissue_box();
		//color("Blue", 0.5)
		{
			// 앞
			translate([-t, -t, -t])
			cube_type_0([x + t2, t, DEFINE[2] + t2]);
			// 앞 아래
			translate([-t, -t, -t])
			cube_type_0([x + t2, w + t2, t]);
			// 뒤
			translate([-t, y, -t])
			cube_type_0([x + t2, t, DEFINE[2] + t2]);
			// 뒤 아래
			translate([-t, y - w - t, -t])
			cube_type_0([x + t2, w + t2, t]);
			// 왼쪽
			translate([-t, -t, -t])
			cube_type_0([t, y + t2, DEFINE[2] + t2]);
			// 왼쪽 아래
			translate([-t, -t, -t])
			cube_type_0([w + t2, y + t2, t]);
			// 오른쪽
			translate([x, -t, -t])
			cube_type_0([t, y + t2, DEFINE[2] + t2]);
			// 왼쪽 아래
			translate([x - w - t, -t, -t])
			cube_type_0([w + t2, y + t2, t]);
		}
	}
}
module basis() {
	translate([0, -MEASURE[0] / 2, 0])
	rotate([0, -90, 0])
	cube_type_2([MEASURE[6], MEASURE[0] * 2, MEASURE[8]], MEASURE[7]);
}
module tissue_box() {
	cube([MEASURE[1], MEASURE[0], MEASURE[2]]);
}
module holder_assemble() {
	translate([0, -DEFINE[0], 0])
		holder1();
	translate([0, MEASURE[0] - DEFINE[1] + DEFINE[0], 0])
		holder1();
	translate([MEASURE[8] + DEFINE[0] * 1, 0, DEFINE[0] * 0])
	holder2();
}

module holder_assemble_43_left() {
	translate([0, 30, 0])
	rotate([90, 0, 0])
	{
		holder431();
		translate([MEASURE[8] + DEFINE[0], 0, 0])
			holder432();
	}
}
module holder_assemble_43() {
	holder_assemble_43_left();
	translate([0, 62, 0])
	rotate([0, 0, 180])
	mirror([1,0,0])
	holder_assemble_43_left();
}

holder_assemble_43();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\tissue-holder#43.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\tissue-holder\rectangle.scad
*/
