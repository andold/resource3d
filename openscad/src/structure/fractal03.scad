// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <../common/library.scad>
use <../common/library_text.scad>
use <fractal03.scad>

//	사각형 막대의 그물망 구조물
DEFAULT_FRACTAL03 = [
	["quad.bar.structure",									"사각형 막대의 그물망 구조물, quadBarStructure"],
	["quad.bar.structure.outter.size",	[100, 100, 100],	"외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure"],
	["quad.bar.structure.bar.size",		[8, 8, 0],			"막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure"],
	["quad.bar.structure.bar.thick",	0.4 * 3,			"막대의 두께, 안에는 빈공간으로 할때, thickBar, thickBarQuadBarStructure"],
	["quad.bar.structure.bar.count",	[4, 4, 0],			"가로 세로 높이에 각각 시작하는 포인트의 갯수, countBar, countBarQuadBarStructure"],

	["end", [0, 0, 0],	"끝"]
];
function default() = DEFAULT_FRACTAL03;

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
module fractal03a_deprecated(unit = 32, thick = 4, count = 4) {
	intersection() {
		cube([unit, unit, unit] * count);
		for (cx = [-count:count]) {
			for (cy = [-count:count]) {
				translate([cx * unit, cy * unit, 0])
				rotate([0, 45, 0])
				translate([-thick / 2, -thick / 2, -thick])
				cube([thick, thick, unit * count * 2]);
			}
		}
	}
}

module fractal0b_deprecated(unit = 32, thick = 4, count = 4) {
	fractal03a(unit, thick, count);

	translate([unit * count, 0, 0])
	rotate([0, 0, 90])
	fractal03a_deprecated(unit, thick, count);

	translate([unit * count, unit * count, 0])
	rotate([0, 0, 180])
	fractal03a_deprecated(unit, thick, count);

	translate([0, unit * count, 0])
	rotate([0, 0, 270])
	fractal03a_deprecated(unit, thick, count);
}


//	x축기준으로, xstart시점에서 오른쪽 45도 위로 xmax까지
module fractal03c(map, xstart, xmax) {
}

module fractal03(map = default()) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	countBar = get(map, "quad.bar.structure.bar.count", DEFAULT_FRACTAL03);	//	
	sizeOutter = get(map, "외경, 사각형 막대의 그물망 구조물", DEFAULT_FRACTAL03);	//	"외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure"
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);	//	"막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure"
	for (cx = [0:countBar.x]) {
		deltax = (sizeOutter.x - sizeBar.x * countBar.x) / (countBar.x - 1);
		fractal03c(map, cx * (deltax + sizeBar.x), sizeOutter.x);
	}
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
		fractal03();	//	선
	} else if (command == 2) {
	} else if (command == 3) {
	} else {
		echo("NOT SUPPORTED");
	}
}

// look build.bat script file
main(is_undef(command) ? 1 : command);
