// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <../common/library.scad>
use <fractal03.scad>

module octagon(unit = 8, thick = 1) {
	delta = unit / sqrt(2);
	p1 = [0, 0, 0];
	p2 = p1 + [unit, 0, 0];
	p3 = p2 + [delta, delta, 0];
	p4 = p3 + [0, unit, 0];
	p5 = p4 + [-delta, delta, 0];
	p6 = p5 + [-unit, 0, 0];
	p7 = p6 + [-delta, -delta, 0];
	p8 = p7 + [0, -unit, 0];
	
	translate([delta, 0, 0]) {
		line_type_1(p1, p2, thick);
		line_type_1(p2, p3, thick);
		line_type_1(p3, p4, thick);
		line_type_1(p4, p5, thick);
		line_type_1(p5, p6, thick);
		line_type_1(p6, p7, thick);
		line_type_1(p7, p8, thick);
		line_type_1(p8, p1, thick);
	}
}

module quad(p0, p1, thick) {
	o = p1 - p0;

	size = [
		sqrt(o.x * o.x + o.z * o.z),
		o.y,
		thick
	];
	
	rotate([0, -acos(o.x / size.x), 0])
	cube(size);
}

module fractal02a(unit = 8, thick = 1, count = 4) {
	p0 = [0, 0, 0];
	p1 = [unit, unit, unit] * count;
	quad(p0, p1, thick);

	color("blue", 0.2)
	intersection() {
		cube(p1);
		for (cx = [-count:count]) {
			translate([cx * unit, 0, 0])
			quad(p0, p1, thick);
		}
	}
}

module fractal02(unit = 8, thick = 1, count = 4) {
	fractal02a();

	translate([unit * count, 0, 0])
	rotate([0, 0, 90])
	fractal02a();

	translate([unit * count, unit * count, 0])
	rotate([0, 0, 180])
	fractal02a();

	translate([0, unit * count, 0])
	rotate([0, 0, 270])
	fractal02a();
}

module fractal01() {
	unit = 8;
	thick = 1;
	delta = unit / sqrt(2);
	width = unit + delta * 2;
	degree = 45;

	octagon(unit, thick);

	translate([0, 0, 0])
	rotate([0, -90 - degree, 0])
	octagon(unit, thick);

	translate([width, 0, 0])
	rotate([0, -degree, 0])
	octagon(unit, thick);
}

module usage(command = 0) {
	echo("command == 1", "팔각형 쌓기");
	echo("command == 2", "사선을 면으로 쌓기");
	echo("command == 3", "사선을 4각 막대로 쌓기");
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		usage();
	} else if (command == 1) {
		fractal01();	//	팔각형
	} else if (command == 2) {
		fractal02();	//	면
	} else if (command == 3) {
		fractal03();	//	선
	} else {
		echo("NOT SUPPORTED");
	}
}

// look build.bat script file
main(is_undef(command) ? 0 : command);
