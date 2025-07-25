include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	연결 부속, 수직 최대각도는 45도.
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
use <part-11.scad>	//	연결 부속이 장착된 위판

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = [
	for (cx = default04()) cx,
	for (cx = default05()) cx,
	for (cx = default10()) cx,
	
	["reserved", "끝"]
];

//	연결 부속이 파인 밑판
function PART12(v = PART04()) = PART11([v, PART05()]);

module epaper_part12(map = DEFAULT) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이, heightUnderPanel

	difference() {
		color(COLOR)
		epaper_part04(map);

		translate([0, 0, heightUnderPanel])
		mirror([0, 0, 1])
		epaper_part10(map, female = true);
	}
}

module epaper_part12a(map = DEFAULT) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	difference() {
		color(COLOR)
		epaper_part04(map);

		translate([0, 0, sizeOutterUnderPanel.z])
		mirror([0, 0, 1])
		epaper_part10(map, female = true);
	}
}

module main() {
	epaper_part12a();
}


module build(command = 0) {
	map = DEFAULT;
	
	if (command == 0) {
	} else if (command == 1) {
		epaper_part12a(map);
	} else if (command == 2) {
		epaper_part12(map);
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 2 : command);
