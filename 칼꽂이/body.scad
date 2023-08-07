use <MCAD/boxes.scad>
use <landscape.scad>
use <utils.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];

// 주요 상수
THICK = 4;
HEIGHT = 240;
HEIGHT_TOP = 64;
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
module board(x, y, z, even = false, dz = 4, count = 2) {
	union() {
		difference() {
			union() {
				cube([x, y, z]);
			}
			
			// 면 조립부분 홈파기
			deep = even ? z : z / 2;
			translate([-1024 + deep, -1, z / 2])	cube(1024);
			translate([x - deep, -1, z / 2])	cube(1024);
			
			boardHold(x, y, z, 12, 4, ceil(x / 48), floor(y / 64));
		}

		// 조립 가이드
		length = (y - dz) / count / 2;
		for (cy = [(even ? dz : dz + length):length * 2:y - length]) {
			translate([z / 2 * 3,		cy + length / 2,	z * 2])	roundedBox(size=[z * 2, length, z * 4], radius = z / 2, sidesonly = true);
			translate([x - z / 2 * 3,	cy + length / 2,	z * 2])	roundedBox(size=[z * 2, length, z * 4], radius = z / 2, sidesonly = true);
		}
	}
}
// 조립시 바깥쪽
module bodyTopFront() {
	base = bodyTopSize();
	color("DarkKhaki", OPACITY)	board(base[0] + THICK, base[2], THICK, false);
}
//bodyTopFront();

// 조립시 안쪽
module bodyTopSide() {
	base = bodyTopSize();
	color("PeachPuff", OPACITY)	board(base[1], base[2], THICK, true);
}
//bodyTopSide();

module bodyBottomFront() {
	base = bodyTopSize();
	color("Fuchsia", OPACITY)	board(base[0] + THICK * 3, HEIGHT - base[2] + OVERLAP, THICK, false, OVERLAP);
}
//bodyBottomFront();
module compareFront() {
	bodyBottomFront();
	translate([THICK, HEIGHT - bodyTopSize()[2] + OVERLAP + 1, 0])	boardTopFront();
}
//compareFront();

module bodyBottomSide() {
	base = bodyTopSize();
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
//bodyTop(0);

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
	translate([bodyBottomSize()[0] + THICK * 3, 0, 0])	bodyBottomSide();
}

module assempleBodyTop(help = 8) {
	base = bodyTopSize();

	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyTopFront();
	translate([base[0] + THICK, base[1] + THICK + help + help, 0])	rotate([0, 0, 180])	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyTopFront();

	translate([base[0] + THICK, THICK / 2 + help, base[2]])		rotate([-90, 0, 90])		bodyTopSide();
	translate([base[0] + THICK, base[1] + THICK + help, 0])	rotate([0, 0, 180])	translate([base[0] + THICK, THICK / 2, base[2]])		rotate([-90, 0, 90])		bodyTopSide();
}
//assempleBodyTop(16);
module assempleBody(help = 8) {
	base = bodyTopSize();
	assempleBodyBottom(help);
	translate([THICK, THICK, HEIGHT])	assempleBodyTop(help);
	translate([THICK * 2, THICK* 2, HEIGHT + HEIGHT_TOP + 8])	landscape();
}
//assempleBody(0);

//scale(HALF)	bodyTop();
scale(HALF)	bodyBottom();	translate([0, bodyBottomSize()[1] + 10, 0])	scale(HALF)	bodyBottom();
//bodyBottomFront();
//bodyBottomSide();
//halfBodyTop();
//assempleBody();
