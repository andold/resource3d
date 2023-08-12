use <MCAD/boxes.scad>

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
module themeCircle(number0, number1, number2, radius = 16) {
	thick = 4;
	size = radius / 4 * 1.33;
	font = "Sans Serif:style=Bold";
	widthBaseline = 2;

	translate([radius, radius, 0]) {
		linear_extrude(thick, false) {
			//	원
			difference() {
				circle(radius);
				circle(radius - 4);
			}
			
			//	전화번호
			translate([size / 2 - radius + size, size + widthBaseline / 2, 0])		textBold(number0, size / 3 * 2, font);
			translate([size / 2 - radius + size, -size / 2 + widthBaseline / 2, 0])	textBold(number1, size, font);
			translate([size / 2 - radius + size, -size * 2 + widthBaseline / 2, 0])	textBold(number2, size, font);
		}
		
		//	베이스라인
		linear_extrude(thick / 2, true) {
			translate([-radius * 0.85,	size, 1 / 2])			square([radius * 2 * 0.85, widthBaseline], false);
			translate([-radius * 0.90,	-size / 2, 1 / 2])		square([radius * 2 * 0.90, widthBaseline], false);
			translate([-radius * 0.70,	-size / 2 * 4, 1 / 2])	square([radius * 2 * 0.70, widthBaseline], false);
		}
	}
	
	//	손잡이?
	translate([radius - thick / 4, -128 / 2 + thick, thick / 4])	roundedBox([thick * 2, 128, thick / 2], thick / 4, true);
}
themeCircle("010", "6810", "6479", SIZE);
translate([SIZE * 2 + 4, 0, 0])	themeCircle("010", "4240", "6479", SIZE);
