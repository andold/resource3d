// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use	<../common/library_line.scad>
use <fractal03.scad>

//	사각형 막대의 그물망 구조물
DEFAULT_FRACTAL03 = [
	["quad.bar.structure",									"사각형 막대의 그물망 구조물, quadBarStructure"],
	["quad.bar.structure.outter.size",	[100, 100, 100],	"외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure"],
	["quad.bar.structure.bar.size",		[8, 8, 0],			"막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure"],
	["quad.bar.structure.bar.thick",	1.2,			"막대의 두께, 안에는 빈공간으로 할때, thickBar, thickBarQuadBarStructure"],
	["quad.bar.structure.bar.count",	[4, 4, 0],			"가로 세로 높이에 각각 시작하는 포인트의 갯수, countBar, countBarQuadBarStructure"],

	["end", [0, 0, 0],	"끝"]
];
function default() = DEFAULT_FRACTAL03;

/*
	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);
	//	막대의 두께, 안에는 빈공간으로 할때, thickBar, thickBarQuadBarStructure
	thickBar = get(map, "quad.bar.structure.bar.thick", DEFAULT_FRACTAL03);
	//	가로 세로 높이에 각각 시작하는 포인트의 갯수, countBar, countBarQuadBarStructure
	countBar = get(map, "quad.bar.structure.bar.count", DEFAULT_FRACTAL03);
	//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
	sizeOutter = get(map, "quad.bar.structure.outter.size", DEFAULT_FRACTAL03);
	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);
*/

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
module fractal03a(unit = 32, thick = 4, count = 4) {
	for (cx = [-count:count]) {
		for (cy = [-count:count]) {
			translate([cx * unit, cy * unit, 0])
			rotate([0, 45, 0])
			translate([-thick / 2, -thick / 2, -thick])
			cube([thick, thick, unit * count * 2]);
		}
	}
}

module fractal03b(unit = 32, thick = 4, count = 4) {
	intersection() {
		cube([unit, unit, unit] * count);

		union() {
			fractal03a(unit, thick, count);

			translate([unit * count, 0, 0])
			rotate([0, 0, 90])
			fractal03a(unit, thick, count);

			translate([unit * count, unit * count, 0])
			rotate([0, 0, 180])
			fractal03a(unit, thick, count);

			translate([0, unit * count, 0])
			rotate([0, 0, 270])
			fractal03a(unit, thick, count);
		}
	}
}

//	작은 4각 막대
module fractal02(unit = 32, thick = 4, count = 4, sn) {
	fractal03b(unit, thick, count);
	
	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);

	translate([unit / 2, unit / 2, 0])
	carve(snumber, size = unit / 4, offset = unit / 32, rotate = [180, 0, 0], translate = [unit, -unit, 0], halign = "center", preview = !true) {
		cube([unit * 2, unit * 2, 4]);
	}
	
}

//	bar
module fractal03d(height, size, thick) {
//	echo(str("", parent_module(0), "(", height, size, thick, ")"));
	assert(!is_undef(height) && !is_undef(size)  && !is_undef(thick));

	difference() {
		cube([size.x, size.y, height]);
		translate([thick, thick, 0])
		cube([size.x - thick * 2, size.y - thick * 2, height]);
	}
}

//	x축기준으로, xstart시점에서 오른쪽 45도 위로 xmax까지
module fractal03c(map, xstart, xmax) {
	echo(str("", parent_module(0), "(", xstart, ", ", xmax, ")"));
	assert(!is_undef(map) && !is_undef(xstart)  && !is_undef(xmax));

	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);
	//	막대의 두께, 안에는 빈공간으로 할때, thickBar, thickBarQuadBarStructure
	thickBar = get(map, "quad.bar.structure.bar.thick", DEFAULT_FRACTAL03);

	height = sqrt(2) * (xmax - xstart);
	
	difference() {
		rotate([0, 45, 0])
		fractal03d(height, sizeBar, thickBar);
		
		//	아래쪽 삭제
		translate([0, 0, -sizeBar.x / sqrt(2)])
		cube([sqrt(2) * sizeBar.x, sizeBar.y, sizeBar.x / sqrt(2)]);
		
		//	오른쪽 삭제
		translate([height / sqrt(2), 0, height / sqrt(2) - sizeBar.x * sqrt(2)])
		cube([sizeBar.x / sqrt(2), sizeBar.y, sizeBar.x * sqrt(2)]);
	}
}

//	지시선
module fractal03note01(map, dimension = "xy") {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
	sizeOutter = get(map, "quad.bar.structure.outter.size", DEFAULT_FRACTAL03);
	lineindex(sizeOutter, sizeOutter, dimension = dimension);

	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);
	lineindex([sqrt(2) * sizeBar.x, sizeBar.y], sizeOutter, dimension = dimension);

	delta =  calculateDelta(map);
	lineindex([sqrt(2) * sizeBar.x + delta.x, 0], sizeOutter, dimension = dimension);
}

//	평면별로 지시선
module fractal03note(map) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

//	fractal03note01(map, "xy");
//	fractal03note01(map, "yz");
	fractal03note01(map, "zx");
}

//	바닥 포인트들 사이의 간격
function calculateDelta(map) = let(
	//	가로 세로 높이에 각각 시작하는 포인트의 갯수, countBar, countBarQuadBarStructure
	countBar = get(map, "quad.bar.structure.bar.count", DEFAULT_FRACTAL03),
	//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
	sizeOutter = get(map, "quad.bar.structure.outter.size", DEFAULT_FRACTAL03),
	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03),
	reserved = assert(!is_undef(map))
) [
	(sizeOutter.x - sqrt(2) * sizeBar.x * countBar.x) / (countBar.x - 1),
	(sizeOutter.y - sizeBar.y * countBar.y) / (countBar.y - 1),
	0
];

//	xz 평면에 전개, -Y축에서 보면서 전개한다
module fractal03f(map = default()) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	//	가로 세로 높이에 각각 시작하는 포인트의 갯수, countBar, countBarQuadBarStructure
	countBar = get(map, "quad.bar.structure.bar.count", DEFAULT_FRACTAL03);
	//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
	sizeOutter = get(map, "quad.bar.structure.outter.size", DEFAULT_FRACTAL03);
	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);

	delta =  calculateDelta(map);
	for (cx = [0:countBar.x - 2]) {
		translate([cx * (delta.x + sqrt(2) * sizeBar.x), 0, 0])
		fractal03c(map, cx * (delta.x + sqrt(2) * sizeBar.x), sizeOutter.x);
	}
}

//	x = 0에 대칭
module fractal03e(map = default()) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));


	fractal03f(map);

	//	x = 0에 대칭
	//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
	sizeOutter = get(map, "quad.bar.structure.outter.size", DEFAULT_FRACTAL03);
	translate([sizeOutter.x, 0, 0])
	mirror([1, 0, 0])
	fractal03f(map);
	
}

//	복사
module copy(reflect, angle, move, preview = false) {
	echo(str(parent_module(0), ".", parent_module(1), "(", reflect, angle, move, ")"));
	assert(!is_undef(reflect) && !is_undef(angle) && !is_undef(move));

	translate(move)
	rotate(angle)
	mirror(reflect)
	children();
	
	if(!preview) {
		children();
	}
}

module fractal03(map = default()) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));
	assert(!is_undef(map));

	fractal03note(map);
	fractal03e(map);
	//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
	sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);
	//	yz 평면으로 회전
	//translate([sizeBar.y, 0, 0])	rotate([0, 0, 90])	fractal03e(map);
}

module usage(command = 0) {
	echo("/usr/bin/openscad --export-format asciistl -D sn=10 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S').stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/structure/fractal03.scad");
	echo("	-D sn=nnn		일련번호 마킹");
	echo("	-D command=1	팔각형 쌓기 프린트");
	echo("	-D command=2	사선을 4각 막대로 쌓기 프린트");
	//	/usr/bin/openscad --export-format asciistl -D command=2 -D sn=13 -o "/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-013.stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/structure/fractal03.scad
	echo("		/usr/bin/openscad --export-format asciistl -D command=2 -D sn=13 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-013.stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/structure/fractal03.scad");
	echo("	-D command=3	 구현중, Under Construction!");
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		usage();
	} else if (command == 1) {
		fractal03();
	} else if (command == 2) {
		fractal02(32, 0.4 * 6, 3, sn = 13);
	} else if (command == 3) {
		//	외경, 사각형 막대의 그물망 구조물, sizeOutter, sizeOutterQuadBarStructure
		sizeOutter = get(default(), "quad.bar.structure.outter.size", DEFAULT_FRACTAL03);
		//	막대 크기, 그물의 줄에 해당, sizeBar, sizeBarQuadBarStructure
		sizeBar = get(map, "quad.bar.structure.bar.size", DEFAULT_FRACTAL03);

		//copy([-1, 0, 1], [0, 0, 0], [0, 0, -sqrt(2) * sizeBar.x * 0], preview = false)
		copy([1, 0, 0], [0, 0, 0], [sizeOutter.x, 0, 0], preview = false)
		fractal03f(default());
	} else {
		echo("NOT SUPPORTED");
	}
}

// look build.bat script file
main(is_undef(command) ? 2 : command);
