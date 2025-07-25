// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>

use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.

use <part-09.scad>	//	프로토타입, 테스트 출력용
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

DEFAULT = [
	["active.area",								"화소가 있는 영역, activeArea, part01"],
	["active.area.size",	[160.00, 96.00],	"크기, 화소가 있는 영역, sizeActiveArea"],
	["reserved", "끝"]
];

module epaper_display() {
	v = [PART05(), PART04()];

	epaper_part_11(PART11(v));

	s5 = v[0];
	echo(HR, s5);
	translate([-s5.x - 1, 0, 0])
	epaper_part_12(PART12(v));
}

module test() {
	$fn = 32;
	minkowski() {
//		translate([2, 2, 2])
		cube([2, 2, 2]);
		//cube([1, 1, 1]);
		translate([-1, 0, 0])
		sphere(1);
//		cylinder(r=1,h=0.1);
	}
}

module build(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		//	프로토타입, 연결 부속
		v1 = [8 * 3, 8 * 2 + 4, 8, 2];
		v2 = [0.8, 1.6, 4, 0.4, 0.4];
		v3 = [8, true];
		v = [v1, v2, v3];
		epaper_part_09(v);
	} else if (command == 1) {
		//	프로토타입, 연결 부속, 두꺼운것
		v1 = [8 * 3, 8 * 2 + 4, 8, 2];
		v2 = [0.8, 4, 1.6, 0.4, 0.4];
		v3 = [8, true];
		v = [v1, v2, v3];
		epaper_part_09(v);
	} else if (command == 2) {
		epaper_display();
	} else if (command == 3) {
		test();
	} else {
		echo("NOT SUPPORTED");
	}
}

// look build.bat script file
build(is_undef(command) ? 3 : command);
