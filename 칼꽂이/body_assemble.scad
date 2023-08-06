use <top-plate.scad>
use <utils.scad>

ZERO = [0, 0, 0];
ONE = [1, 1, 1];

// 주요 상수
THICK = 4;
HEIGHT = 240;
HEIGHT_TOP = 64;
OVERLAP = 32;

function bodyAssembleTopSize()  = [topPlateSize()[0] + THICK * 2, topPlateSize()[1] + THICK * 2, HEIGHT_TOP];

// 몸통
module quartet(x, y, z, cx, cy) {
	translate([cx,		cy,		-1])	children();
	translate([x - cx,	cy,		-1])	children();
	translate([cx,		y - cy,	-1])	children();
	translate([x - cx,	y - cy,	-1])	children();
}
module board(x, y, z, even = false, dz = 4) {
	union() {
		difference() {
			union() {
				cube([x, y, z]);
			}
			
			// 면 조립부분 홈파기
			deep = even ? z : z / 2;
			translate([-1024 + deep, -1, z / 2])	cube(1024);
			translate([x - deep, -1, z / 2])	cube(1024);
			
			// 규칙적으로 구멍뚫기. 리트랙션을 줄이기 위해서 구멍은 없앤다. 넣더라도 원형대신 네모형태로 넣겠다
			/*
			for (cy=[z * 3:z * 3:(y - z * 3) / 2]) {
				for (cx=[z * 4:z * 3:(x - z * 3) / 2]) {
					quartet(x, y, z, cx, cy)	cylinder(h=z*3, r=z*1.25, center=true);
					//quartet(x, y, z, cx, cy)	cube([z * 2, z * 2, z * 4], center = true);
				}
			}
			*/
		}

		// 조립 가이드
		for (cy = [(even ? dz : dz + z):z * 2:y - z]) {
			translate([z / 2,					cy, 0])	cube([z * 2, z, z*2]);
			translate([x - (z / 2 + z * 2),	cy, 0])	cube([z * 2, z, z*2]);
		}
	}
}

// 조립시 바깥쪽
module boardTopFront() {
	base = bodyAssembleTopSize();
	board(base[0] + THICK, base[2], THICK, false);
}
//boardTopFront();

// 조립시 안쪽
module boardTopSide() {
	base = bodyAssembleTopSize();
	board(base[1], base[2], THICK, true);
}
//boardTopSide();

module bodyBottomFront() {
	base = bodyAssembleTopSize();
	board(base[0] + THICK * 3, HEIGHT - base[2] + OVERLAP, THICK, false, OVERLAP);
}
//bodyBottomFront();
module compareFront() {
	bodyBottomFront();
	translate([THICK, HEIGHT - bodyAssembleTopSize()[2] + OVERLAP + 1, 0])	boardTopFront();
}
//compareFront();

module bodyBottomSide() {
	base = bodyAssembleTopSize();
	board(base[1] + THICK * 2,  HEIGHT - base[2] + OVERLAP, THICK, true, OVERLAP);
}
//bodyBottomSide();

module compareSide() {
	bodyBottomSide();
	translate([THICK, HEIGHT - bodyAssembleTopSize()[2] + OVERLAP + 1, 0])	boardTopSide();
}
//compareSide();

// 크기 제한으로 상하단으로 분리한다.
module bodyTop() {
	boardTopFront();
	translate([0, bodyAssembleTopSize()[2] + 4, 0])	boardTopSide();
}
bodyTop();

module assempleBodyTop(help = 8) {
	base = bodyAssembleTopSize();
	color("red", 1.0)		translate([0, help, 0])			rotate([90, 0, 0])	boardTopFront();
	color("blue", 1.0)	translate([0, -base[1] - THICK, 0])	rotate([90, 0, 90])	boardTopSide();
	
	translate([base[0] + THICK, -base[1] -THICK*2- help, 0])	rotate([0, 0, 180])	{
		color("red", 1.0)		translate([0, help, 0])			rotate([90, 0, 0])	boardTopFront();
		color("blue", 1.0)	translate([0, -base[1] - THICK, 0])	rotate([90, 0, 90])	boardTopSide();
	}
}
//assempleBodyTop(0);

module assempleBodyBottom(help = 8) {
	base = bodyAssembleTopSize();
	color("red", 1.0)	translate([0, help, 0])							rotate([90, 0, 0])	bodyBottomFront();
	color("blue", 1.0)	translate([0, -base[1] - THICK * 3, 0])	rotate([90, 0, 90])	bodyBottomSide();
	
	translate([base[0] + THICK * 3, -base[1] - THICK * 4 - help, 0])	rotate([0, 0, 180])	{
		color("red", 1.0)	translate([0, help, 0])							rotate([90, 0, 0])	bodyBottomFront();
		color("blue", 1.0)	translate([0, -base[1] - THICK * 3, 0])	rotate([90, 0, 90])	bodyBottomSide();
	}
}
//assempleBodyBottom();
module bodyBottom() {
	bodyBottomFront();
	translate([0, HEIGHT - bodyAssembleTopSize()[2] + OVERLAP + 1, 0])	bodyBottomSide();
}
//bodyBottom();

module assempleBody(help = 8) {
	base = bodyAssembleTopSize();
	assempleBodyBottom(help);
	translate([THICK, -THICK, HEIGHT])	assempleBodyTop(help);
}
//assempleBody(0);

module body() {
	bodyTop();
	translate([bodyAssembleTopSize()[0] + THICK * 1 + 1, 0, 0])	bodyBottom();
}
//body();

module quater() {
	origin = bodyAssembleTopSize();
	base = [origin[0], origin[1], origin[2] / 2];
	board(base[0] + THICK, base[2], THICK, false);
	translate([0, base[2] + 8, 0])	board(base[1], base[2], THICK, true);
}
//quater();

