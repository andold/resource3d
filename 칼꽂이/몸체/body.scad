use <MCAD/boxes.scad>
use <../상판/landscape.scad>
use <../기타/utils.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.2;

// 주요 상수
THICK = 4;
HEIGHT = 240;
HEIGHT_TOP = 128;
OVERLAP = 32;
OPACITY = 0.75;

function bodyTopSize()  = [landscapeSize()[0] + THICK, landscapeSize()[1] + THICK, HEIGHT_TOP];
function	bodyBottomSize() = [
	bodyTopSize()[0] + THICK,
	bodyTopSize()[1] + THICK,
	HEIGHT - bodyTopSize()[2] + OVERLAP];

module boardHold(x, y, z, dx = 16, dy = 0, countx = 2, county = 2) {
	echo(x, y, z, dx, dy, countx, county);
	w = (x - dx * 2 - z) / countx;
	h = (y - dy * 2 - z) / county;
	for (cw = [dx + z:w:x - (dx + z) * 2]) {
		for (ch = [dy + z:h:y - (dy + z) * 2]) {
			echo(w, h, cw, ch);
			translate([cw, ch, -1])	cube([w - z, h - z, z * 4], center = false);
		}
	}
}

module bulges(x = 128, y = 6, z = 4, count = 5) {
	r = y / 0.75 / 2;
	dx = (x - r * 2) / (count - 1);
	for (cx = [0: dx: x]) {
		translate([cx, 0, 0])	intersection() {
			translate([r, r * 2 - y, 0])	cylinder(z, r, r);
			cube([r * 2, r * 2, z]);
		}
	}
}
//
//rotate([90, 0, -90])	bulges();
//bodyTopFront();
//translate([164, 0, 0])	bodyTopSide();
module board(x = 160, y = 128, z = 4, even = false, dz = THICK * 2, count = 5) {
	echo("board", x, y, z, even, dz, count);
	union() {
		difference() {
			union() {
				cube([x, y, z]);
				if (even) {
				} else {
					translate([z / 2 * 3, y - dz, z])	rotate([90, 0, -90])	bulges(y - dz * 2, z * 2 * 0.75, z, count);
					translate([x - z / 2 * 3, dz, z])	rotate([90, 0, 90])		bulges(y - dz * 2, z * 2 * 0.75, z, count);
				}
			}
			
			// 면 조립부분 홈파기
			translate([-1024 + z / 2, -1, z / 2])	cube(1024);
			translate([x - z / 2, -1, z / 2])		cube(1024);
			boardHold(x, y, z, 12, 4, ceil(x / 48), floor(y / 64));

			if (even) {
				translate([z / 2, y - dz, z / 2])	rotate([0, 0, -90])	bulges(y - dz * 2, z * 2 * 0.75, z, count);
				translate([x - z / 2, dz, z / 2])	rotate([0, 0, 90])	bulges(y - dz * 2, z * 2 * 0.75, z, count);
			} else {
			}
		}
	}
}
//board(256, 128, 8, false, 16, 5);
// 조립시 바깥쪽
module bodyTopFront() {
	base = bodyTopSize();
	color("DarkKhaki", OPACITY)	board(base[0] + THICK, base[2], THICK, false);
}
//bodyTopFront();

// 조립시 안쪽
module bodyTopSide() {
	base = bodyTopSize();
	color("Blue", OPACITY)	board(base[1], base[2], THICK, true);
}
//bodyTopSide();

module bodyBottomFront() {
	base = bodyBottomSize();
	color("Fuchsia", OPACITY)	board(base[0] + THICK * 3, HEIGHT - base[2] + OVERLAP, THICK, false, OVERLAP);
}
//bodyBottomFront();
module compareFront() {
	bodyBottomFront();
	translate([THICK, HEIGHT - bodyTopSize()[2] + OVERLAP + 1, 0])	boardTopFront();
}
//compareFront();

module bodyBottomSide() {
	base = bodyBottomSize();
	color("MediumSlateBlue", OPACITY)	board(base[1] + THICK * 2,  HEIGHT - base[2] + OVERLAP, THICK, true, OVERLAP);
}
//bodyBottomSide();

module compareSide() {
	bodyBottomSide();
	translate([THICK, HEIGHT - bodyTopSize()[2] + OVERLAP + 1, 0])	boardTopSide();
}
//compareSide();

// 크기 제한으로 상하단으로 분리한다.
module bodyTop() {
	bodyTopFront();
	translate([0, bodyTopSize()[2] + 4, 0])	bodyTopSide();
}
//scale(HALF)	bodyTop();

module assempleBodyBottom(help = 8) {
	base = bodyBottomSize();

	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyBottomFront();
	translate([base[0] + THICK * 2, base[1] + THICK * 2 + help * 2, 0])	rotate([0, 0, 180])	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyBottomFront();
	translate([base[0] + THICK * 2, THICK / 2 + help, base[2]])	rotate([-90, 0, 90])	bodyBottomSide();
	translate([base[0] + THICK * 2, base[1] + THICK * 2 + help, 0])	rotate([0, 0, 180])	translate([base[0] + THICK * 2, THICK / 2, base[2]])	rotate([-90, 0, 90])	bodyBottomSide();
}
//assempleBodyBottom(0);

module bodyBottom() {
	bodyBottomFront();
	translate([bodyBottomSize()[0] + THICK * 4, 0, 0])	bodyBottomSide();
}

module assempleBodyTop(help = 8) {
	base = bodyTopSize();

	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyTopFront();
	translate([base[0] + THICK, base[1] + THICK + help + help, 0])	rotate([0, 0, 180])	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyTopFront();

	translate([base[0] + THICK, THICK / 2 + help, base[2]])		rotate([-90, 0, 90])		bodyTopSide();
	translate([base[0] + THICK, base[1] + THICK + help, 0])	rotate([0, 0, 180])	translate([base[0] + THICK, THICK / 2, base[2]])		rotate([-90, 0, 90])		bodyTopSide();
}
//assempleBodyTop(10);
module assempleBody(help = 8) {
	base = bodyTopSize();
	assempleBodyBottom(help);
	translate([THICK, THICK, HEIGHT])	assempleBodyTop(help);
//	translate([THICK * 2, THICK* 2, HEIGHT + HEIGHT_TOP + 8])	landscape();
}
//assempleBody(8);

module build() {
	//scale(HALF)	bodyTopFront();
	scale(HALF)	bodyTopSide();
//	translate([0, bodyTopSize()[2] + 4, 0])	bodyTopSide();
	//scale(HALF)	bodyTop();	scale(HALF)	translate([bodyTopSize()[0] + 16, 0, 0])	bodyTop();
	//scale(HALF)	bodyBottom();	scale(HALF)	translate([0, bodyBottomSize()[2] + 4, 0])	bodyBottom();
}
build();

//scale(HALF)	bodyTop();	scale(HALF)	translate([bodyTopSize()[0] + 16, 0, 0])	bodyTop();
//scale(HALF)	bodyBottom();	scale(HALF)	translate([0, bodyBottomSize()[2] + 4, 0])	bodyBottom();
//bodyBottomFront();
//bodyBottomSide();
//halfBodyTop();
//assempleBody();
