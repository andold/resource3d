include	<../common/constants.scad>
use <../common/library_text.scad>
use <common.scad>
use <part-01.scad>	// 화소가 있는 영역, activeArea
use <part-02.scad>	//	주요 화면 부품. Display Panel, displayPanel
use <part-03.scad>
use <part-06.scad>	//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
use <part-07.scad>	//	연결 부속, 수직 최대각도는 45도.

//	패널 밑에 받치는 밑판
ID = "④";
COLOR = [0.8, 0.4, 0.3, 1];
DEFAULT = [
	["under.panel",									"패널 밑에 받치는 밑판, underPanel"],
	["under.panel.height",				2,			"밑판의 높이, heightUnderPanel"],
	["under.panel.hill.size",			[3, 3, 1],	"언덕의 크기, sizeUnderPanelHill"],
	["under.panel.corner.plane.radius",	3 / 4,		"모서리 대패의 반경, radiusUnderPanelCornerPlane"],
	["under.panel.rail",				[16, 16],	"밑판 최외곽 최소 너비 railUnderPanel"],
	["under.panel.hole",							"밑판 구멍"],
	["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
	["under.panel.hole.radius",			8,			"밑판 구멍내는 원의 크기, radiusUnderPanelHole"],
	["under.panel.size",							"계산된 크기. 다른 부품(패널)의 크기에 종속된다"],
	["under.panel.size.outter",			undef,		"계산된 전체 외경, sizeOutterUnderPanel"],
	["under.panel.size.inner",			undef,		"계산된 내경, sizeInnerUnderPanel"],

	["display.panel.margin",			[0.5, 0.5],	"여백, 밑판과 화면 부품 사이의 여유 공간, marginDisplayPanel"],

	for (cx = default01()) cx,
	for (cx = default02()) cx,
	for (cx = default03()) cx,

	["end", "끝"]
];
function default04() = DEFAULT;

//	밑판 구멍내기
module epaper_part04a1(map) {
//	echo(str("", parent_module(0), ".", parent_module(1), "(", map, ")"), HR);
	assert(!is_undef(map));

	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", DEFAULT);
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT);
	sizeInnerUnderPanel = calculateSizeInnerUnderPanel(map, DEFAULT);
	counts = calculateCount(map, DEFAULT);
	delta = [
		(sizeInnerUnderPanel.x - radiusUnderPanelHole * 2 * counts.x) / (counts.x - 1),
		(sizeInnerUnderPanel.y - radiusUnderPanelHole * 2 * counts.y) / (counts.y - 1)
	];
	description = str(parent_module(0), "\nunder.panel",
					"\nunder.panel.hole.radius: ", radiusUnderPanelHole,
					"\nsizeInnerUnderPanel: ", sizeInnerUnderPanel,
					"\ncounts: ", counts,
					"\ndelta: ", delta,
					"");
	echo(str("", parent_module(0), ".", parent_module(1))
		, ratioUnderPanelHole = ratioUnderPanelHole
		, radiusUnderPanelHole = radiusUnderPanelHole
		, sizeInnerUnderPanel = sizeInnerUnderPanel
		, counts = counts
		, delta = delta
		, description = description
	);

	$fn = $preview ? 5 : 32;
	//	for loop가 있는 곳에서 낙인작업(carve)을 하면 오래 걸린다.
	carve(description, size = 0.5, offset = 0.01, rotate = [180, 0, 0], preview = !true, translate = [radiusUnderPanelHole * 1.5, -radiusUnderPanelHole * 2, 0])
	for (cx = [0:counts.x - 1]) {
		for (cy = [0:counts.y - 1]) {
			translate([cx * (radiusUnderPanelHole * 2 + delta.x) + radiusUnderPanelHole, cy * (delta.y + radiusUnderPanelHole * 2) + radiusUnderPanelHole, -EPSILON])
			cylinder(sizeInnerUnderPanel.z + EPSILON * 2, radiusUnderPanelHole, radiusUnderPanelHole);
		}
	}
}

//	밑판
module epaper_part04a(map) {
	assert(!is_undef(map));

	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	railUnderPanel = get(map, "under.panel.rail", DEFAULT);
	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);
	sizeOutterUnderPanel = [	//	under.panel.size.outter
		sizeDisplayPanel.x + sizeUnderPanelHill.x * 2,
		sizeDisplayPanel.y + sizeUnderPanelHill.y * 2,
		heightUnderPanel
	];
	description = str(parent_module(0), "\nunder.panel",
					"\nsizeOutterUnderPanel: ", sizeOutterUnderPanel,
					"\ndisplay.panel.size: ", sizeDisplayPanel,
					"\nunder.panel.rail: ", railUnderPanel);
	note(description, size = 1, rotate = [180, 0, 0], translate = [sizeUnderPanelHill.x + 4, -sizeUnderPanelHill.y - 4, 0], offset = 0.01, preview = false) {
		difference() {
			//	통짜
			color(COLOR)
			cube(sizeOutterUnderPanel);

			//	구멍
			translate([railUnderPanel.x, railUnderPanel.y, 0])
			epaper_part04a1(map);	//	구멍
		}
	}
}

//	위판
module epaper_part04b(map) {
	assert(!is_undef(map));

	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);
	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	//	색상을 밑판보다 진하게
	cdelta = 0.1;
	ccolor = [COLOR[0] - cdelta, COLOR[1] - cdelta, COLOR[2] - cdelta, COLOR[3]];

	translate([0, 0, heightUnderPanel]) {
		// 아래
		translate([0, 0, 0])
		color(ccolor)
		cube([sizeOutterUnderPanel.x, sizeUnderPanelHill.y, sizeUnderPanelHill.z]);

		//	위
		translate([0, sizeOutterUnderPanel.y - sizeUnderPanelHill.y, 0])
		color(ccolor)
		cube([sizeOutterUnderPanel.x, sizeUnderPanelHill.y, sizeUnderPanelHill.z]);

		//	왼쪽
		translate([0, 0, 0])
		color(ccolor)
		cube([sizeUnderPanelHill.x, sizeOutterUnderPanel.y, sizeUnderPanelHill.z]);

		//	오른쪽
		translate([sizeOutterUnderPanel.x - sizeUnderPanelHill.x, 0, 0])
		color(ccolor)
		cube([sizeUnderPanelHill.x, sizeOutterUnderPanel.y, sizeUnderPanelHill.z]);
	}
}

//	아래쪽에 구멍내는 거, 연결선 빠져 나가는 구멍
module epaper_part04c(map) {
	assert(!is_undef(map));

	sizeDisplayConnector = get(map, "display.connector.size", DEFAULT);
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기
	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT);	//	여백, 밑판과 화면 부품 사이의 여유 공간
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	sizeHold = [
		sizeDisplayConnector.x,
		sizeDisplayConnector.y,
		sizeOutterUnderPanel.z + sizeUnderPanelHill.z
	];

	translate([
		sizeUnderPanelHill.x + marginDisplayPanel.x + marginDisplayConnector.x,
		-(sizeDisplayConnector.y - sizeUnderPanelHill.y - marginDisplayPanel.y) - 0,
		(-EPSILON)
	])
	cube(sizeHold);
}

//	아래판 전체
module epaper_part04d(map) {
	assert(!is_undef(map));

	epaper_part04a(map);	//	1층
	epaper_part04b(map);	//	2층
}

//	커넥터 구멍 뚤기
module epaper_part04e(map) {
	assert(!is_undef(map));

	difference() {
		epaper_part04d(map);

		epaper_part04c(map);
	}
}

module epaper_part04(map = DEFAULT) {
	assert(!is_undef(map));
	epaper_part04d(map);
}

//	수평선
module lineh(point, length) {
	thick = 0.1;
	
	polygon([
		[point.x, point.y],
		[point.x + length, point.y],
		[point.x + length, point.y + thick],
		[point.x, point.y + thick]
	]);
}
//	수직선
module linev(point, length) {
	thick = 0.1;
	
	polygon([
		[point.x, point.y],
		[point.x, point.y + length],
		[point.x + thick, point.y + length],
		[point.x + thick, point.y]
	]);
}

//	모든 지시선
module epaper_part04_note(map) {
	assert(!is_undef(map));
	
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map);
	railUnderPanel = get(map, "under.panel.rail", DEFAULT);	//	밑판 최외곽 최소 너비 railUnderPanel
	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	모서리 대패의 반경
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기
	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT);	//	여백, 밑판과 화면 부품 사이의 여유 공간
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);	//	디스플레이 패널로부터의 상대적인 위치,여백
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT);	//	밑판 구멍내는 원의 크기, radiusUnderPanelHole
/*
	["display.connector",			"디스플레이 패널에 붙어있는 커넥터, displayConnector, part03"],
	["display.connector.size",		[25.50, 24.00, 0.1],			"크기, sizeDisplayConnector"],
	["display.connector.margin",	[72.35, 0, 0],					"디스플레이 패널로부터의 상대적인 위치,여백, marginDisplayConnector"],
	["under.panel",									"패널 밑에 받치는 밑판, underPanel"],
	["under.panel.height",				2,			"밑판의 높이, heightUnderPanel"],
	["under.panel.hill.size",			[3, 3, 1],	"언덕의 크기, sizeUnderPanelHill"],
	["under.panel.corner.plane.radius",	3 / 4,		"모서리 대패의 반경, radiusUnderPanelCornerPlane"],
	["under.panel.rail",				[16, 16],	"밑판 최외곽 최소 너비 railUnderPanel"],
	["under.panel.hole",							"밑판 구멍"],
	["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
	["under.panel.hole.radius",			8,			"밑판 구멍내는 원의 크기, radiusUnderPanelHole"],
	["under.panel.size",							"계산된 크기. 다른 부품(패널)의 크기에 종속된다"],
	["under.panel.size.outter",			undef,		"계산된 전체 외경, sizeOutterUnderPanel"],
	["under.panel.size.inner",			undef,		"계산된 내경, sizeInnerUnderPanel"],

	["display.panel.margin",			[0.5, 0.5],	"여백, 밑판과 화면 부품 사이의 여유 공간, marginDisplayPanel"],
*/
	//	수직선
	//	외경
	linev([0, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([sizeOutterUnderPanel.x, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	모서리 대패의 반경
	linev([radiusUnderPanelCornerPlane, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([sizeOutterUnderPanel.x - radiusUnderPanelCornerPlane, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	언덕
	linev([sizeUnderPanelHill.x, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([sizeOutterUnderPanel.x - sizeUnderPanelHill.x, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	여백, 밑판과 화면 부품 사이의 여유 공간
	linev([sizeUnderPanelHill.x + marginDisplayPanel.x, -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([sizeOutterUnderPanel.x - (sizeUnderPanelHill.x + marginDisplayPanel.x), -railUnderPanel.y], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	디스플레이 패널로부터의 상대적인 위치,여백
	linev([
		sizeUnderPanelHill.x + marginDisplayPanel.x + marginDisplayConnector.x,
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([
		sizeOutterUnderPanel.x - (sizeUnderPanelHill.x + marginDisplayPanel.x + marginDisplayConnector.x),
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	밑판 최외곽 최소 너비 railUnderPanel
	linev([
		railUnderPanel.x,
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([
		sizeOutterUnderPanel.x - railUnderPanel.x,
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	//	밑판 구멍내는 원의 크기, radiusUnderPanelHole
	linev([
		railUnderPanel.x + radiusUnderPanelHole,
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	linev([
		sizeOutterUnderPanel.x - (railUnderPanel.x + radiusUnderPanelHole),
		-railUnderPanel.y
	], sizeOutterUnderPanel.y + railUnderPanel.y * 2);
	
	//	수평선
	//	외경
	lineh([-railUnderPanel.x, 0], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([-railUnderPanel.x, sizeOutterUnderPanel.y], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	모서리 대패의 반경
	lineh([-railUnderPanel.x, radiusUnderPanelCornerPlane], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([-railUnderPanel.x, sizeOutterUnderPanel.y - (radiusUnderPanelCornerPlane)], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	언덕
	lineh([-railUnderPanel.x, sizeUnderPanelHill.y], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([-railUnderPanel.x, sizeOutterUnderPanel.y - (sizeUnderPanelHill.y)], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	여백, 밑판과 화면 부품 사이의 여유 공간
	lineh([-railUnderPanel.x, sizeUnderPanelHill.y + marginDisplayPanel.y], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([-railUnderPanel.x, sizeOutterUnderPanel.y - (sizeUnderPanelHill.y + marginDisplayPanel.y)], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	디스플레이 패널로부터의 상대적인 위치,여백
	lineh([
		-railUnderPanel.x,
		sizeUnderPanelHill.y + marginDisplayPanel.y + marginDisplayConnector.y
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([
		-railUnderPanel.x,
		sizeOutterUnderPanel.y - (sizeUnderPanelHill.y + marginDisplayPanel.y + marginDisplayConnector.y)
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	밑판 최외곽 최소 너비 railUnderPanel
	lineh([
		-railUnderPanel.x,
		railUnderPanel.y
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([
		-railUnderPanel.x,
		sizeOutterUnderPanel.y - railUnderPanel.y
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	//	밑판 구멍내는 원의 크기, radiusUnderPanelHole
	lineh([
		-railUnderPanel.x,
		railUnderPanel.y + radiusUnderPanelHole
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
	lineh([
		-railUnderPanel.x,
		sizeOutterUnderPanel.y - (railUnderPanel.y + radiusUnderPanelHole)
	], sizeOutterUnderPanel.x + railUnderPanel.x * 2);
}

module main(command = 0) {
	hr();
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
	} else if (command == 1) {
		epaper_part04a(DEFAULT);	//	밑판
	} else if (command == 2) {
		map = [["under.panel.hole.ratio",			0.0,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04a1(map);	//	밑판 구멍내기
	} else if (command == 3) {
		epaper_part04a1(DEFAULT);	//	밑판 구멍내기
	} else if (command == 4) {
		epaper_part04b(DEFAULT);	//	위판
	} else if (command == 5) {
		map = [["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04d(map);
	} else if (command == 6) {
		map = [["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04e(map);	//	모서리 대패를 적용하기 위해, 굴곡만큼 작게 만들기
	} else if (command == 7) {
		epaper_part04_note(DEFAULT);
	} else if (command == 8) {
		map = [["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04e(map);	//	모서리 대패를 적용하기 위해, 굴곡만큼 작게 만들기
		epaper_part04_note(DEFAULT);
	} else {
		echo("NOT SUPPORTED");
	}
	
	hr();
}

main(is_undef(command) ? 8 : command);
