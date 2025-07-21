include	<../common/constants.scad>
use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-07.scad>	//	패널 밑에 받치는 밑판

//	연결 부속들만 네 귀퉁이에 위치시킨 것
function PART10(v = PART04()) = [[
		[0.8, 8, 3 - 0.4 - 0.1, 0.4, 0.4],
		[4, 16, 0],
		"PART10: 연결 부속들, 0: 연결 부속, 1: 여백"
	],
	for (cx = v) cx
];

//	기본 부속
module epaper_part_10a1(v, female) {
	echo(str(parent_module(0), ".", parent_module(1), ".", parent_module(1), "(", v[0], v[1][3], female, ")"));

	assert(!is_undef(v));

	sizeConnect = v[0][0];
	margin = v[0][1];
	upstairs = v[1][3];	//	밑판 2층 둔덕의 크기
//	marginExtra = upstairs.x - extraMargin(sizeConnect) - sizeConnect.x;	//	0.33409;
	marginExtra = extraMargin(sizeConnect);	//	0.33409;
	fs = 0.1;
	echo(parent_module(0), ".", parent_module(1), sizeConnect = sizeConnect, margin = margin, upstairs = upstairs, marginExtra = marginExtra, fs = fs);

	translate([margin.x - sizeConnect.x - marginExtra, margin.y, 0])
	epaper_part_07(sizeConnect, female);

	//translate([margin.x - sizeConnect.x - 0.33409, margin.y, 0])
	translate([0, margin.y - fs, 0])	notateH([margin.x - sizeConnect.x - marginExtra, fs], up = false);	//	가로

	translate([0, margin.y, sizeConnect.z + sizeConnect[4] + 0.1])
	notateH([margin.x, fs]);	//	가로 여백
	translate([margin.x - sizeConnect.x - marginExtra, 0, sizeConnect.z + sizeConnect[4] + 0.1])	notateV([fs, margin.y], up = false);	//	세로 여백
}
module epaper_part_10a2(v, female) {
	mirror([1, -1, 0])
	epaper_part_10a1(v, female);
}
module epaper_part_10a3(v, female) {
	epaper_part_10a1(v, female);
	epaper_part_10a2(v, female);
}
module epaper_part_10a4(v, female) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v[0], female, ")"));

	assert(!is_undef(v));

	size = v[1][0];
	translate([size.x, 0, 0])
	mirror([1, 0, 0])
	epaper_part_10a3(v, female);
}
module epaper_part_10a5(v, female) {
	epaper_part_10a3(v, female);
	epaper_part_10a4(v, female);
}
module epaper_part_10a(v, female) {
	epaper_part_10a5(v, female);

	s = v[2];
	translate([0, s.y, 0])
	mirror([0, 1, 0])
	epaper_part_10a5(v, female);
}
module background_10(v) {
	s5 = v[1];

	*%union() {
		//	%epaper_part_04();
		translate([0, 0, -s5.z])
		epaper_part_05();
	}
}

module epaper_part_10(v = PART10(PART04()), female = false) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v[0], female, ")"));

	assert(!is_undef(v));

	size = v[1][0];
	echo(parent_module(0), ".", parent_module(1), size = size);

	epaper_part_10a5(v, female);

	translate([0, size.y, 0])
	mirror([0, 1, 0])
	epaper_part_10a5(v, female);
}

module main() {
	hr();

	v = PART10(PART04());

	background_10(v);
	//epaper_part_10(v, true);
	translate([0, 0, -v[1][0].z])
	epaper_part_10();
//	epaper_part_10(v, female = true);
	epaper_part_10(female = true);
	//epaper_part_10(v);

	hr();
}

main();
