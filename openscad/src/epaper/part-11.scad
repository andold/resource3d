include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	디스플레이 패널을 덮는 위판
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것

DEFAULT = [
	["part11",							"연결 부속이 장착된 위판"],
	["size.connector",		[0.8, 12, 3 - 0.4 - 0.1, 0.4, 0.4],	"연결 부속 크기, sizeConnector"],
	["margin.connector",	[3, 8, 0],							"연결 부속이 위치하는 모서리로부터의 여백, marginConnector"],
	
	for (cx = default05())	cx,

	["reserved", "끝"]
];

//	연결 부속이 장착된 위판
function PART11(v = [
		[0.8, 12, 3 - 0.4 - 0.1, 0.4, 0.4, "연결 부속 크기, sizeConnector"],
		[3, 8, 0, "연결 부속이 위치하는 모서리로부터의 여백, marginConnector"],
		"연결 부속이 장착된 위판"
	]) = [
		PART05(),
		v
];

module epaper_part_11(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));

	hightUpper = get(map, "part05.hight", DEFAULT);
	
	echo(str(parent_module(0), ".", parent_module(1)), hightUpper = hightUpper);

	epaper_part05();
	translate([0, 0, hightUpper])
	epaper_part_10();
}

module main() {
	hr();

	epaper_part_11();

	hr();
}

main();
