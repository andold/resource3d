use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <spider_web.scad>

fn =  $preview ? 16 : 128;

FONT = "나눔고딕:style=Bold";

function slices(thick) = $preview ? 20 : thick * 8;
function textWidth(radius, thick) = (radius - thick) * 2 / 8.5;

module themeCircleWebNumberOne(number1, radius, thick) {
	echo("themeCircleWebNumberOne start: ", number1, radius, thick);

	textSizeSmall010 = radius * 0.1;
	textSizeSmall6479 = radius * 0.175;
	linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices(thick), scale=[1, 1]) {
		//	전화번호
		translate([0, -textWidth(radius, thick) * 1, 0])
		{
			offset(0.4)
				translate([-radius + textSizeSmall6479 * 2,	textSizeSmall6479 * 3.5, 0])
				text("010", textSizeSmall010 * 1.5, FONT);
			offset(0.6)
				scale([1.0, 1.2, 1.0])
				translate([-radius + textSizeSmall010 * 1.6, textSizeSmall010 * 1.5, 0])
				text(number1, textSizeSmall010 * 2.4, FONT);
		}
	}
}

module themeCircleWebNumber(number1, number2, radius, thick, type = 0) {
	textSizeSmall010 = radius * 0.1;
	textSizeSmall6479 = radius * 0.175;

	linear_extrude(height = thick, center = false, convexity = 10, twist = 0, slices = slices(thick), scale=[1, 1], $fn = fn) {
		//	전화번호
		translate([0, -textWidth(radius, thick) * 1, 0])
		{
			offset(0.4)
				translate([-radius + textSizeSmall6479 * 2,	textSizeSmall6479 * 3.5, 0])
				text("010", textSizeSmall010 * 1.5, FONT);
			offset(0.6)
			scale([1.0, 1.2, 1.0])
				translate([-radius + textSizeSmall010 * 1.6, textSizeSmall010 * 1.5, 0])
				text(number1, textSizeSmall010 * 2.4, FONT);
		}

		//rotate([0, 0, 180])
		translate([textWidth(radius, thick), -textWidth(radius, thick) * 4, 0])
		{
			if (type != 0) {
				offset(0.3)
					translate([-radius + textSizeSmall010 * 2,	textSizeSmall010 * 5.5, 0])
					text("010", textSizeSmall010, FONT);
			}
			offset(0.3)
				scale([1.0, 1.2, 1.0])
				translate([-radius + textSizeSmall010 * 1.75, textWidth(radius, thick) / 2 * 1.5 * 2, 0])
				text(number2, textSizeSmall6479, FONT);
		}
	}
}

module themeCircleWebOne(number1 = "6810 6479", radius = 40, thick = 4, height = 4, thickSpiderWeb = 0.8, stick = [5, 64, 2.5]) {
	echo("themeCircleWebOne start: ", number1, radius, thick);

	translate([radius, radius, 0]) {
		//	원
		color("yellow", 1.0)
		difference() {
			cylinder(height, radius, radius, $fn = fn);
			translate([0, 0, -EPSILON])
				cylinder(height + EPSILON * 2, radius - thick, radius - thick, $fn = fn);
		}

		color("yellow", 0.5)
		spider_web(radius, height - 1, thick = thickSpiderWeb);

		color("yellow", 1.0)
		translate([1, -6, 0])
		themeCircleWebNumberOne(number1, radius, height);

		color("yellow", 1.0)
		translate([0, -stick[1] / 2 - radius + thick, stick[2] / 2])
		roundedBox(stick, 1, true);
	}
	
	echo("themeCircleWebOne done: ", number1, radius, thick);
}

module themeCircleWeb(number1 = "6810 6479", number2 = "4240 6479", radius = 40, thick = 4, thickSpiderWeb = 0.8, height = 4, stick = [5, 64, 2.5]) {
	echo("themeCircleWeb start: ", number1, number2, radius, thick, thickSpiderWeb, height, stick);

	if (number1 == undef || len(number1) == 0) {
		echo("INVALID: number1은 필수입니다", number1, number2, radius, thick);
	} else if (number2 == undef || len(number2) == 0) {
		echo("하나의 전화번호만 출력합니다.", number1, radius, thick, height, thickSpiderWeb, stick);
		themeCircleWebOne(number1, radius, thick, height, thickSpiderWeb, stick);
	} else {
		echo("두개의 전화번호를 출력합니다.", number1, number2, radius, thick, height, thickSpiderWeb, stick);
		translate([radius, radius, 0]) {
			echo("최외곽원을 출력합니다.", height, radius, radius - thick, fn);
			//	최외곽원
			color("white", 1.0)
			difference() {
				cylinder(height, radius, radius, $fn = fn);
				translate([0, 0, -EPSILON])
					cylinder(height + EPSILON * 2, radius - thick, radius - thick, $fn = fn);
			}

			color("white", 0.5)
			translate([0, 0, 0])
			spider_web(radius, height - 1, thick = thickSpiderWeb);

			color("white", 1.0)
			translate([0, 0, 0])
			themeCircleWebNumber(number1, number2, radius, height);

			color("white", 0.5)
			translate([0, -stick[1] / 2 - radius + thick, stick[2] / 2])
			roundedBox(stick, 1, true);
		}
	}

	echo("themeCircleWeb done: ", number1, number2, radius, thick, thickSpiderWeb, height, stick);
}

module samples(data, size = 9) {
	for (cx = [0:size - 1]) {
		translate([cx * 85, 0, 0])
		themeCircleWeb(data[cx][1], data[cx][2]);
	}
}

module build(command = 0) {
	echo(command);

	COMMANDS = [
		["샘플", "첫번째 전화", "두번째 전화"],
		["박영선 권과헌", "4240 6479", "6810 6479"],
		["권과헌 박영선", "6810 6479", "4240 6479"],
		["이호창", "2320 4016"],
		["조제욱", "2520 8070"],
		["한장희", "7564 4567"],
		["김은주", "3993 8802"],
		["송홍석", "2425 4821"],
		["마지막", " RESEVED"]
	];
	stick = [8, 64, 2.5];

	if (command < 0) {
		cube([1, 1, 1]);
	} else if (command == 0) {
		//samples(COMMANDS);
		themeCircleWeb(COMMANDS[1][1], COMMANDS[1][2], stick = stick);
	} else {
		themeCircleWeb(COMMANDS[command][1], COMMANDS[command][2], stick = stick);
	}

	echo(command, COMMANDS[command][0], COMMANDS[command][1], COMMANDS[command][2], stick = stick);
}

build(command == undef ? 0 : command);
