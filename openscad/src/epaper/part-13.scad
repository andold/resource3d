include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = default();
 
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

//	일부 시제품
module epaper_part13(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));
	
	marginPrototypeJoint = get(map, "prototype.joint.margin", DEFAULT);	//	연결 부속을 들어내는 크기, marginPrototypeJoint
	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);

	carve(snumber, size = 4, offset = 0.5, rotate = [180, 0, 0], translate = [4, -8, 0], preview = !true) {
		epaper_part13a(map);
	}

	translate([marginPrototypeJoint.x + 1, 0, 0])
	carve(snumber, size = 4, offset = 0.5, rotate = [180, 0, 0], translate = [8, -12, 0], preview = !true) {
		epaper_part13b(map);
	}
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	map = [
		["joint.size",				[0.8, 12, 2.5, 0.4, 0.4],		"연결 부속 크기 정의, sizeJoint"],
		["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
		["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],
		["under.panel.hole.ratio",			0.0,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
		
		"andold", ""
	];
	
	if (command == 0) {
		hr();
		echo("usage: ");
		hr();
	} else if (command == 1) {	//	일부 시제품 기본값
		epaper_part13(map = [
			["joint.size",				[0.8, 12, 2.5, 0.4, 0.4],		"연결 부속 크기 정의, sizeJoint"],
			["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
			["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],
			["under.panel.hole.ratio",			0.0,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
		
			"andold", ""
		]);
	} else if (command == 2) {	//	일부 시제품 두껍게
		epaper_part13(map = [
			["under.panel.hill.size",	[3, 3, 1.6],				"언덕의 크기, sizeUnderPanelHill"],
			["joint.size",				[1.2, 12, 2.5, 0.8, 0.8],	"연결 부속 크기 정의, sizeJoint"],
			["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
			["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],
			["under.panel.hole.ratio",			0.0,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
		
			"andold", ""
		]);
	} else if (command == 3) {
		epaper_part13b(map);
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 2 : command);
