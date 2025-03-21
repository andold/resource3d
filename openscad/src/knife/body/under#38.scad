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

// UNDER①
module under1(name = "UNDER①") {
	echo("under1 처음: ");

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

	echo("under1 끝: ");
}

// UNDER②
module under2() {
	mirror([0,1,0])
	under1("UNDER②");
}

// UNDER③
module under3() {
	height1st = MEASURE[4] - MEASURE[5];
	height2nd = MEASURE[5];
	thick = DEFINE[0];
	inner = DEFINE[2];
	outter = inner + thick * 2;
	z = height1st + height2nd + thick;

	difference()
    {
		union() {
			cube_type_7([thick, outter, thick]);
			note_type_2("UNDER③", [thick, outter, thick]);
		}
		
		for (cx = [thick:16:outter - thick * 3])
		translate([thick / 2, thick + cx, -thick])
		rotate([0, 0, 90])
		casting_black_25(z, false);
    }
}

// UNDER④ = UNDER① + UNDER② + UNDER③
module under4() {
	echo("under4 처음: ");

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
	under1();

    translate([0, MEASURE[3].x + thick * 3, 0])
	under2();

    translate([0, -thick, height1st - thick])
	under3();

	echo("under4 끝: ");
}

// UNDER⑤
module under5(name = "UNDER⑤") {
	height1st = MEASURE[4] - MEASURE[5];
	thick = DEFINE[0];
	cube_type_7([thick, thick, height1st]);
	note_type_2(name, [thick, thick, height1st]);
}

// UNDER⑥
module under6(name = "UNDER⑥") {
	under5(name);
}

// UNDER⑦
module under7(name = "UNDER⑦") {
	height1st = MEASURE[4] - MEASURE[5];
	height2nd = MEASURE[5];
	thick = DEFINE[0];
	inner = DEFINE[2];
	outter = inner + thick * 2;
	angle = DEFINE[1];

	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

	difference() {
		union() {
			cube_type_7([thick, ocos - tsin, thick]);
			note_type_2(name, [thick, ocos - tsin, thick]);
		}
		for (cx = [thick:16:ocos - tsin - thick * 3])
		translate([thick / 2, thick + cx, -thick])
		rotate([0, 0, 90])
		casting_black_25(z, false);
	}
}

//	UNDER⑧ = UNDER⑤ + UNDER⑥ + UNDER⑦
module under8() {
	echo("under8 처음: ");

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
	under5();

	//	먼 지지대 다리
	translate([0, ocos - thick, 0])
	under6();

	//	지지대간의 지지대
	translate([0, 0, height1st - thick])	//	바닥에 있는 걸 들어 올리기
	translate([0, tsin, 0])
	under7();

	echo("under8 끝: ");
}


//
module under9(name = "UNDER⑨", v) {
	echo("under9 처음: ");

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
			casting_black_25(v.z, false);
		translate([v.x - v.z / 2, v.z / 2, 0])
			casting_black_25(v.z, false);
	}

	echo("under9 끝: ");
}

//	UNDER⑩
module under10(name = "UNDER⑩") {
	thick = DEFINE[0];
	angle = DEFINE[1];
	distance = DEFINE[3] + 8;
	tcos = thick * cos(angle);	//	두께 코사인

	under9(name, [distance + tcos, thick, thick]);
}

//	UNDER⑪
module under11(name = "UNDER⑪") {
	thick = DEFINE[0];
	inner = DEFINE[2];
	outter = inner + thick * 2;
	angle = DEFINE[1];
	distance = DEFINE[3] + 8;
	osin = outter * sin(angle);	//	외경 사인

	under9(name, [distance  - osin - 12, thick, thick]);
}

//	UNDER⑫ = UNDER④ + UNDER⑧ + UNDER⑩ + UNDER⑪
module under12(name = "UNDER⑫") {
	echo("under12 처음: ");

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
    under4();

	translate([-distance, 0, height1st - thick * 2])	//	바닥에 있는 걸 들어 올리기
	{
		translate([0, thick, 0])
		under10();

		translate([0, ocos - thick - 16, 0])
		under11();
	}

	translate([-distance, 0, 0])
	under8();

	echo("under12 끝: ");
}

module under12_assemble() {
	%translate([32, 0, 0])
		rotate([0, 0, DEFINE[1]])
		translate([0, 0, MEASURE[4]])
		basis01_type_4_assemble();
	*%wall(320, 320, 320);
	
	translate([220, 256 * sin(DEFINE[1]), 0])
	under12();
}
module under12_print() {
	thick = DEFINE[0];

	*%translate([32, 0, 0])
		rotate([0, 0, DEFINE[1]])
		translate([0, 0, MEASURE[4]])
		basis01_type_4_assemble();
	
	translate([220, 256 * sin(DEFINE[1]), 0])
	*%under12();
    
	translate([64, -6, 0])
	rotate([0, -90, 0])
    under4();

	rotate([0, -90, 0])
	under8();

	translate([-32, 16, thick])
	rotate([180, 0, 90])
	under10();

	translate([-16, 16, thick])
	rotate([180, 0, 90])
	under11();
}

//under12_assemble();
under12_print();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\under#38.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\under#38.scad
*/