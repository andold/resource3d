include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = [
	["prototype",							"프로토타입: 밑판 위판 귀퉁이 일부만 출력, prototype"],
	["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],

//	for (cx = default04()) cx,
//	for (cx = default05()) cx,
//	for (cx = default10()) cx,

	["reserved", "끝"]
];
 
//	프로토타입: 밑판 위판 귀퉁이 일부만 출력
module epaper_part13a(map) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	marginPrototypeJoint = get(map, "prototype.joint.margin", DEFAULT);	//	연결 부속을 들어내는 크기, marginPrototypeJoint
	intersection() {
		epaper_part11(map);
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([marginPrototypeJoint.x, marginPrototypeJoint.y, 100]);
	}
}

module epaper_part13b(map) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	marginPrototypeJoint = get(map, "prototype.joint.margin", DEFAULT);	//	연결 부속을 들어내는 크기, marginPrototypeJoint
	
	intersection() {
		epaper_part12(map);
		translate([-EPSILON, -EPSILON, -EPSILON])
		cube([marginPrototypeJoint.x, marginPrototypeJoint.y, 100]);
	}
}

module epaper_part13(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));
	
	marginPrototypeJoint = get(map, "prototype.joint.margin", DEFAULT);	//	연결 부속을 들어내는 크기, marginPrototypeJoint

	epaper_part13a(map);
	translate([marginPrototypeJoint.x + 1, 0, 0])
	epaper_part13b(map);
}

module main() {
	epaper_part13();
}


module build(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	map = [
		["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
		["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],
		["under.panel.hole.ratio",			0.0,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
		
		"andold", ""
	];
	
	if (command == 0) {
		epaper_part13(map);
	} else if (command == 1) {
		epaper_part13a(map);
	} else if (command == 2) {
		epaper_part11(map);
	} else if (command == 3) {
		epaper_part13b(map);
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 0 : command);
