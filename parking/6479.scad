use <MCAD/boxes.scad>

ZERO = [0, 0, 0];
// 상수
SIZE = 24;

module mark(name, height, size = 2) {
	linear_extrude(height, center = true)	text(name, size = size);
}
//mark("010-6810-6479", 1);
module lines2(first, second, height, size = 1) {
	cube([size * 7.5, size * 3, height / 3]);
	for (dx = [0:0.01:0.1]) {
		translate([size / 2 + dx, size * 0.6, 0])	{
			color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
			color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
		}
	}
	translate([size / 2, size * 0.6, 0])	{
		color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
		color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
	}
	translate([size / 2 + 0.05, size * 0.6, 0])	{
		color([0, 0, 1, 1])	translate([0, size * 1.2, 0])	linear_extrude(height, center = false)	text(first, size = size / 2);
		color([0, 0, 1, 1])	translate([0, 0, 0])				linear_extrude(height, center = false)	text(second, size = size);
	}
}

module andold() {
	base = [8, 3, 1];
	lines2("010", "6810-6479", 1);
}
//andold();

module textBold(title, size, font) {
	for (cx = [0: 0.01: size / 10]) {
		translate([cx, 0, 0])		text(title, size, font = font);
	}
}
module themeCircle(number0, number1, number2, radius = 16, prototype = true) {
	thick = 2;
	size = radius / 4 * 1.33;
	font = "Sans Serif:style=Bold";
	widthBaseline = 2;
	slices = prototype ? 20 : thick * 16;
	fn = prototype ? 32 : 256;

	translate([radius, radius, 0]) {
		linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1], $fn = fn) {
			//	원
			difference() {
				circle(radius);
				circle(radius - 4);
			}
			intersection() {
				circle(radius);
				import(file = "web.svg", dpi = 96 * 2, center = true);
			}
			
			//	전화번호
			translate([size / 2 - radius + size, size + widthBaseline / 2, 0])		textBold(number0, size / 3 * 2, font);
			translate([size / 2 - radius + size, -size / 2 + widthBaseline / 2, 0])	textBold(number1, size, font);
			translate([size / 2 - radius + size, -size * 2 + widthBaseline / 2, 0])	textBold(number2, size, font);
		}
		
		//	베이스라인
		scale(ZERO)	linear_extrude(thick / 2, true) {
			translate([-radius * 0.85,	size, 1 / 2])			square([radius * 2 * 0.85, widthBaseline], false);
			translate([-radius * 0.90,	-size / 2, 1 / 2])		square([radius * 2 * 0.90, widthBaseline], false);
			translate([-radius * 0.70,	-size / 2 * 4, 1 / 2])	square([radius * 2 * 0.70, widthBaseline], false);
		}
	}
	
	//	손잡이?
	translate([radius - thick / 4, -128 / 2 + thick, thick / 4])	roundedBox([thick * 2, 128, thick / 2], thick / 4, true);
}

module themeCircleCap(radius, thick, prototype) {
	outter = radius + thick / 2 * 3;
	inner = radius + thick / 2;
	fn = prototype ? 32 : 256;
	difference() {
		translate([0, 0, 0])						cylinder(h = thick * 2.5, r1 = outter, r2 = outter, center = false, $fn = fn);
		translate([0, 0, thick / 2])				cylinder(h = thick * 1.1, r1 = inner, r2 = inner, center = false, $fn = fn);
		translate([0, 0, thick / 2 + thick * 1.09])	cylinder(h = thick, r1 = inner, r2 = radius - thick, center = false, $fn = fn);

		translate([-outter, 0, -thick])	cube([outter * 2, outter * 2, thick * 4]);
	}
	translate([0, -128 / 2 - radius - thick, thick / 2])	roundedBox([thick * 2, 128, thick], thick / 4, true);
}

module themeCircleWeb(number0, number1, number2, radius, thick, prototype) {
	echo("themeCircleWeb start: ", number0, number1, number2, radius, thick, prototype);
	size = (radius - thick) * 2 / 8.5;
	font = "Sans Serif:style=Bold";
	widthBaseline = 2;
	slices = prototype ? 20 : thick * 16;
	fn = prototype ? 32 : 256;

	translate([radius, radius, 0]) {
		linear_extrude(height = thick / 2, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1], $fn = fn) {
			intersection() {
				circle(radius);
				resize([radius * 2, radius * 2])	import(file = "web.svg", dpi = 96 * 2, center = true);
			}
		}
		linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1], $fn = fn) {
			//	원
			difference() {
				circle(radius);
				circle(radius - thick * 2);
			}

			//	전화번호
			translate([-radius + thick + size * 2,	size / 2 * 5, 0])	textBold(number0, size / 3 * 2, font);
			translate([-radius + thick + size,		size / 2 * 2, 0])	textBold(number1, size, font);

			rotate([0, 0, 180]) {
				translate([-radius + thick + size * 2,	size / 2 * 5, 0])	textBold(number0, size / 3 * 2, font);
				translate([-radius + thick + size,		size / 2 * 2, 0])	textBold(number2, size, font);
			}
		}
		color("blue", 0.8)
			translate([-radius, -thick / 2, thick])
			cube([4, thick, thick / 2]);
		color("blue", 0.8)
			translate([radius - thick * 2, -thick / 2, thick / 2])
			cube([4, thick, thick]);
	}
	
	echo("themeCircleWeb done: ", number0, number1, number2, radius, prototype);
}

target = 2;
radius = 32;
thick = 2;
prototype = true;
module build(target, prototype, radius) {
	echo("build start: ", prototype, radius);

	if (target == 1) {
		themeCircleCap(
			(radius == undef) ? 32 : radius,
			(thick == undef) ? 2 : thick,
			(prototype == undef) ? true : prototype
		);
	} else if (target == 2) {
		themeCircleWeb("010", "6810 6479", "4240 6479",
			(radius == undef) ? 32 : radius,
			(thick == undef) ? 2 : thick,
			(prototype == undef) ? true : prototype
		);
	}

	echo("build done: ", prototype, radius);
}

build(target, prototype, radius);
//resize([SIZE, SIZE])	import(file = "web.svg", dpi = 96 * 1 / 2, center = true);
