include	<../common/constants.scad>
use	<../common/library.scad>
use <common.scad>
use <collect-default.scad>

//	패널 밑에 받치는 밑판
COLOR = [0.8, 0.4, 0.3, 1];
DEFAULT = default();

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

	$fn = $preview ? 5 : 32;
	//	for loop가 있는 곳에서 낙인작업(carve)을 하면 오래 걸린다.
	carve(description, size = 0.5, offset = 0.01, rotate = [180, 0, 0], preview = !true, translate = [radiusUnderPanelHole * 1.5, -radiusUnderPanelHole * 2, 0])
	for (cx = [0:counts.x - 1]) {
		for (cy = [0:counts.y - 1]) {
			translate([cx * (radiusUnderPanelHole * 2 + delta.x) + radiusUnderPanelHole, cy * (delta.y + radiusUnderPanelHole * 2) + radiusUnderPanelHole, -EPSILON])
			planeCylinder(sizeInnerUnderPanel.z + EPSILON * 2, radiusUnderPanelHole, radiusUnderPanelHole, female = true);
		}
	}
}

//	밑판
module epaper_part04a(map) {
	assert(!is_undef(map));

	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	railUnderPanel = get(map, "under.panel.rail", DEFAULT);
	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	모서리 대패의 반경
	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
	sizeInnerUnderPanel = calculateSizeInnerUnderPanel(map, DEFAULT);
	description = str(parent_module(0), "\nunder.panel",
					"\nsizeOutterUnderPanel: ", sizeOutterUnderPanel,
					"\ndisplay.panel.size: ", sizeDisplayPanel,
					"\nunder.panel.rail: ", railUnderPanel);

	carve(description, size = 1, rotate = [180, 0, 0], translate = [sizeUnderPanelHill.x + 4, -sizeUnderPanelHill.y - 4, 0], offset = 0.01, preview = false) {
		{
			difference() {
				//	통짜
				color(COLOR)
				cube([sizeOutterUnderPanel.x, sizeOutterUnderPanel.y, heightUnderPanel]);

				//	구멍
				translate([railUnderPanel.x, railUnderPanel.y, 0])
				epaper_part04a1(map);	//	구멍
			}
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

	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이

	sizeDisplayConnector = get(map, "display.connector.size", DEFAULT);
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기
	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT);	//	여백, 밑판과 화면 부품 사이의 여유 공간
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);

	sizeHold = [
		sizeDisplayConnector.x + marginDisplayPanel.x * 2,
		sizeDisplayConnector.y + marginDisplayPanel.y,
		heightUnderPanel + marginDisplayPanel.z
	];

	translate([
		sizeUnderPanelHill.x + marginDisplayConnector.x,
		-(sizeDisplayConnector.y - sizeUnderPanelHill.y),
		(-EPSILON)
	])
	cube(sizeHold);
}

//	아래판 전체
module epaper_part04d(map) {
	assert(!is_undef(map));

	//	모서리 대패 적용해 보자
	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	모서리 대패의 반경
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
	base = sizeOutterUnderPanel - [radiusUnderPanelCornerPlane * 2, radiusUnderPanelCornerPlane * 2, radiusUnderPanelCornerPlane];
	
	$fn = 16;
	intersection() {
		minkowski() {
			translate([radiusUnderPanelCornerPlane, radiusUnderPanelCornerPlane, radiusUnderPanelCornerPlane])
			cube(base);
			sphere(radiusUnderPanelCornerPlane);
		}
		union() {
			epaper_part04a(map);	//	1층
			epaper_part04b(map);	//	2층
		}
	}
}

//	커넥터 구멍 뚤기
module epaper_part04e(map) {
	assert(!is_undef(map));

	color(COLOR)
	difference() {
		epaper_part04d(map);
		epaper_part04c(map);
	}
}

module epaper_part04(map = DEFAULT) {
	assert(!is_undef(map));

	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", DEFAULT);
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT);
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
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
	size = 1;
	position = [
		radiusUnderPanelHole * 1.5,
		-sizeOutterUnderPanel.y + size * linecount(description) * 1.5,
		0
	];
	carve(description, size = size, offset = 0.01, rotate = [180, 0, 0], preview = !true, translate = position)
	epaper_part04e(map);
}

//	모든 지시선
module epaper_part04_note(map) {
	assert(!is_undef(map));
	
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
	lineindex([0, 0], sizeOutterUnderPanel);

	railUnderPanel = get(map, "under.panel.rail", DEFAULT);	//	밑판 최외곽 최소 너비 railUnderPanel
	lineindex(railUnderPanel, sizeOutterUnderPanel);

	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	모서리 대패의 반경
	lineindex([radiusUnderPanelCornerPlane, radiusUnderPanelCornerPlane], sizeOutterUnderPanel);

	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기
	lineindex(sizeUnderPanelHill, sizeOutterUnderPanel);

	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT);	//	여백, 밑판과 화면 부품 사이의 여유 공간
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);	//	디스플레이 패널로부터의 상대적인 위치,여백
	lineindex(sizeUnderPanelHill + marginDisplayPanel + marginDisplayConnector, sizeOutterUnderPanel, true, false, false);

	radiusUnderPanelHole = get(map, "under.panel.hole.radius", DEFAULT);	//	밑판 구멍내는 원의 크기, radiusUnderPanelHole
	lineindex(railUnderPanel + [radiusUnderPanelHole, radiusUnderPanelHole], sizeOutterUnderPanel);
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
		map = [["under.panel.hole.ratio",			0.4,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04e(map);	//	모서리 대패를 적용하기 위해, 굴곡만큼 작게 만들기
		epaper_part04_note(DEFAULT);
	} else if (command == 9) {
		map = [["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"]];
		epaper_part04(map);
	} else if (command == 10) {
		planeCylinder();
	} else {
		echo("NOT SUPPORTED");
	}
	
	hr();
}

main(is_undef(command) ? 9 : command);
