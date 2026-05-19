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
module	basis01_type_4_right() {
	top = topSize(PARAM_TOP);

	thick = DEFAULT_PARAM[0];
	margin = DEFAULT_PARAM[1];
	overlap = DEFAULT_PARAM[2];
	height = DEFAULT_PARAM[3];
	anglex = 0;
	angley = DEFAULT_PARAM[4];
	anglez = DEFAULT_PARAM[5];

	radious = thick;
	cut = 0.2;

	//	외경
	x = 200;
	y = 200;
	z = DEFAULT_PARAM[0] * 2;

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

	top = topSize(PARAM_TOP);

	thick = DEFAULT_PARAM[0];
	margin = DEFAULT_PARAM[1];
	overlap = DEFAULT_PARAM[2];
	height = DEFAULT_PARAM[3];
	anglex = 0;
	angley = DEFAULT_PARAM[4];
	anglez = DEFAULT_PARAM[5];

	radious = data["기초.두께"];
	cut = 0.2;

	//	외경
	x = 200;
	y = 200;
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

module basis01_type_4_left() {
	translate([200, 0, 0])
		mirror([1, 0, 0])	basis01_type_4_right();
}

module basis01_type_4_left00(data = DEFAULT) {
	translate([200, 0, 0])
		mirror([1, 0, 0])	basis01_type_4_right00(data);
}

module	basis01_type_4_assemble(data = DEFAULT) {
	top = topSize(PARAM_TOP);
	x = 200;
	y = 200;
	angle = 45;

	dy = y - top.y;
	degree = atan(dy / (x - dy));

	basis2p(data)
	basis01_type_4_left00(data);

	basis1p(data)
	basis01_type_4_right00(data);

	translate([y * cos(angle), 0, 200])
		rotate([0, 45, 0])
		translate([top.y, 0, 0])
		rotate([0, 0, 90])
		%landscape(PARAM_TOP[0], PARAM_TOP[1], PARAM_TOP[2]);
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
	} else {
		wall00(DEFAULT);
		basis01_type_4_assemble0(DEFAULT);
	}

	echo(HR);
}

main(is_undef(command) ? 4 : command);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\#37-left.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#37.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\#37-right.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\basis#37.scad
*/