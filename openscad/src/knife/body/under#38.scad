include	<../../common/constants.scad>
include	<../knife-data.scad>
use <../../common/library.scad>
use <../../common/library_text.scad>
use <../../common/library_cube.scad>
use <basis#37.scad>
use <wall.scad>

//	①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳

/*
	치수는 knife-data.scad 의 data 맵을 쓴다 (예전 MEASURE / DEFINE 배열 대체)
		단 높이 1차(아래 단)	벽.위치.1.y
		단 높이 2차(턱 두께)	벽.위치.2.y
		지지대/다리 두께		다리.두께
		상판 크기				상판.크기
		옆으로 돌아가는 정도	기초.각도.옆
		내경(바깥쪽으로 감싸는 길이)	상판.크기.x + 다리.두께 * 2
		다리와 아래단까지의 거리	다리.거리
*/

// UNDER①
module under1(name = "UNDER①", data = DEFAULT) {
	echo("under1 처음: ");

	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"];

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
module under2(data = DEFAULT) {
	mirror([0,1,0])
	under1("UNDER②", data);
}

// UNDER③
module under3(data = DEFAULT) {
	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
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
module under4(data = DEFAULT) {
	echo("under4 처음: ");

	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"];

	tcos = thick * cos(angle);	//	두께 코사인
	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

    //	다리
    translate([0, -thick, 0])
	under1(data = data);

    translate([0, data["상판.크기"].x + thick * 3, 0])
	under2(data = data);

    translate([0, -thick, height1st - thick])
	under3(data = data);

	echo("under4 끝: ");
}

// UNDER⑤
module under5(name = "UNDER⑤", data = DEFAULT) {
	height1st = data["벽.위치.1"].y;
	thick = data["다리.두께"];
	cube_type_7([thick, thick, height1st]);
	note_type_2(name, [thick, thick, height1st]);
}

// UNDER⑥
module under6(name = "UNDER⑥", data = DEFAULT) {
	under5(name, data);
}

// UNDER⑦
module under7(name = "UNDER⑦", data = DEFAULT) {
	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];

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
module under8(data = DEFAULT) {
	echo("under8 처음: ");

	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"];

	tcos = thick * cos(angle);	//	두께 코사인
	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

	// 가까운 지지대 다리
	translate([0, tsin, 0])
	under5(data = data);

	//	먼 지지대 다리
	translate([0, ocos - thick, 0])
	under6(data = data);

	//	지지대간의 지지대
	translate([0, 0, height1st - thick])	//	바닥에 있는 걸 들어 올리기
	translate([0, tsin, 0])
	under7(data = data);

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
module under10(name = "UNDER⑩", data = DEFAULT) {
	thick = data["다리.두께"];
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"] + 8;
	tcos = thick * cos(angle);	//	두께 코사인

	under9(name, [distance + tcos, thick, thick]);
}

//	UNDER⑪
module under11(name = "UNDER⑪", data = DEFAULT) {
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"] + 8;
	osin = outter * sin(angle);	//	외경 사인

	under9(name, [distance  - osin - 12, thick, thick]);
}

//	UNDER⑫ = UNDER④ + UNDER⑧ + UNDER⑩ + UNDER⑪
module under12(name = "UNDER⑫", data = DEFAULT) {
	echo("under12 처음: ");

	height1st = data["벽.위치.1"].y;
	height2nd = data["벽.위치.2"].y;
	thick = data["다리.두께"];
	inner = (data["상판.크기"].x + data["다리.두께"] * 2);
	outter = inner + thick * 2;
	angle = data["기초.각도.옆"];
	distance = data["다리.거리"];

	tcos = thick * cos(angle);	//	두께 코사인
	tsin = thick * sin(angle);	//	두께 사인

	ocos = outter * cos(angle);	//	외경 코사인
	osin = outter * sin(angle);	//	외경 사인

	x = 0;
	y = 0;
	z = height1st + height2nd + thick;

	rotate([0, 0, data["기초.각도.옆"]])	//	회전(약간의 영점 흐트러짐)
	translate([0, data["다리.두께"], 0])	//	영점 조정
    under4(data = data);

	translate([-distance, 0, height1st - thick * 2])	//	바닥에 있는 걸 들어 올리기
	{
		translate([0, thick, 0])
		under10(data = data);

		translate([0, ocos - thick - 16, 0])
		under11(data = data);
	}

	translate([-distance, 0, 0])
	under8(data = data);

	echo("under12 끝: ");
}

module under12_assemble(data = DEFAULT) {
	%translate([32, 0, 0])
		rotate([0, 0, data["기초.각도.옆"]])
		translate([0, 0, (data["벽.위치.1"].y + data["벽.위치.2"].y)])
		basis01_type_4_assemble(data);
	*%wall(320, 320, 320);
	
	translate([220, 256 * sin(data["기초.각도.옆"]), 0])
	under12(data = data);
}
module under12_print(data = DEFAULT) {
	thick = data["다리.두께"];

	*%translate([32, 0, 0])
		rotate([0, 0, data["기초.각도.옆"]])
		translate([0, 0, (data["벽.위치.1"].y + data["벽.위치.2"].y)])
		basis01_type_4_assemble(data);
	
	translate([220, 256 * sin(data["기초.각도.옆"]), 0])
	*%under12(data = data);
    
	translate([64, -6, 0])
	rotate([0, -90, 0])
    under4(data = data);

	rotate([0, -90, 0])
	under8(data = data);

	translate([-32, 16, thick])
	rotate([180, 0, 90])
	under10(data = data);

	translate([-16, 16, thick])
	rotate([180, 0, 90])
	under11(data = data);
}

module main(command = 0) {
	echo(HR);
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
	} else if (command == 1) {
		under12_assemble();
	} else if (command == 2) {
		under12_print();
	} else if (command == 3) {
		%under12_assemble();
		under12_print();
	} else if (command == 4) {
		difference()
		{
			color("yellow")	offset(delta = 0.2) text0("ABC", language = "kr");
			color("black")	text0("ABC", language = "kr");
		}
	} else {
		echo("NOT SUPPORTED");
	}

	echo(HR);
}

main(is_undef(command) ? 3 : command);

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\under#38.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\under#38.scad
*/