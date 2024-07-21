include	<../../common/constants.scad>
use <../../common/library.scad>
use <../../common/library_text.scad>
use <../../common/library_cube.scad>
use <basis#37.scad>
use <wall.scad>

//	①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳

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

// 다리①
module under_type_1_1_1(name = "다리①") {
	echo("under_type_1_1_1 처음: ");

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

	difference() {
		union() {
			cube_type_7([thick, thick, z]);
			translate([thick / 2 + 2, 0, z - thick / 2 + 0])
			rotate([-90, 0, 0])
				cylinder(thick, 6, 6);
		}
		note_type_2(name, [thick, thick, z]);
		translate([thick / 2 + 2 , 0, z - thick / 2 + 0])
			rotate([-90, 0, 0])
			casting_black_25(z, false);
	}

	echo("under_type_1_1_1 끝: ");
}

// 다리① 다리② 다리①②
module under_type_1_1() {
	echo("under_type_1_1 처음: ");

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

    //	다리
    translate([0, -thick, 0])
	under_type_1_1_1("다리①");

    translate([0, MEASURE[3].x + thick * 3, 0])
	mirror([0,1,0])
	under_type_1_1_1("다리②");

    translate([0, -thick, height1st - thick])
	difference()
    {
		union() {
			cube_type_7([thick, outter, thick]);
			note_type_2("다리①②", [thick, outter, thick]);
		}
		
		for (cx = [thick:16:outter - thick * 3])
		translate([thick / 2, thick + cx, -thick])
		rotate([0, 0, 90])
		casting_black_25(z, false);
    }

	echo("under_type_1_1 끝: ");
}


//
module under_type_1_2() {
	echo("under_type_1_2 처음: ");

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

	// 가까운 지지대 다리
	translate([0, tsin, 0])
	{
		cube_type_7([thick, thick, height1st]);
		note_type_2("가까운 지지대 다리", [thick, thick, height1st]);
	}
	//	먼 지지대 다리
	translate([0, ocos - thick, 0])
	{
		cube_type_7([thick, thick, height1st]);
		note_type_2("먼 지지대 다리", [thick, thick, height1st]);
	}
	//	지지대간의 지지대
	translate([0, 0, height1st - thick])	//	바닥에 있는 걸 들어 올리기
	translate([0, tsin, 0])
	{
		difference() {
			union() {
				cube_type_7([thick, ocos - tsin, thick]);
				note_type_2("지지대간의 지지대", [thick, ocos - tsin, thick]);
			}
			for (cx = [thick:16:ocos - tsin - thick * 3])
			translate([thick / 2, thick + cx, -thick])
			rotate([0, 0, 90])
			casting_black_25(z, false);
		}
	}

	echo("under_type_1_2 끝: ");
}


//
module under_type_1_3_1(name, v) {
	echo("under_type_1_3_1 처음: ");

	difference() {
		union() {
			cube_type_7(v);
			note_type_2(name, v);
			translate([v.z / 2, v.z / 2, 0])
			cylinder(v.z, 6, 6);
			translate([v.x - v.z / 2, v.z / 2, 0])
			cylinder(v.z, 6, 6);
			note_type_2("...", v);
		}
		translate([v.z / 2, v.z / 2, 0])
			casting_black_25(z, false);
		translate([v.x - v.z / 2, v.z / 2, 0])
			casting_black_25(z, false);
	}

	echo("under_type_1_3_1 끝: ");
}
module under_type_1_3() {
	echo("under_type_1_3 처음: ");

	height1st = MEASURE[4] - MEASURE[5];
	height2nd = MEASURE[5];
	thick = DEFINE[0];
	inner = DEFINE[2];
	outter = inner + thick * 2;
	angle = DEFINE[1];
	distance = DEFINE[3] + 8;

	tcos = thick * cos(angle);	//	두께 코사인
	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

	//	다리에서부터 아래단까지
	translate([0, 0, height1st - thick * 2])	//	바닥에 있는 걸 들어 올리기
	{
		// 가까운 지지대
		translate([8-distance, thick, 0])
		under_type_1_3_1("", [distance + tcos, thick, thick]);

		//	먼 지지대
		translate([8 - distance, ocos - thick - 16, 0])
		under_type_1_3_1("", [distance  - osin - 12, thick, thick]);
	}

	echo("under_type_1_3 끝: ");
}

//
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
    under_type_1_1();

	//	다리에서부터 아래단까지
	under_type_1_3();

	translate([-distance, 0, 0])
	under_type_1_2();

	echo("under_type_1 끝: ");
}

module under_type_1_assemble() {
	%translate([32, 0, 0])
		rotate([0, 0, DEFINE[1]])
		translate([0, 0, MEASURE[4]])
		basis01_type_4_assemble();
	*%wall(320, 320, 320);
	
	translate([220, 256 * sin(DEFINE[1]), 0])
	under_type_1();
}
module under_type_1_print() {
	%translate([32, 0, 0])
		rotate([0, 0, DEFINE[1]])
		translate([0, 0, MEASURE[4]])
		basis01_type_4_assemble();
	
	translate([220, 256 * sin(DEFINE[1]), 0])
	%under_type_1();
    
	translate([64, -6, 0])
	rotate([0, -90, 0])
    under_type_1_1();

	rotate([0, -90, 0])
	under_type_1_2();
}

under_type_1_assemble();
//under_type_1_print();
//under_type_1_3();
//under_type_1_3_1([32, 4, 4]);

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\under#38.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\under#38.scad
*/