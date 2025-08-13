include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>

//	밑판의 외경을 계산
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

//	밑판에서 구멍을 내는 영역의 크기 계산
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

//	동그만 구멍의 가로 세로 몇개씩 내야하는지 계산
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

//	실린더에 모서리 대패질 기능을 추가한것
module planeCylinder(h = 1, r1 = 1, r2 = 1, rplane = 0, female = false) {
//	echo(str("", parent_module(0), ".", parent_module(1), "(", h, ", ", r1, ", ", r2, ", ", rplane, ", ", female, ")"), HR);
	assert(!is_undef(h));
	
	$fn = 16;
	if (rplane <= 0) {
		cylinder(h = h, r1 = r1, r2 = r2);
	} else {
		if (!female) {
			translate([0, 0, rplane]) {
				minkowski() {
					color("yellow")
					cylinder(h = h - rplane * 2, r1 = r1 - rplane, r2 = r2 - rplane);
					sphere(rplane);
				}
			}
		} else {
			//	under construction
			rotate_extrude()
			projection()
			rotate([-90, 0, 0])
			difference() {
				union() {
					cylinder(h = h, r1 = r1 + rplane, r2 = r2 + rplane);
				}

				translate([r1 + rplane, h, rplane])	rotate([90, 0, 0])	cylinder(h = h * 2, r1 = rplane, r2 = rplane);
				translate([r1 + rplane, h, h - rplane])	rotate([90, 0, 0])	cylinder(h = h * 2, r1 = rplane, r2 = rplane);
//				translate([-(r1 + rplane), h, h - rplane])	rotate([90, 0, 0])	cylinder(h = h * 2, r1 = rplane, r2 = rplane);
//				translate([-(r1 + rplane), h, rplane])	rotate([90, 0, 0])	cylinder(h = h * 2, r1 = rplane, r2 = rplane);
				
				big = max(r1, r2, h) * 3;
				translate([r1, -big / 2, rplane])	cube([big, big, h - rplane * 2]);
				translate([-big, -big / 2, -big / 2])	cube([big, big, big]);
			}
		}
	}
}

THICK_LINE_INDEX = 0.1;
//	수평선
module lineh(point, length) {
	assert(!is_undef(point));
	assert(!is_undef(point.x));
	assert(!is_undef(point.y));
	thick = THICK_LINE_INDEX;
	
	polygon([
		[point.x, point.y],
		[point.x + length, point.y],
		[point.x + length, point.y + thick],
		[point.x, point.y + thick]
	]);
}
//	수직선
module linev(point, length) {
	thick = THICK_LINE_INDEX;
	
	polygon([
		[point.x, point.y],
		[point.x, point.y + length],
		[point.x + thick, point.y + length],
		[point.x + thick, point.y]
	]);
}

//	직사각형(외경)의 지시선, 대칭, 축선에는 그리지 않는다.
module lineindex13(point, size, xsymmetry, ysymmetry) {
	padding = size / 10;
	
	if (point.x == 0 && point.y == 0) {
		linev([size.x, -padding.y], size.y + padding.y * 2);
		lineh([-padding.x, size.y], size.x + padding.x * 2);
	}
	if (point.x != 0) {
		linev([point.x, -padding.y], size.y + padding.y * 2);
		if (xsymmetry) {
			linev([size.x - point.x, -padding.y], size.y + padding.y * 2);
		}
	}

	if (point.y != 0) {
		lineh([-padding.x, point.y], size.x + padding.x * 2);
		if (ysymmetry) {
			lineh([-padding.x, size.y - (point.y)], size.x + padding.x * 2);
		}
	}
}

//	직사각형(외경)의 지시선, 대칭
module lineindex(point, size, xsymmetry = true, ysymmetry = true, xysymmetry = true) {
	assert(!is_undef(point));
	assert(!is_undef(point.x));

	lineindex13(point, size, xsymmetry, ysymmetry);
	if (xysymmetry) {
		lineindex13([point.y, point.x], size, ysymmetry, xsymmetry);
	}
}

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

//	수평 안쪽에
module notateHI(v, title) {
	titleSize = v.y * len(title);

	arrow_left([(v.x - titleSize) / 2, v.y]);

	translate([v.x - (v.x - titleSize) / 2, 0])
	arrow_right([(v.x - titleSize) / 2, v.y]);

	translate([v.x / 2, 0])
	text(title, font = "D2Coding", size = v.y, halign = "center");
}

//	수평 바깥쪽에
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

//	수평
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

//	수직
module notateV(v, title, up, prefix) {
	translate([v.x, 0])
	rotate([0, 0, 90])
	notateH([v.y, v.x], title, up, prefix);
}

//	수치 표시, 화살표를 이용, v의 가로 세로 길이에 따라 수직 수평 구분.
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


// 테스트
module test1(r, thick, degree) {
	translate([0, 0, 0])
	rotate_extrude(angle = degree)
	difference() {
		circle(r);
		circle(r - thick);
		
		translate([-thick / 2 - NOZZLE, thick])
		circle(r);
		
		rotate([0, 0, -60])
		translate([-r, -r])
		square([r * 1, r * 2]);

		translate([-r, -r])
		square([r * 1, r * 2]);
	}
}
// 테스트
module test() {
	r = 32;
	thick = 4;
	
	translate([r * 4, 0, -r / 2 * 0])
	difference() {
		sphere(r);
		sphere(r - thick);
		translate([-r, -r, r / 2])
		cube([r * 2, r * 2, r * 2]);
	}

	translate([r * 0, 0, 0])
	rotate_extrude(angle = 360)
	difference() {
		circle(r);
		circle(r - thick);
		
		translate([0, thick])
		circle(r);
		
		rotate([0, 0, -135])
		translate([-r, -r])
		square([r * 1, r * 2]);

		translate([-r, -r])
		square([r * 1, r * 2]);
	}

	for (cx = [0:30:360]) {
		echo(cx);
		rotate([0, 0, cx])
		test1(r, thick, 20);
	}
}

//	사용법
module usage() {
	echo("usage:");
	echo();
	echo("	-D command=0 사용법");
	echo("	-D command=1 실린더에 모서리 대패질 기능을 추가한것");
	echo();
}

module main(command = 0) {
	if (command == 0) {
		usage();
	} else if (command == 1) {
		planeCylinder(32, 64, 60, 4, !false);
		
		color("yellow", 0.9)
		translate([0, 0, 40])
		difference() {
			translate([0, 0, 20])
			cube([150, 150, 40], center = true);
			planeCylinder(32, 64, 60, 4, true);
		}
	} else if (command == 2) {
	} else if (command == 3) {
		notate([13, 4]);
		arrow_left([8, 2]);
	} else if (command == 4) {
		test();
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 4 : command);