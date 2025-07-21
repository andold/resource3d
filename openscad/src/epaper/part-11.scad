include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-05.scad>	//	디스플레이 패널을 덮는 위판
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것

//	연결 부속이 장착된 위판
function PART11(v = [PART04(), PART05()]) = [[
		[0.8, 8, 3 - 0.4 - 0.1, 0.4, 0.4],	//	연결 부속 크기
		[3, 4, 0],	//	연결 부속의 모서리부터의 여백
		"PART11: 연결 부속이 장착된 위판(PART05), 0: 연결 부속 크기, 1: 연결 부속의 모서리부터의 여백"
	],
	for (cx = v) cx
];
/*
margin = [ for (cx = [0:2]) v[0][1][cx] ];	//	연결 부속의 모서리부터의 여백
v4 = v[1];	//	패널 밑에 받치는 밑판
v5 = v[2];	//	디스플레이 패널을 덮는 위판
size5 = [ for (cx = [0:2]) v[2][0][cx] ];	//	디스플레이 패널을 덮는 위판 외경
*/
module background_11(v) {
}

module epaper_part_11_notate(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v[0][0], ")"));

	assert(!is_undef(v));

	margin = [ for (cx = [0:2]) v[0][1][cx] ];	//	연결 부속의 모서리부터의 여백
	size5 = [ for (cx = [0:2]) v[2][0][0][cx] ];	//	디스플레이 패널을 덮는 위판 외경
	fs = 2;
	echo(parent_module(0), ".", parent_module(1), margin = margin, size5 = size5);

	translate([0, margin.y - fs, size5.z])
	notate([margin.x, fs]);
}

module epaper_part_11(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v[0], ")"));

	assert(!is_undef(v));

	v5 = v[2];	//	디스플레이 패널을 덮는 위판
	size5 = [ for (cx = [0:2]) v[2][0][0][cx] ];	//	디스플레이 패널을 덮는 위판 외경
	echo(parent_module(0), ".", parent_module(1), v5 = v5, size5 = size5);

	epaper_part_05();
	translate([0, 0, size5.z])	epaper_part_10();
	
	epaper_part_11_notate(v);
}

module main() {
	hr();

	v = PART11([PART04(), PART05()]);

	background_11(v);
	epaper_part_11(v);

	hr();
}

main();
v = [[1], [2, 3]];
w = [ for (cx = [[1], [2, 3]]) cx ];
echo(PART11()[1]);
echo(PART04()[1]);
