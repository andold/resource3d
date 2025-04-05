use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <spider_web_generator.scad>

module textBold(title, size, font) {
	for (cx = [0: 0.01: size / 10]) {
		translate([cx, 0, 0])		text(title, size, font = font);
	}
}
module themeCircle(number1, number2, radius = 16) {
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
			translate([size / 2 - radius + size, size + widthBaseline / 2, 0])		textBold("010", size / 3 * 2, font);
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

module themeCircleWebNumberOne(number1, radius, thick) {
	size = (radius - thick) * 2 / 8.5;
	textSizeSmall010 = radius * 0.1;
	textSizeSmall6479 = radius * 0.175;
	font = "나눔고딕:style=Normal";
	slices = $preview ? 20 : thick * 16;
	linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {

		//	전화번호
		translate([0, -size * 1, 0])
		{
			offset(0.4)
				translate([-radius + textSizeSmall6479 * 2,	textSizeSmall6479 * 3, 0])
				text("010", textSizeSmall010 * 2, font);
			offset(0.6)
				translate([-radius + textSizeSmall010 * 1.6, textSizeSmall010 * 1.5, 0])
				text(number1, textSizeSmall010 * 2.4, font);
		}
	}
}

module themeCircleWebNumber(number1, number2, radius, thick) {
	size = (radius - thick) * 2 / 8.5;
	textSizeSmall010 = radius * 0.1;
	textSizeSmall6479 = radius * 0.175;
	font = "나눔고딕:style=Normal";
	slices = $preview ? 20 : thick * 16;
	linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {

		//	전화번호
		translate([0, -size * 1, 0])
		{
			offset(0.4)
				translate([-radius + textSizeSmall6479 * 2,	textSizeSmall6479 * 3, 0])
				text("010", textSizeSmall010 * 2, font);
			offset(0.6)
				translate([-radius + textSizeSmall010 * 1.6, textSizeSmall010 * 1.5, 0])
				text(number1, textSizeSmall010 * 2.4, font);
		}

		//rotate([0, 0, 180])
		translate([size, -size * 4, 0])
		{
			offset(0.3)
				translate([-radius + textSizeSmall010 * 2,	textSizeSmall010 * 5.5, 0])
				text("010", textSizeSmall010, font);
			offset(0.3)
				translate([-radius + textSizeSmall010 * 1.75, size / 2 * 1.5 * 2, 0])
				text(number2, textSizeSmall6479, font);
		}
	}
}

module themeCircleWeb(number1 = "6810 6479", number2 = "4240 6479", radius, thick) {
	echo("themeCircleWeb start: ", number1, number2, radius, thick);

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
		translate([0, 0, thick / 4])
		linear_extrude(height = thick / 2, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {
			intersection() {
				circle(radius);
				offset(0.1)
					import(file = "web.svg", dpi = 96, center = true);
			}
		}
		color("red", 1.0)
		translate([0, 0, thick * 0.25])
		themeCircleWebNumber(number1, number2, radius, thick * 0.75);

		color("blue", 1.0)
		translate([0, thick-64, thick / 2])
		roundedBox([thick * 2, 64, thick], 1, true);
	}
	
	echo("themeCircleWeb done: ", number1, number2, radius, thick);
}
module themeCircleWebOne(number1 = "6810 6479", radius, thick) {
	echo("themeCircleWebOne start: ", number1, radius, thick);

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
		translate([0, 0, thick / 4])
		linear_extrude(height = thick / 2, center = false, convexity = 10, twist = 0, slices = slices, scale=[1, 1]) {
			intersection() {
				circle(radius);
				offset(0.1)
					import(file = "web.svg", dpi = 96, center = true);
			}
		}
		color("red", 1.0)
		translate([1, -6, thick * 0.25])
		themeCircleWebNumberOne(number1, radius, thick * 0.75);

		color("blue", 1.0)
		translate([0, thick-64, thick / 2])
		roundedBox([thick * 2, 64, thick], 1, true);
	}
	
	echo("themeCircleWebOne done: ", number1, radius, thick);
}

//themeCircleWeb("010", "6810 6479", "4240 6479", 32, 2);	//	과헌
//themeCircleWeb("2320 4016", "2520 8070", 32, 2);	//	호창
//themeCircleWeb("7564 4567", "3993 8802", 32, 2)//	장희
themeCircleWebOne("2425 4821", 32, 2);	//	홍석