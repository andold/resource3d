include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = [
	["part05",							"디스플레이 패널을 덮는 위판, upper"],
	["part05.hight",		1,			"높이, hightUpper"],
	["part05.radius",		1 / 4,		"모서리 굴곡의 반지름"],
	["margin.active.area",	[0.5, 0.5],	"안쪽 Active Area의 바깥쪽의 여백"],
	["margin.active.area.part06",	PART06()[2][1],		"안쪽 Active Area의 바깥쪽의 여백"],
	["size.active.area",			PART06()[3],		""],
	["size.display.panel",			PART06()[2][0],		""],
	["size.upstairs",				PART04()[0][3],		""],
	["size.part04",					PART04()[0][0],		""],
	["reserved", "끝"]
];

//	연결 부속이 파인 밑판
function PART12(v = PART04()) = PART11([v, PART05()]);

module epaper_part_12(v = PART12()) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	sizeLowerOutter = v[1][0][0][0];	//	"계산된 전체 외경, sizeLowerOutter"
	echo(parent_module(0), sizeLowerOutter = sizeLowerOutter);

	difference() {
		color(COLOR)
		epaper_part_04();

		translate([0, 0, sizeLowerOutter.z])
		mirror([0, 0, 1])
		epaper_part_10(female = true);
	}
}

module epaper_part_12a(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	sizeLowerOutter = v[1][0][0][0];	//	"계산된 전체 외경, sizeLowerOutter"
	echo(parent_module(0), sizeLowerOutter = sizeLowerOutter);

	difference() {
		color(COLOR)
		epaper_part_04();

		translate([0, 0, sizeLowerOutter.z])
		mirror([0, 0, 1])
		epaper_part_10(female = true);
	}
}

module main() {
	epaper_part_12a();
}


module build(command = 0) {
	if (command == 0) {
		main();
	} else if (command == 1) {
		main();
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 0 : command);
