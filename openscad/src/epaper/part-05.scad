// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>

use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-08.scad>	//	모난 구석이 없는 네모 상자

COLOR = [0.4, 0.6, 0.2, 0.9];

//	디스플레이 패널을 덮는 위판
function PART05(v = PART04()) = [[
		[v[0][0].x, v[0][0].y, 1, 1/4],	//	밑판 크기 차용 + 굴곡의 반지름
		"디스플레이 패널을 덮는 위판"
	],
	for (cx = v) cx
];
/*
p5 = PART05();	//	디스플레이 패널을 덮는 위판
p5 = v[0];	//	디스플레이 패널을 덮는 위판
size5 = p5[0][0];	//	디스플레이 패널을 덮는 위판 외경
*/

module epaper_part_05(v = PART05()) {
	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	radius = v[0][1];
	size = v[0][0];
	fs = 2;

	color(COLOR)
	epaper_part_08(size);

	translate([0, -fs, size.z])	notate([size.x, fs]);
	translate([-fs, 0, size.z])	notate([fs, size.y]);
	translate([-fs, 0, 0])	rotate([90, 0, 0])	notateV([fs, size.z]);
}
module main() {
	hr();

	v = PART05();
	epaper_part_05(v);

	hr();
}

main();
