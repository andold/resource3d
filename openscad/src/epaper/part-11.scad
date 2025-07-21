include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	디스플레이 패널을 덮는 위판
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것

//	연결 부속이 장착된 위판
function PART11(v = [
		[0.8, 12, 3 - 0.4 - 0.1, 0.4, 0.4, "연결 부속 크기, sizeConnector"],
		[3, 8, 0, "연결 부속이 위치하는 모서리로부터의 여백, marginConnector"],
		"연결 부속이 장착된 위판"
	]) = [
		PART05(),
		v
];

module epaper_part_11(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	p5 = PART05();
	sizeUpper = p5[0];
	echo(str(parent_module(0), ".", parent_module(1)), sizeUpper = sizeUpper);
	v5 = v[2];	//	디스플레이 패널을 덮는 위판

	epaper_part_05();
	translate([0, 0, sizeUpper.z])	epaper_part_10();
}

module main() {
	hr();

	v = PART11();

	epaper_part_11(v);

	hr();
}

main();
v = [[1], [2, 3]];
w = [ for (cx = [[1], [2, 3]]) cx ];
echo(PART11()[1]);
echo(PART04()[1]);
