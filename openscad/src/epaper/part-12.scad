include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판

COLOR = [0.824, 0.412, 0.118, 0.9];
//	연결 부속이 파인 밑판
function PART12(v = PART04()) = PART11([v, PART05()]);

module epaper_part_12(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	size4 = v[1][0];	//	밑판 외경
	echo(parent_module(0), size4 = size4);

	difference() {
		color(COLOR)
		epaper_part_04();

		translate([0, 0, size4.z])
		mirror([0, 0, 1])
		epaper_part_10(female = true);
	}
}

module main() {
	v = PART12();

	epaper_part_12(v);
}


module build(command = 0) {
	echo(str("", parent_module(0), ".", parent_module(1), "(", command, ")"));

	if (command == 0) {
		main();
	} else if (command == 1) {
		main();
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 0 : command);
