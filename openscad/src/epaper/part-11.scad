include	<../common/constants.scad>
include	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-05.scad>	//	디스플레이 패널을 덮는 위판
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것

//	연결 부속이 장착된 위판
DEFAULT = default();

module epaper_part11(map = DEFAULT) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	hightUpperPanel = get(map, "upper.panel.hight", DEFAULT);	//	높이 of 디스플레이 패널을 덮는 위판, hightUpperPanel
	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);
	snsize = 8;
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	carve(snumber, size = snsize, offset = snsize / 10, halign = "center", rotate = [0, 0, 0], translate = [sizeOutterUnderPanel.x / 2, snsize / 2, hightUpperPanel], preview = !true) {
		epaper_part05(map);
	}
	translate([0, 0, hightUpperPanel])
	epaper_part10(map);
}

module main() {
	hr();

	epaper_part11();

	hr();
}

main();
