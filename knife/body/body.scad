use <MCAD/boxes.scad>
use <../top/landscape.scad>
use <common.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.2;

// 주요 상수
HEIGHT = 210;
HEIGHT_TOP = 210;
OVERLAP = 0;
OPACITY = 0.75;

// 외경
function bodyTopSize(thick, margin, delta)  = [
	landscapeSize(thick, margin, delta)[0] + thick * 2,
	landscapeSize(thick, margin, delta)[1] + thick * 2,
	HEIGHT_TOP
];
function bodyBottomSize(thick, margin, delta) = [
	bodyTopSize(thick, margin, delta)[0] + thick * 2,
	bodyTopSize(thick, margin, delta)[1] + thick * 2,
	HEIGHT - bodyTopSize(thick, margin, delta)[2] + OVERLAP
];
function bodySize(thick, margin, delta) = [
	bodyBottomSize(thick, margin, delta)[0],
	bodyBottomSize(thick, margin, delta)[1],
	HEIGHT
];

module bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy) {
//	echo("bodyTopFront start: ", thick, margin, delta, marginy, paddingx, paddingy);

	base = bodyTopSize(thick, margin, delta);
	
	board(base[0], base[2], thick, false, marginy, paddingy + thick / 2, paddingy);

//	echo("bodyTopFront done: ", thick, margin, delta, marginy, paddingx, paddingy);
}

// 조립시 안쪽
module bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy) {
//	echo("bodyTopSide start: ", thick, margin, delta, marginy, paddingx, paddingy);

	base = bodyTopSize(thick, margin, delta);
	board(base[1] - thick, base[2], thick, true, marginy, paddingx, paddingy);

//	echo("bodyTopSide done: ", thick, margin, delta, marginy, paddingx, paddingy);
}

module bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy) {
//	echo("bodyBottomFront start: ", thick, margin, delta, marginy, paddingx, paddingy);

	base = bodyBottomSize(thick, margin, delta);
	board(base[0], base[2], thick, false, OVERLAP, paddingy + thick / 2, paddingy);

//	echo("bodyBottomFront done: ", thick, margin, delta, marginy, paddingx, paddingy);
}

module bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy) {
//	echo("bodyBottomSide start: ", thick, margin, delta, marginy, paddingx, paddingy);

	base = bodyBottomSize(thick, margin, delta);
	board(base[1] - thick, base[2], thick, true, OVERLAP, paddingx, paddingy);

//	echo("bodyBottomSide done: ", thick, margin, delta, marginy, paddingx, paddingy);
}

module compareFront(thick, margin, delta, marginy, paddingx, paddingy) {
//	echo("compareFront start: ", thick, margin, delta, marginy, paddingx, paddingy);

	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy);
	translate([thick, HEIGHT - bodyTopSize(thick, margin, delta)[2] + OVERLAP + 1, 0])
		boardTopFront(thick, margin, delta, marginy, paddingx, paddingy);

//	echo("compareFront done: ", thick, margin, delta, marginy, paddingx, paddingy);
}


module compareSide(thick, margin, delta, marginy, paddingx, paddingy) {
	bodyBottomSide(thick, margin, delta);
	translate([thick, HEIGHT - bodyTopSize()[2] + OVERLAP + 1, 0])
		boardTopSide(thick, margin, delta, marginy, paddingx, paddingy);
}
//compareSide();

// 크기 제한으로 상하단으로 분리한다.
module bodyTop(thick, margin, delt, marginy, paddingx, paddingy) {
	bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy);
	translate([0, bodyTopSize(thick, margin, delta)[2] + 4, 0])
		bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy);
}
//scale(HALF)	bodyTop();

module bodyBottom(thick, margin, delta, marginy, paddingx, paddingy) {
	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy);
	translate([bodyBottomSize(thick, margin, delta)[0] + thick * 4, 0, 0])
		bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy);
}

module assempleBodyTop(thick, margin, delta, marginy, paddingx, paddingy, help = 8) {
//	echo("assempleBodyTop start: ", thick, margin, delta, marginy, paddingx, paddingy, help);

	base = bodyTopSize(thick, margin, delta);

	translate([help, 0, base[2]])
		rotate([-90, 0, 0])
		bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy);
	translate([base[0] + help, base[1], 0])
		rotate([0, 0, 180])
		translate([0, 0, base[2]])
		rotate([-90, 0, 0])
		bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy);

	translate([base[0] + help * 2, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy);
	translate([base[0] + thick, base[1] + thick / 2 * 0, 0])
		rotate([0, 0, 180])
		translate([base[0] + thick, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy);

//	echo("assempleBodyTop done: ", thick, margin, delta, marginy, paddingx, paddingy, help);
}

module assempleBodyBottom(thick, margin, delta, marginy, paddingx, paddingy, help = 8) {
//	echo("assempleBodyBottom start: ", thick, margin, delta, marginy, paddingx, paddingy, help);

	base = bodyBottomSize(thick, margin, delta);

	translate([help, 0, base[2]])
		rotate([-90, 0, 0])
		bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy);
	translate([base[0] + help, base[1], 0])
		rotate([0, 0, 180])
		translate([0, 0, base[2]])
		rotate([-90, 0, 0])
		bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy);

	translate([base[0] + help * 2, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy);
	translate([base[0] + thick * 2, base[1], 0])
		rotate([0, 0, 180])
		translate([base[0] + thick * 2, thick / 2, base[2]])
		rotate([-90, 0, 90])
		bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy);

//	echo("assempleBodyBottom done: ", thick, margin, delta, marginy, paddingx, paddingy, help);
}

module assempleBody(thick, margin, delta, marginy, paddingx, paddingy, help = 8) {
//	echo("assempleBody start: ", thick, margin, delta, marginy, paddingx, paddingy, help);

	base = bodyTopSize(thick, margin, delta);
	*assempleBodyBottom(thick, margin, delta, marginy, paddingx, paddingy, help);
	#translate([thick, thick, HEIGHT - HEIGHT_TOP + help])
		assempleBodyTop(thick, margin, delta, marginy, paddingx, paddingy, help);
	%translate([thick * 2, thick * 2, HEIGHT - thick * 2 + help * 2])
		landscape(thick, margin, delta);

//	echo("assempleBody done: ", thick, margin, delta, prototype, marginy, paddingx, paddingy, help);
}

module build(target, thick, margin, delta, prototype, marginy, paddingx, paddingy) {
	echo("build start: ", target, thick, margin, delta, prototype, marginy, paddingx, paddingy);

	echo("상판: ", landscapeSize(thick, margin, delta));
	echo("상층: ", bodyTopSize(thick, margin, delta));
	echo("하층: ", bodyBottomSize(thick, margin, delta));
	
	scale = prototype ? HALF : ONE;
	$fn = prototype ? 32 : 256;

	if (target == 1) {
		scale(scale)	bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy);
	} else if (target == 2) {
		scale(scale)
			bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy);
	} else if (target == 3) {
		scale(scale) {
			bodyTopFront(thick, margin, delta, marginy, paddingx, paddingy);
			translate([-bodyTopSize(thick, margin, delta)[1] - 2, 0, 0])
				bodyTopSide(thick, margin, delta, marginy, paddingx, paddingy);
		}
	} else if (target == 4) {
		scale(scale)	bodyBottomFront(thick, margin, delta, marginy, paddingx, paddingy);
	} else if (target == 5) {
		scale(scale)	bodyBottomSide(thick, margin, delta, marginy, paddingx, paddingy);
	} else if (target == 6) {
		assempleBodyTop(thick, margin, delta, marginy, paddingx, paddingy, 0);
	} else if (target == 7) {
		assempleBodyBottom(thick, margin, delta, marginy, paddingx, paddingy, 0);
	} else if (target == 8) {
		assempleBody(thick, margin, delta, marginy, paddingx, paddingy, 0);
	}

	echo("build done: ", target, thick, margin, delta, prototype, marginy, paddingx, paddingy);
}

prototype = true;
target = 8;
thick = 4;
margin = 8;
delta = 8;
marginy = 12;
paddingx = 24;
paddingy = 12;
build(target, thick, margin, delta, prototype, marginy, paddingx, paddingy);
