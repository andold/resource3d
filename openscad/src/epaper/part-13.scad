include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

COLOR = [0.824, 0.412, 0.118, 0.9];

//	프로토타입: 밑판 위판 귀퉁이 일부만 출력

function PART13(v = PART10()) = [[
		PART10(),
		PART11(),
		PART12()
	],
	for (cx = v) cx
];

module epaper_part_13a(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	margin = max(v[0][0][0][1]);

	intersection() {
		epaper_part_11(v);
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([margin * 2, margin * 2, 100]);
	}
}

module epaper_part_13b(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	margin = max(v[0][0][0][1]);

	intersection() {
		epaper_part_12();
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([margin * 2, margin * 2, 100]);
	}
}

module epaper_part_13(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));
	
	margin = max(v[0][0][0][1]);

	epaper_part_13a(v);
	translate([margin * 2 + 1, 0, 0])
	epaper_part_13b(v);
}

module main() {
	v = PART13();

	epaper_part_13(v);
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
