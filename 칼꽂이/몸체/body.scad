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
module assembleGuide(x = 16, p = 0.75, z = 4) {
	if (y > x / 4 * 3)	echo("y값이 너무 큽니다", x / 4 * 3, "이하로 설정해 주세요"); 
	r = x / 2;
	intersection() {
		translate([r, r * p, 0])	cylinder(z, r, r);
		translate([0, 0, 0])		cube([r * 2, r * 2, z]);
	}
}
//rotate([0, 0, -90])	assembleGuide();
module board(x = 160, y = 128, z = 4, even = false, dz = THICK * 2, count = 5) {
	echo(x, y, z, even, dz, count);
			if (!even) {
			//	translate([z,		dz,	z])
			//	translate([16,		16,	16])
				rotate([90, 0, -90])
				assembleGuide(16, 12, 8);
			}
	union() {
		difference() {
			union() {
				cube([x, y, z]);
				if (!even) {
					cr = z * 2;	//	반지름
					translate([z / 2 * 3, z * 2 + dz, z])	rotate([90, 0, -90])	assembleGuide(cr, 0.75, z);
					translate([x - z / 2, z * 2 + dz, z])	rotate([90, 0, -90])	assembleGuide(cr, 0.75, z);

					translate([z / 2 * 3, y / 2 + z, z])	rotate([90, 0, -90])	assembleGuide(cr, 0.75, z);
					translate([x - z / 2, y / 2 + z, z])	rotate([90, 0, -90])	assembleGuide(cr, 0.75, z);

					translate([z / 2 * 3, y - dz, z])	rotate([90, 0, -90])	assembleGuide(z * 2, 0.75, z);
					translate([x - z / 2, y - dz, z])	rotate([90, 0, -90])	assembleGuide(z * 2, 0.75, z);
				}
			}
			
			// 면 조립부분 홈파기
			deep = even ? z : z / 2;
			translate([-1024 + deep, -1, z / 2])	cube(1024);
			translate([x - deep, -1, z / 2])		cube(1024);
			

			boardHold(x, y, z, 12, 4, ceil(x / 48), floor(y / 64));

		}

		// 조립 가이드
		/*
		length = (y - dz * 2) / count;
		echo("length: ", length);
		for (cy = [(even ? dz + length : dz):length * 2:y - length]) {
			echo("guide", cy);
			//translate([z / 2 * 3,		cy + length / 2,	z * 2])	roundedBox(size=[z * 2, length, z * 3], radius = z / 2, sidesonly = true);
			translate([z / 2,		cy + length / 2,	z])	rotate([90, 0, -90])	assembleGuide(length / 2, length / 2 / 4 * 3, z);

			//translate([x - z / 2 * 3,	cy + length / 2,	z * 2])	roundedBox(size=[z * 2, length, z * 3], radius = z / 2, sidesonly = true);
			translate([x - z / 2,	cy,	z])	rotate([0, 0, 90])	assembleGuide(length / 2, length / 2 / 4 * 3, z);
		}
		*/
	}
}
board(256, 128, 8, false, 16, 5);
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
	translate([THICK * 2, THICK* 2, HEIGHT + HEIGHT_TOP + 8])	landscape();
}
//assempleBody(8);

//scale(HALF)	bodyTop();	scale(HALF)	translate([bodyTopSize()[0] + 16, 0, 0])	bodyTop();
//scale(HALF)	bodyBottom();	scale(HALF)	translate([0, bodyBottomSize()[2] + 4, 0])	bodyBottom();
//bodyBottomFront();
//bodyBottomSide();
//halfBodyTop();
//assempleBody();
