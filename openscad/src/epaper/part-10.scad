include	<../common/constants.scad>
use	<../common/library.scad>
use <common.scad>
use <collect-default.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-07.scad>	//	연결 부속, 수직 최대각도는 45도.

//	연결 부속들만 네 귀퉁이에 위치시킨 것
DEFAULT = default();

//	결합 연결 부속
module epaper_part10a1(map, female) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", ", ", female, ")"));
	assert(!is_undef(map));

	sizeJoint = get(map, "joint.size", DEFAULT);	//	연결 부속 크기 정의, sizeJoint
	marginJoint = get(map, "joint.margin", DEFAULT);	//	여백, 연결 부속의 모서리로부터의 위치, marginJoint

	translate([marginJoint.x, marginJoint.y, 0])
	epaper_part07(sizeJoint, female = female);
}
module epaper_part10a2(map, female) {
	mirror([1, -1, 0])
	epaper_part10a1(map, female);
}
module epaper_part10a3(map, female) {
	epaper_part10a1(map, female);
	epaper_part10a2(map, female);
}
module epaper_part10a4(map, female) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", v[0], female, ")"));
	assert(!is_undef(map));

	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	translate([sizeOutterUnderPanel.x, 0, 0])
	mirror([1, 0, 0])
	epaper_part10a3(map, female);
}
module epaper_part10a5(map, female) {
	epaper_part10a3(map, female);
	epaper_part10a4(map, female);
}
module epaper_part10a(map, female) {
	epaper_part10a5(v, female);

	s = v[2];
	translate([0, s.y, 0])
	mirror([0, 1, 0])
	epaper_part10a5(v, female);
}

module epaper_part10(map = DEFAULT, female = false) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, female, ")"));
	assert(!is_undef(map));

	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	epaper_part10a5(map, female);

	translate([0, sizeOutterUnderPanel.y, 0])
	mirror([0, 1, 0])
	epaper_part10a5(map, female);
}

module main(command = 0) {
	hr();
	echo(str("", parent_module(0), "(", command, ")"));
	
	map = DEFAULT;
	female = false;

	if (command == 0) {
	} else if (command == 1) {
		epaper_part10a5(map, female);
	} else if (command == 2) {
		epaper_part10a3(map, female);
	} else if (command == 3) {
		epaper_part10a1(map, female);
	} else if (command == 4) {
		epaper_part10(map, female);
	} else if (command == 5) {
		epaper_part10(map, true);
	} else if (command == 6) {
		epaper_part10(map, false);
	} else if (command == 7) {
	} else if (command == 8) {
	} else {
		echo("NOT SUPPORTED");
	}
	
	hr();
}

main(is_undef(command) ? 5 : command);
