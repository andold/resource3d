use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <spider_web_generator.scad>

module textBold(title, size, font) {
	for (cx = [0: 0.01: size / 10]) {
		translate([cx, 0, 0])		text(title, size, font = font);
	}
}
module themeCircle(number0, number1, number2, radius = 16) {
	thick = 2;
	size = radius / 4 * 1.33;
	font = "Sans Serif:style=Bold";
	widthBaseline = 2;
	slices = prototype ? 20 : thick * 16;

	translate([radius, radius, 0]) {
		linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {
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

module themeCircleCap(radius, thick) {
	fn =  $preview ? 32 : 512;

	margin = thick / 4;
	inner = radius + margin;
	inner2 = inner - thick;
	overhangHeight = $preview ? thick + EPSILON : thick;
	outter = radius + margin + thick;
	padding = thick * 3;
	difference() {
		color("white", 0.8)
			translate([0, 0, 0])
			cylinder(h = thick * 2.5 + margin, r1 = outter, r2 = outter, center = false, $fn = fn);
		// 넣는 장소
		translate([0, 0, thick / 2])
			cylinder(h = thick + margin, r1 = inner, r2 = inner, center = false, $fn = fn);
		// 가두는 테두리
		translate([0, 0, thick / 2 * 3 + margin])
			cylinder(h = overhangHeight, r1 = inner, r2 = inner2, center = false, $fn = fn);

		// 살짝 걸치는 곳
		translate([-inner, -thick / 2, -thick / 2])
			cube([padding, thick, thick * 2]);
		translate([inner - padding, -thick / 2, -thick / 2])
			cube([padding, thick, thick * 2]);

		// 반원으로 자르기
		translate([-outter, 0, -thick / 2])
			cube([outter * 2, outter * 2, thick * 4]);
	}
	
	// 손잡이
	stickx = thick * 4;
	sticky = 128;
	stickz = thick;
	translate([0, -sticky / 2 - radius - thick / 2, stickz / 2])
		roundedBox([stickx, sticky, stickz], thick, true);
}

module themeCircleWeb(number0, number1, number2, radius, thick) {
	echo("themeCircleWeb start: ", number0, number1, number2, radius, thick);

	fn =  $preview ? 32 : 512;

	size = (radius - thick) * 2 / 8.5;
	font = "나눔고딕:style=Normal";
	padding = thick * 2;
	slices = $preview ? 20 : thick * 16;

	translate([radius, radius, 0]) {
		//	원
		difference() {
			cylinder(thick, radius, radius, $fn = fn);
			translate([0, 0, -EPSILON])
				cylinder(thick + EPSILON * 2, radius - padding, radius - padding, $fn = fn);
		}
		linear_extrude(height = thick / 2, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {
			intersection() {
				circle(radius);
				offset(0.1)
					import(file = "web.svg", dpi = 96, center = true);
			}
		}
		linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {

			//	전화번호
			offset(0.4)
				translate([-radius + thick + size * 2,	size / 2 * 4.5, 0])
				text(number0, size / 3 * 2, font);
			offset(0.6)
				translate([-radius + thick + size * 0.75,		size / 2 * 1.5, 0])
				text(number1, size, font);

			rotate([0, 0, 180]) {
				offset(0.4)
					translate([-radius + thick + size * 2,	size / 2 * 4.5, 0])
					text(number0, size / 3 * 2, font);
				offset(0.6)
					translate([-radius + thick + size * 0.75, size / 2 * 1.5, 0])
					text(number2, size, font);
			}
		}
		color("blue", 0.8)
			translate([-radius, -thick / 2, thick])
			cube([padding, thick, thick]);
		color("blue", 0.8)
			translate([radius - padding, -thick / 2, thick])
			cube([padding, thick, thick]);
	}
	
	echo("themeCircleWeb done: ", number0, number1, number2, radius, thick);
}

module build(target, step) {
	echo("build parking number 처음: ", target, step);

	if (target == 1) {
		themeCircleCap(radius, thick);
	} else if (target == 2) {
		themeCircleWeb("010", "6810 6479", "4240 6479", 32, 2);
	} else if (target == 3) {
			themeCircleCap(radius, thick);
		translate([radius + thick, 0, 0])
			themeCircleWeb("010", "6810 6479", "4240 6479", radius, thick);
	} else if (target == 4) {
		translate([0, 0, thick * 3])
			rotate([0, 180, 0])
			themeCircleCap(radius, thick);
		translate([-radius, radius / 2 - (radius * 1.5) * (step), thick])
			themeCircleWeb("010", "6810 6479", "4240 6479", radius, thick);
	}

	echo("build parking number 끝: ", target, step);
}

target = 3;
radius = 32;
thick = 2;
build(target, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o stl\parking-number-holder-#19.stl -D target=1 parking\6479.scad
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o stl\parking-number-#19.stl -D target=2 parking\6479.scad
*/
