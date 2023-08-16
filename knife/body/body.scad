use <MCAD/boxes.scad>
use <../top/landscape.scad>
use <common.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.2;

// 주요 상수
prototype = true;
target = 1;
thick = 8;
margin = 8;
delta = 8;
marginy = 12;
paddingx = 24;
paddingy = 24;
count = 4;

HEIGHT = 240;
HEIGHT_TOP = 128;
OVERLAP = 32;
OPACITY = 0.75;

// 외경
function bodyTopSize(thick, margin, delta)  = [
	landscapeSize(thick, margin, delta)[0] + thick,
	landscapeSize(thick, margin, delta)[1] + thick,
	HEIGHT_TOP
];
function	bodyBottomSize(thick, margin, delta) = [
	bodyTopSize(thick, margin, delta)[0] + thick,
	bodyTopSize(thick, margin, delta)[1] + thick,
	HEIGHT - bodyTopSize(thick, margin, delta)[2] + OVERLAP
];

//module board(x = 160, y = 128, z = 8, female = false, marginy = 12, paddingx = 24, paddingy = 24, count = 5) {
module bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy, count) {
	base = bodyTopSize(thick, margin, delta);
	color("DarkKhaki", OPACITY)	board(base[0], base[2], thick, false, marginy, paddingx, paddingy, count);
}

// 조립시 안쪽
module bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy, count) {
	base = bodyTopSize(thick, margin, delta);
	color("Blue", OPACITY)	board(base[1], base[2], thick, true, marginy, paddingx, paddingy, count);
}

module bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy, count) {
	base = bodyBottomSize(thick, margin, delta);
	color("Fuchsia", OPACITY)	board(base[0] + THICK * 3, HEIGHT - base[2] + OVERLAP, THICK, false, OVERLAP);
}
//bodyBottomFront();
module compareFront(thick, margin, delta, marginy, paddingx, paddingy, count) {
	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy, count);
	translate([thick, HEIGHT - bodyTopSize(thick, margin, delta)[2] + OVERLAP + 1, 0])
		boardTopFront(thick, margin, delta, marginy, paddingx, paddingy, count);
}
//compareFront();

module bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy, count) {
	base = bodyBottomSize(thick, margin, delta, marginy, paddingx, paddingy, count);
	color("MediumSlateBlue", OPACITY)	board(base[1] + thick * 2,  HEIGHT - base[2] + OVERLAP, thick, true, OVERLAP, paddingx, paddingy, count);
}
//bodyBottomSide();

module compareSide(thick, margin, delta, marginy, paddingx, paddingy, count) {
	bodyBottomSide(thick, margin, delta);
	translate([thick, HEIGHT - bodyTopSize()[2] + OVERLAP + 1, 0])
		boardTopSide(thick, margin, delta, marginy, paddingx, paddingy, count);
}
//compareSide();

// 크기 제한으로 상하단으로 분리한다.
module bodyTop(thick, margin, delt, marginy, paddingx, paddingy, counta) {
	bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy, count);
	translate([0, bodyTopSize(thick, margin, delta)[2] + 4, 0])
		bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy, count);
}
//scale(HALF)	bodyTop();

module assempleBodyBottom(thick, margin, delta, marginy, paddingx, paddingy, count, help = 8) {
	base = bodyBottomSize(thick, margin, delta, marginy, paddingx, paddingy, count);

	translate([0, 0, base[2]])	rotate([-90, 0, 0])	bodyBottomFront(thick, margin, delta);
	translate([base[0] + thick * 2, base[1] + thick * 2 + help * 2, 0])
		rotate([0, 0, 180])
		translate([0, 0, base[2]])
		rotate([-90, 0, 0])	bodyBottomFront();
	translate([base[0] + thick * 2, thick / 2 + help, base[2]])
		rotate([-90, 0, 90])
		bodyBottomSide(thick, margin, delta);
	translate([base[0] + thick * 2, base[1] + thick * 2 + help, 0])
		rotate([0, 0, 180])
		translate([base[0] + thick * 2, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyBottomSide(thick, margin, delta);
}
//assempleBodyBottom(0);

module bodyBottom(thick, margin, delta, marginy, paddingx, paddingy, count) {
	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy, count);
	translate([bodyBottomSize(thick, margin, delta)[0] + thick * 4, 0, 0])
		bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy, count);
}

module assempleBodyTop(thick, margin, delta, help = 8) {
	base = bodyTopSize(thick, margin, delta);

	translate([0, 0, base[2]])
		rotate([-90, 0, 0])
		bodyTopFront(thick, margin, delta);
	translate([base[0] + THICK, base[1] + THICK + help + help, 0])
		rotate([0, 0, 180])
		translate([0, 0, base[2]])
		rotate([-90, 0, 0])
		bodyTopFront(thick, margin, delta);

	translate([base[0] + thick, thick / 2 + help, base[2]])
		rotate([-90, 0, 90])
		bodyTopSide(thick, margin, delta);
	translate([base[0] + thick, base[1] + THICK + help, 0])
		rotate([0, 0, 180])
		translate([base[0] + thick, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyTopSide(thick, margin, delta);
}
//assempleBodyTop(10);
module assempleBody(thick, margin, delta, help = 8) {
	base = bodyTopSize(thick, margin, delt);
	assempleBodyBottom(thick, margin, delt, help);
	translate([thick, thick, HEIGHT])
		assempleBodyTop(thick, margin, delta,help);
	translate([thick * 2, thick * 2, HEIGHT + HEIGHT_TOP + 8])	landscape(thick, margin, delta);
}
//assempleBody(8);

module build(target, thick, margin, delta, prototype, marginy, paddingx, paddingy, count) {
	echo("build start: ", target, thick, margin, delta, prototype, marginy, paddingx, paddingy, count);

	echo("상판: ", landscapeSize(thick, margin, delta));
	echo("상층: ", bodyTopSize(thick, margin, delta));
	echo("하층: ", bodyBottomSize(thick, margin, delta));
	
	scale = prototype ? HALF : ONE;

	if (target == 1) {
		scale(scale)	bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy, count);
	} else if (target == 2) {
		scale(scale)
		//	translate([bodyTopSize(thick, margin, delta)[0], 0, 0])
			bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy, count);
	} else if (target == 3) {
		scale(scale) {
			bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy, count);
			translate([bodyTopSize(thick, margin, delta)[0] + 2, 0, 0])
				bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy, count);
		}
	} else if (target == 4) {
		scale(scale)	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy, count);
	} else if (target == 5) {
		scale(scale)	bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy, count);
	}

	//scale(HALF)	bodyTopFront();
//	scale(HALF)	bodyTopSide(thick, margin, delta);
//	translate([0, bodyTopSize()[2] + 4, 0])	bodyTopSide();
	//scale(HALF)	bodyTop();	scale(HALF)	translate([bodyTopSize()[0] + 16, 0, 0])	bodyTop();
	//scale(HALF)	bodyBottom();	scale(HALF)	translate([0, bodyBottomSize()[2] + 4, 0])	bodyBottom();
	echo("build done: ", target, thick, margin, delta, prototype);
}
build(3, thick, margin, delta, false, marginy, paddingx, paddingy, count);

//scale(HALF)	bodyTop();	scale(HALF)	translate([bodyTopSize()[0] + 16, 0, 0])	bodyTop();
//scale(HALF)	bodyBottom();	scale(HALF)	translate([0, bodyBottomSize()[2] + 4, 0])	bodyBottom();
//bodyBottomFront();
//bodyBottomSide();
//halfBodyTop();
//assempleBody();
