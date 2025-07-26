include	<../common/constants.scad>
use <../common/library_text.scad>

// map에서 못찾으면 default에서 찾는다
function get(map, key, default) = let(
	result = search([key], map, 1, 0),
	spare = search([key], default, 1, 0)
)	is_num(result[0])
		? map[result[0]][1] 
		: is_num(spare[0]) ? default[spare[0]][1] : assert(false) "";

function linecount(string) = len(split(string, "\n")) + 1;

function calculateSizeOutterUnderPanel(map, default) = let(
	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", default),
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", default),
	heightUnderPanel = get(map, "under.panel.height", default),	//	밑판의 높이
	sizeDisplayPanel = get(map, "display.panel.size", default),
	sizeUnderPanelHill = get(map, "under.panel.hill.size", default),
	railUnderPanel = get(map, "under.panel.rail", default),
	marginDisplayPanel = get(map, "display.panel.margin", default),

	reserved = 0
) [
	sizeDisplayPanel.x + (sizeUnderPanelHill.x + marginDisplayPanel.x) * 2,
	sizeDisplayPanel.y + (sizeUnderPanelHill.y + marginDisplayPanel.y) * 2,
	heightUnderPanel + sizeUnderPanelHill.z,
];
function calculateSizeInnerUnderPanel(map, default) = let(
	heightUnderPanel = get(map, "under.panel.height", default),	//	밑판의 높이
	railUnderPanel = get(map, "under.panel.rail", default),
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, default),

	reserved = 0
) [
	sizeOutterUnderPanel.x - railUnderPanel.x * 2,
	sizeOutterUnderPanel.y - railUnderPanel.y * 2,
	heightUnderPanel,
];
function calculateCount(map, default) = let(
	ratioUnderPanelHole = get(map, "under.panel.hole.ratio", default),
	radiusUnderPanelHole = get(map, "under.panel.hole.radius", default),
	sizeDisplayPanel = get(map, "display.panel.size", default),
	sizeUnderPanelHill = get(map, "under.panel.hill.size", default),
	railUnderPanel = get(map, "under.panel.rail", default),

	sizeInnerUnderPanel = calculateSizeInnerUnderPanel(map, default),

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

// A(x0, y0), B(x1, y1), C(x2, y2) 에서 A와 직선 BC 사이 거리 계산
function pointToLineDistance(x0, y0, x1, y1, x2, y2) =
    abs((x2 - x1)*(y1 - y0) - (x1 - x0)*(y2 - y1)) /
    sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));

//	가로 막대 긴거
module hr() {
	echo(HR);
}
module arrow_left(v) {
	leader = v.y / 32;	//	지시선 두께
	polygon([
		[0, 0],
		[leader, 0],
		[leader, v.y],
		[0, v.y]
	]);

	shaft = v.y / 24;	//	화살대 두께
	polygon([
		[0,		v.y / 2],
		[v.y,	0],
		[v.y,	v.y / 2 - shaft],
		[v.y,	v.y / 2 + shaft],
		[v.y,	v.y],

		[v.x,	v.y / 2 - shaft],
		[v.x,	v.y / 2 + shaft]
	],
	paths=[[0, 1, 2, 5, 6, 3, 4]]);
}
module arrow_right(v) {
	translate(v)
	rotate([0, 0, 180])
	arrow_left(v);
}
module arrow_up(v) {
	translate([0, v.y])
	rotate([0, 0, -90])
	arrow_left([v.y, v.x]);
}
module arrow_down(v) {
	translate([v.x, 0])
	rotate([0, 0, 90])
	arrow_left([v.y, v.x]);
}

module notateHI(v, title) {
	titleSize = v.y * len(title);

	arrow_left([(v.x - titleSize) / 2, v.y]);

	translate([v.x - (v.x - titleSize) / 2, 0])
	arrow_right([(v.x - titleSize) / 2, v.y]);

	translate([v.x / 2, 0])
	text(title, font = "D2Coding", size = v.y, halign = "center");
}
module notateHO(v, title) {
	titleSize = v.y * len(title);
	arrowSize = v.y * 3;

	translate([-arrowSize, 0])
	arrow_right([arrowSize, v.y]);

	translate([v.x, 0])
	arrow_left([arrowSize, v.y]);

	translate([v.x / 2, 0])
	text(title, font = "D2Coding", size = v.y, halign = "center");
}
module notateH(v, title, up, prefix) {
	prefixSafe = is_undef(prefix) ? "" : prefix;
	titleDetail = is_undef(title) ? str(prefixSafe, v.x, "mm") : title;
	titleShort = is_undef(title) ? str(prefixSafe, v.x) : title;
	titleDetailSize = v.y * len(titleDetail);
	titleShortSize = v.y * len(titleShort);
	
	arrowSize = v.y * 3;

	titleSafe = is_undef(title) ? str(v.x) : title;
	upSafe = is_undef(up) ? true : false;
	%linear_extrude(height = EPSILON) {
		if (v.x >= (arrowSize * 2 + titleDetailSize)) {
			// 화살표, 단위까지 충분히 들어간다
			notateHI(v, titleDetail);
		} else if (v.x >= (arrowSize * 2 + titleShortSize)) {
			// 화살표는 들어갈 수 있으나, 단위까지는 못 들어간다
			notateHI(v, titleShort);
		} else if (v.x >= titleDetailSize) {
			//	화살표는 못들어가나, 단위는 들어간다
			notateHO(v, titleDetail);
		} else if (v.x >= titleShortSize) {
			//	화살표는 못들어가나, 수치는 들어간다
			notateHO(v, titleShort);
		} else {
			// 바깥에 표시해야 한다
			notateHO(v, "");
			if (upSafe) {
				translate([v.x / 2, v.y])
				text(titleDetail, font = "D2Coding", size = v.y, halign = "center");
			} else {
				translate([v.x / 2, -v.y])
				text(titleDetail, font = "D2Coding", size = v.y, halign = "center");
			}
		}
	}
}
module notateV(v, title, up, prefix) {
	translate([v.x, 0])
	rotate([0, 0, 90])
	notateH([v.y, v.x], title, up, prefix);
}
module notate(v, title, up, prefix) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", v, title, up, prefix, ")"));

	assert(!is_undef(v));
	assert(!is_undef(v[1]));

	if (v.x > v.y) {
		notateH(v, title, up, prefix);
	} else {
		notateV(v, title, up, prefix);
	}
}
module test() {
	// 테스트
	x0 = 2; y0 = 2;    // 점 A
	x1 = 0; y1 = 0;    // 점 B
	x2 = 4; y2 = 0;    // 점 C

	distance = pointToLineDistance(x0, y0, x1, y1, x2, y2);
	hr();
	echo("A에서 BC까지의 거리: ", distance);
	hr();
}
module main() {
	SHORT = 20;
	//notate([32, 16], str(32, "mm"));
	//notateH([3, 4]);
	notate([13, 4]);
	arrow_left([8, 2]);

	test();
}

main();