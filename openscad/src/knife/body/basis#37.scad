/*
	지지대 45도 기울기면 더 좋을 듯 #29
*/
use <MCAD/boxes.scad>

include	<../../common/constants.scad>
include	<../knife-data.scad>
use	<../knife-before.scad>
use	<../under.scad>
use <../../common/library.scad>
use <../../common/library_cube.scad>

use <../top/landscape.scad>
use <wall.scad>

//	상판 외곽 크기: 상판.크기.z(두께), 상판.여백, 칼구멍.간격 으로 계산
function topSize(data = DEFAULT) = landscapeSize(undef, undef, undef, data);

//	text0() 함수 대체용, 회전 후 이동
module wtext1(string, size = 10, rotate = [0, 0, 0], translate = [0, 0, 0], font = "D2Coding", halign = "left", valign = "baseline", spacing = 1, hspacing = 1.5, direction = "ltr", language = "en", script = "latin") {
//	difference() {
//		offset(size / 10)	text1(string, size = size, rotate = rotate, translate = translate, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);
		text1(string, size = size, rotate = rotate, translate = translate, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);
//	}
}

module wrapper_cube_type_7(v, c = 0, title = "") {
	echo(str("", parent_module(0), ".", parent_module(1), "(", v, ", ", c, ")"));

	cube_type_7(v, c);
	
	color("yellow") {
		if (v.x > v.y) {
			vtitle = str(title, v.x, " x ", v.y, " x ", v.z, "mm / ", c, "mm");
			fs = fsproper(v.x, v.y, vtitle);
			wtext1(vtitle, fs, [0, 0, 0],	[v.y + c * 3, v.y - (fs + c * 3), v.z]);
			wtext1(vtitle, fs, [90, 0, 0],	[v.y + c * 3, 0, v.z - fs - c * 3]);
			wtext1(vtitle, fs, [180, 0, 0],	[v.y + c * 3, fs + c * 3, 0]);
			wtext1(vtitle, fs, [-90, 0, 0],	[v.y + c * 3, v.y, fs + c * 3]);
		} else {
			vtitle = str(title, v.y, " x ", v.x, " x ", v.z, " / ", c);
			fs = fsproper(v.y, v.x, vtitle);
			wtext1(vtitle, fs, [0, 0, 90],	[fs + c * 3,		v.x + c * 3, v.z]);
			wtext1(vtitle, fs, [90, 0, 90],	[v.x,				v.x + c * 3, v.z - fs - c * 3]);
			wtext1(vtitle, fs, [180, 0, 90],	[v.x - fs - c * 3,	v.x + c * 3, 0]);
			wtext1(vtitle, fs, [-90, 0, 90],	[0,					v.x + c * 3, fs + c * 3]);
		}
	}
}

/*
	오른쪽 지지대
*/
module	basis01_type_4_right(data = DEFAULT) {
	echo(str("", parent_module(0), ".", parent_module(1)));

	top = topSize(data);

	radious = data["기초.두께"];
	cut = data["기초.모따기"];

	//	외경
	x = data["기초.길이"];
	y = data["기초.중복"];
	z = data["기초.두께"] * 2;

	dy = y - top.y;
	diagonal = sqrt(dy * dy);	//	대각선
	degree = 180 - atan(dy / (x - dy));
	echo("degree", degree, atan(1));

	difference() {
		union() {
			cube_type_7([x, z, z], cut);
			translate([0, top.y - z, 0])
				cube_type_7([x, z, z], cut);
			translate([0, 0, 0])
				cube_type_7([z, top.y, z], cut);
			translate([x - z, 0, 0])
				cube_type_7([z, top.y, z], cut);

			translate([sqrt(2) * z / 2, top.y - sqrt(2) * z / 2, 0])
				rotate([0, 0, 45])
				cube_type_7([sqrt(2) * dy, z, z]);
			translate([x, top.y, 0])
				rotate([0, 0, degree])
				cube_type_7([sqrt(dy * dy + (x - dy) * (x - dy)), z, z]);

		}
		union() {
			translate([radious, radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([radious, top.y - radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([x - radious, top.y - radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([x - radious, radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([dy, y - radious * sqrt(2), z])
				rotate([0, 180, 0])
				casting_black_25(z);
		}
	}
}
module	basis01_type_4_right00(data) {
	echo(str("", parent_module(0), ".", parent_module(1), "(", data, ")"));

	top = topSize(data);

	radious = data["기초.두께"];
	cut = data["기초.모따기"];

	//	외경
	x = data["기초.길이"];
	y = data["기초.중복"];
	z = data["기초.두께"] * 2;

	dy = data["기초.중복"] - data["상판.크기"].y;
	diagonal = sqrt(dy * dy);	//	대각선
	degree = 180 - atan(dy / (x - dy));
	echo("degree", degree, atan(1));

	difference() {
		union() {
			wrapper_cube_type_7([x, z, z], cut, title = "지지대 1: ");
			translate([0, top.y - z, 0])
				wrapper_cube_type_7([x, z, z], cut, title = "지지대 2: ");
			translate([0, 0, 0])
				wrapper_cube_type_7([z, top.y, z], cut, title = "지지대 3: ");
			translate([x - z, 0, 0])
				wrapper_cube_type_7([z, top.y, z], cut, title = "지지대 4: ");

			color("blue", 0.5)
			translate([sqrt(2) * z / 2, top.y - sqrt(2) * z / 2, 0])
			rotate([0, 0, 45])
			{
				wrapper_cube_type_7([sqrt(2) * dy, z, z], title = "지지대 5: ");
			}

			translate([x, top.y, 0])
				rotate([0, 0, degree])
				wrapper_cube_type_7([sqrt(dy * dy + (x - dy) * (x - dy)), z, z], title = "지지대 6: ");

		}
		union() {
			translate([radious, radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([radious, top.y - radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([x - radious, top.y - radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([x - radious, radious, z])
				rotate([0, 180, 0])
				casting_black_25(z);
			translate([dy, y - radious * sqrt(2), z])
				rotate([0, 180, 0])
				casting_black_25(z);
		}
	}
}

//	오른쪽 지지대를 대칭시켜 왼쪽 지지대로 만든다
module basis01_type_4_left(data = DEFAULT) {
	translate([data["기초.길이"], 0, 0])
		mirror([1, 0, 0])	basis01_type_4_right(data);
}

module basis01_type_4_left00(data = DEFAULT) {
	translate([data["기초.길이"], 0, 0])
	mirror([1, 0, 0])
	basis01_type_4_right00(data);
}

//	상판(유령)을 지지대 위에 기울여 얹는다
module	basis3p(data = DEFAULT) {
	y = data["기초.중복"];
	angle = data["기초.각도.앞"];

	translate([y * cos(angle), 0, y])
		rotate([0, angle, 0])
		translate([topSize(data).y, 0, 0])
		rotate([0, 0, 90])
		children();
}

module	basis01_type_4_assemble(data = DEFAULT) {
	basis2p(data)
	basis01_type_4_left00(data);

	basis1p(data)
	basis01_type_4_right00(data);

	%basis3p(data)
	landscape(undef, undef, undef, data);
}

module	basis01_type_4_assemble0(data = DEFAULT) {
	basis0p(data)
	basis01_type_4_assemble(data);
}

module main(command = 0) {
	echo(HR);
	echo(str("", parent_module(0), "(", command, ")"));
	usage();

	if (command == 0) {
		basis01_type_4_left();
	} else if (command == 1) {
		basis01_type_4_right();
	} else if (command == 2) {
		basis01_type_4_right00(DEFAULT);
	} else if (command == 3) {
		wrapper_cube_type_7([200, 8, 8], 0.2);
		translate([0, 64, 0])
		wrapper_cube_type_7([8, 128, 32], 0.2);
	} else if (command == 4) {
		basis01_type_4_assemble(DEFAULT);
	} else if (command == 5) {
		basis2p(DEFAULT)
		basis01_type_4_left00(DEFAULT);
	} else if (command == 6) {
//		translate([200, 0, 0])
//		mirror([1, 0, 0])
		basis01_type_4_right00(DEFAULT);
	} else {
		wall00(DEFAULT);
		basis01_type_4_assemble0(DEFAULT);
	}

	echo(HR);
}

main(is_undef(command) ? 5 : command);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\#37-left.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#37.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\#37-right.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#37.scad
*/