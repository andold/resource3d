// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
include	<../common/library_text.scad>

use <common.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-06.scad>	//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
use <part-08.scad>	//	모난 구석이 없는 네모 상자

COLOR = [0.4, 0.6, 0.2, 0.9];
DEFAULT = [
	["part05",							"디스플레이 패널을 덮는 위판, upper"],
	["part05.hight",		1,			"높이, hightUpper"],
	["part05.radius",		1 / 4,		"모서리 굴곡의 반지름"],
	["margin.active.area",	[0.5, 0.5],	"안쪽 Active Area의 바깥쪽의 여백"],
	["margin.active.area.part06",	PART06()[2][1],		"안쪽 Active Area의 바깥쪽의 여백"],
	["size.active.area",			PART06()[3],		""],
	["size.display.panel",			PART06()[2][0],		""],
	["size.upstairs",				PART04()[0][3],		""],
	["size.part04",					PART04()[0][0],		""],
	["reserved", "끝"]
];
function default05() = DEFAULT;

p6 = PART06();

//	디스플레이 패널을 덮는 위판
function PART05(v = [1, 1/4, [0.5, 0.5], "(높이, 굴곡의 반지름, (화면 여백))"], p4 = PART04()) = let(
						size4 = p4[0][0]) [
		[size4.x, size4.y, v[0]],	//	계산된 크기
		v,	//	입력한 값 그대로 또는 디폴트값
		p4,	//	사용되었던 밑판 정보
		"디스플레이 패널을 덮는 위판"
];

//	Active Area를 확보하기 위해, 가운데 구멍 내는  것
module epaper_part_05a_deprecated(p5) {
	echo(str(parent_module(0), ".", parent_module(1), "(", p5, ")"));

	margin = p5[1][2];
//	echo(str(parent_module(0), ".", parent_module(1)), margin = margin);
	p6 = PART06();
	sizeActiveArea = p6[3];	//	"Active Area 실제 그림이 그려지는 화면 영역, sizeActiveArea"
//	echo(str(parent_module(0), ".", parent_module(1)), sizeActiveArea = sizeActiveArea);
	sizeDisplayPanel = p6[2][0];	//	"부품의 크기", "sizeDisplayPanel"],
 
	marginActiveArea = p6[2][1];	//	"Active Area의 상대적 위치 = 좌상단의 여백", "marginActiveArea"
//	echo(str(parent_module(0), ".", parent_module(1)), marginActiveArea = marginActiveArea);
	upstairs = p5[2][0][3];	//	"둔덕의 크기", "upstairs"
	echo(str(parent_module(0), ".", parent_module(1)), upstairs = upstairs);
	
	size = [
		sizeActiveArea.x + margin.x * 2,
		sizeActiveArea.y + margin.y * 2,
		100
	];
	
	translate([
		upstairs.x + marginActiveArea.x - margin.x,
//		sizeDisplayPanel.y - (sizeActiveArea.y + upstairs.y + marginActiveArea.y - margin.y),
		sizeDisplayPanel.y - sizeActiveArea.y,
		-1
	])
	cube(size);
}

module epaper_part_05c(map = DEFAULT) {
	marginActiveArea = get(map, "margin.active.area.part06", DEFAULT);
	sizeActiveArea = get(map, "size.active.area", DEFAULT);
	sizeDisplayPanel = get(map, "size.display.panel", DEFAULT);
	margin = get(map, "margin.active.area", DEFAULT);
	upstairs = get(map, "size.upstairs", DEFAULT);

	translate([
		upstairs.x + marginActiveArea.x - margin.x,
		sizeDisplayPanel.y - sizeActiveArea.y,
		-1
	])
	cube([
		sizeActiveArea.x + margin.x * 2,
		sizeActiveArea.y + margin.y * 2,
		100
	]);
}

module epaper_part05(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	height = get(map, "part05.hight", DEFAULT);
	radius = get(map, "part05.radius", DEFAULT);
	size04 = get(map, "size.part04", DEFAULT);
	size = [size04.x, size04.y, height];
	description = str(parent_module(0), "\nsize = ", size, "\nradius = ", radius);

	color(COLOR)
	carve([0, 0, 0], [1, 10, size.z], 0.01, true) {
		difference() {
			epaper_part_08([size.x, size.y, size.z, radius]);
			epaper_part_05c(map);
		}
		
		text0(description, 1);
	}
}

module epaper_part_05_deprecated(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	p5 = PART05(v);
	echo(str(parent_module(0), ".", parent_module(1)), p5 = p5);
	radius = p5[1][1];
	size = p5[0];
	fs = 2;

	color(COLOR)
	difference() {
		epaper_part_08([size.x, size.y, size.z, radius]);
		epaper_part_05a(p5);
	}

	translate([0, -fs, size.z])	notate([size.x, fs]);
	translate([-fs, 0, size.z])	notate([fs, size.y]);
	translate([-fs, 0, 0])	rotate([90, 0, 0])	notateV([fs, size.z]);
}
module main() {
	hr();
	epaper_part05();
	hr();
}

main();
