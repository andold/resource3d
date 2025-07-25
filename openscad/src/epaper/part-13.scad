include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = [
	["margin.part13",		[16, 16, 0],	"연결 부속이 위치하는 곳을 기준으로 추가 여백, marginPart13"],
	["size.connector",		[0.8, 12, 3 - 0.4 - 0.1, 0.4, 0.4],	"연결 부속 크기, sizeConnector"],
	["margin.connector",	[3, 8, 0],		"연결 부속이 위치하는 모서리로부터의 여백, marginConnector"],
	["part05.hight",		2,			"높이, hightUpper"],

	["reserved", "끝"]
];
 
//	프로토타입: 밑판 위판 귀퉁이 일부만 출력

function PART13(v = PART10()) = [[
		PART10(),
		PART11(),
		PART12()
	],
	for (cx = v) cx
];

module epaper_part_13a(map) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));

	margin = max(get(map, "margin.connector", DEFAULT))
			+ max(get(map, "size.connector", DEFAULT))
			+ max(get(map, "margin.part13", DEFAULT)) ;
	echo(str(parent_module(0), ".", parent_module(1)), margin = margin);
	
	intersection() {
		epaper_part_11(map);
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([margin, margin, 100]);
	}
}

module epaper_part_13b(map) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));

	margin = max(get(map, "margin.connector", DEFAULT))
			+ max(get(map, "size.connector", DEFAULT))
			+ max(get(map, "margin.part13", DEFAULT)) ;
	echo(str(parent_module(0), ".", parent_module(1)), margin = margin);
	
	intersection() {
		epaper_part_12(map);
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([margin, margin, 100]);
	}
}

module epaper_part_13(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));
	
	margin = max(get(map, "margin.connector", DEFAULT))
			+ max(get(map, "size.connector", DEFAULT))
			+ max(get(map, "margin.part13", DEFAULT)) ;
	echo(str(parent_module(0), ".", parent_module(1)), margin = margin);

	epaper_part_13a(map);
	translate([margin + 1, 0, 0])
	epaper_part_13b(map);
}

module main() {
	epaper_part_13();
}


module build(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		main();
	} else if (command == 1) {
		main();
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 0 : command);
