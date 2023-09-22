include	<../../common/constants.scad>
use <../../common/library.scad>
use <../../common/library_text.scad>
use <../../common/library_cube.scad>
use <basis#37.scad>
use <wall.scad>

MEASURE = [
	57.7,	//	1차 높이. 오류, deprecate, use MEASURE[4] - MEASURE[5]
	13,		//	튀어나온 부분 두께. 오류, deprecate, use MEASURE[5]
	8,		//	지지대 두께
	[152, 84, 8],	//	top size
	//	2차 측정 값, 4 ~
	70.0,	//	단 전체 높이
	19.3,	//	튀어 나온 단 두께
	
	0		//	reserved
];

DEFINE = [
	8,		//	두께
	-30,	//	옆으로 돌아가는 정도
	MEASURE[3].x + MEASURE[2] * 2,	//	바깥쪽으로 감싸는 길이, 내경에 해당
	32,		//	다리와 아래단까지의 거리

	0		//	reserved
];

/*
*/
module under_type_1() {
	echo("under_type_1 처음: ");

	height1st = MEASURE[4] - MEASURE[5];
	height2nd = MEASURE[5];
	thick = DEFINE[0];
	inner = DEFINE[2];
	outter = inner + thick * 2;
	angle = DEFINE[1];
	distance = DEFINE[3];

	tcos = thick * cos(angle);	//	두께 코사인
	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

	rotate([0, 0, DEFINE[1]])	//	회전(약간의 영점 흐트러짐)
	translate([0, DEFINE[0], 0])	//	영점 조정
	{
		//	다리
		translate([0, -thick, 0])
		{
			difference() {
				cube_type_7([thick, thick, z]);
				translate([thick / 2, 0, z - thick / 2])
					rotate([-90, 0, 0])
					casting_black_25(z);
			}
		}
		translate([0, MEASURE[3].x + thick * 2, 0]) {
			difference() {
				cube_type_7([thick, thick, z]);
				translate([thick / 2, thick, z - thick / 2])
					rotate([90, 0, 0])
					casting_black_25(z);
			}
		}

		translate([0, -thick, height1st - thick])
		{
			cube_type_7([thick, outter, thick]);
			note_type_2("외경 기준", [thick, outter, thick]);
		}
	}
	//	다리에서부터 아래단까지
	translate([0, 0, height1st - thick])	//	바닥에 있는 걸 들어 올리기
	{
		// 가까운 지지대
		translate([-distance, tsin, 0])
		{
			cube_type_7([distance + tcos, thick, thick]);
			note_type_2("가까운 지지대", [distance + tcos, thick, thick]);

		}

		//	먼 지지대
		translate([-distance, ocos - thick, 0])
		{
			cube_type_7([distance - osin, thick, thick]);
			note_type_2("먼 지지대", [distance - osin, thick, thick]);
		}

		//	지지대간의 지지대
		translate([-distance, tsin, 0])
		{
			cube_type_7([thick, ocos - tsin, thick]);
			note_type_2("지지대간의 지지대", [thick, ocos - tsin, thick]);
		}
	}

	// 가까운 지지대 다리
	translate([-distance, tsin, 0])
	{
		cube_type_7([thick, thick, height1st]);
		note_type_2("가까운 지지대 다리", [thick, thick, height1st]);
	}
	//	먼 지지대 다리
	translate([-distance, ocos - thick, 0])
	{
		cube_type_7([thick, thick, height1st]);
		note_type_2("먼 지지대 다리", [thick, thick, height1st]);
	}


	echo("under_type_1 끝: ");
}
module under_type_1_assemble() {
	translate([32, 0, 0])
		rotate([0, 0, DEFINE[1]])
		translate([0, 0, MEASURE[4]])
		*%basis01_type_4_assemble();
	*%wall(320, 320, 320);
	
	under_type_1();
}

under_type_1_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\under#38.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\under#38.scad
*/