include	<../common/constants.scad>
use <../common/library_text.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
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
	["under.panel.corner.plane.radius",	3 / 4,		"모서리 대패의 반경, radiusUnderPanel"],
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

function linecount(string) = len(split(string, "\n")) + 1;

function calculateSizeOutterUnderPanel(map) = let(
	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", DEFAULT),
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT),
	heightUnderPanel = get(map, "under.panel.height", DEFAULT),	//	밑판의 높이
	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT),
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT),
	railUnderPanel = get(map, "under.panel.rail", DEFAULT),
	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT),

	reserved = 0
) [
	sizeDisplayPanel.x + (sizeUnderPanelHill.x + marginDisplayPanel.x) * 2,
	sizeDisplayPanel.y + (sizeUnderPanelHill.y + marginDisplayPanel.y) * 2,
	heightUnderPanel,
];
function calculateSizeInnerUnderPanel(map) = let(
	heightUnderPanel = get(map, "under.panel.height", DEFAULT),	//	밑판의 높이
	railUnderPanel = get(map, "under.panel.rail", DEFAULT),
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map),

	reserved = 0
) [
	sizeOutterUnderPanel.x - railUnderPanel.x * 2,
	sizeOutterUnderPanel.y - railUnderPanel.y * 2,
	heightUnderPanel,
];
function calculateCount(map) = let(
	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", DEFAULT),
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT),
	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT),
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT),
	railUnderPanel = get(map, "under.panel.rail", DEFAULT),

	sizeInnerUnderPanel = calculateSizeInnerUnderPanel(map),

	areaBase = sizeInnerUnderPanel.x * sizeInnerUnderPanel.y,	//	내경 면적
	areaUnderPanelHole = PI * radiusUnderPanelHole * radiusUnderPanelHole,	//	원의 면적
	county = floor(sqrt(areaBase / areaUnderPanelHole * ratioUnderPanelHole)),	//	원이 몇개 필요
	countx = floor(sizeInnerUnderPanel.x * county / sizeInnerUnderPanel.y),

	dummy = echo(parent_module(0), "ratioUnderPanelHole", ratioUnderPanelHole, "sizeInnerUnderPanel", sizeInnerUnderPanel, "countx", countx, "county", county),

	reserved = 0
) [
	countx,	//	countx
	county	//	county
];

//	밑판 구멍내기
module epaper_part04a1(map) {
	assert(!is_undef(map));

	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT);
	sizeInnerUnderPanel = calculateSizeInnerUnderPanel(map);
	counts = calculateCount(map);
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

module epaper_part_04a_note(v) {
//	echo("밑판 수치 표시", str(parent_module(0), "(", v[0][0], ")"));

	assert(!is_undef(v));

	s4 = v[0][0];		//	전체 외경
	height = v[0][2].z;	//	밑판의 높이
	margin = v[0][6];	//	밑판 최외곽 최소 너비
	radius = v[0][5][0];	//	모서리 대패의 반경
	size = [s4.x - radius * 2, s4.y - radius * 2, height - radius];
	fs = min(size);
//	echo(s4 = s4, height = height, margin = margin, radius = radius);

	//	가로
	translate([0, -NOTE_MARGIN, size.z])
	notate([size.x, fs]);

	//	세로
	translate([-NOTE_MARGIN, 0, size.z])
	notate([fs, size.y]);

	translate([-NOTE_MARGIN, 0, 0])
	rotate([90, 0, 0])
	notate([fs, size.z]);
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
	note(description, size = 1, rotate = [180, 0, 0], translate = [sizeUnderPanelHill.x, -sizeUnderPanelHill.y, 0], offset = 0.01, preview = false) {
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
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map);

	//	색상을 밑판보다 진하게
	cdelta = 0.1;
	ccolor = [COLOR[0] - cdelta, COLOR[1] - cdelta, COLOR[2] - cdelta, COLOR[3]];

	translate([0, 0, heightUnderPanel]) {
		// 아래
		translate([0, 0, 0])
		color(ccolor)
		cube([sizeOutterUnderPanel.x, sizeUnderPanelHill.y, sizeOutterUnderPanel.z]);

		//	위
		translate([0, sizeOutterUnderPanel.y - sizeUnderPanelHill.y, 0])
		color(ccolor)
		cube([sizeOutterUnderPanel.x, sizeUnderPanelHill.y, sizeOutterUnderPanel.z]);

		//	왼쪽
		translate([0, 0, 0])
		color(ccolor)
		cube([sizeUnderPanelHill.x, sizeOutterUnderPanel.y, sizeOutterUnderPanel.z]);

		//	오른쪽
		translate([sizeOutterUnderPanel.x - sizeUnderPanelHill.x, 0, 0])
		color(ccolor)
		cube([sizeUnderPanelHill.x, sizeOutterUnderPanel.y, sizeOutterUnderPanel.z]);
	}
}

//	아래쪽에 구멍내는 거, 연결선 빠져 나가는 구멍
module epaper_part04c(v) {
//	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	upstairs = v[0][3];	//	둔덕의 크기
	marginActive = v[0][4];	//	패널 확보 여백
	size3 = v[2][0];	//	연결단자의 크기
	margin = v[2][1];	//	연결단자의 위치
	height = v[0][2].z;	//	밑판의 높이

	size = [
		size3.x + marginActive.x * 2,
		upstairs.y + marginActive.y + EPSILON,
		height + marginActive.z + EPSILON
	];
	fs = min(size);

	translate([0, -EPSILON, -EPSILON])
	cube(size);

	translate([0, -NOTE_MARGIN+2, -EPSILON])
	notate([size.x, fs]);
}

//	아래판 전체
module epaper_part04d(map) {
	assert(!is_undef(map));

	epaper_part04a(map);	//	1층
	epaper_part04b(map);	//	2층
}

module epaper_part04(map = DEFAULT) {
	assert(!is_undef(map));

	radius = 1;
	margin = [0, 0, 0];
	upstairs = [1, 1, 1];
	
	$fn = $preview ? 4 : 16;
	difference() {
		translate([radius, radius, radius])
		minkowski() {
			epaper_part04d(map);
			color(COLOR)
			sphere(radius);
			notateH([margin.x, 2], up = false);
		}

/*
		translate([upstairs.x + margin.x, 0, 0])
		epaper_part04c(map);

		translate([0, -NOTE_MARGIN + 2, 0])	{
			notateH([upstairs.x, fs], up = false);
			translate([upstairs.x, 0, 0])	notateH([margin.x, fs], up = false);

			translate([psize.x - upstairs.x, 0, 0])	notateH([upstairs.x, fs], up = false);
			translate([psize.x - (upstairs.x + margin.x), 0, 0])	notate([margin.x, fs], up = false);
		}
*/
	}
}

module main(command = 0) {
	hr();
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
	} else if (command == 1) {
		epaper_part04a(DEFAULT);	//	밑판
	} else if (command == 2) {
		epaper_part04();
	} else if (command == 3) {
		epaper_part04a1(DEFAULT);	//	밑판 구멍내기
	} else if (command == 4) {
		epaper_part04b(DEFAULT);	//	위판
	} else if (command == 5) {
		epaper_part04d(DEFAULT);
	} else {
		echo("NOT SUPPORTED");
	}
	
	rotate([180, 0, 0])	epaper_part02();
	hr();
}

main(is_undef(command) ? 2 : command);
