// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>
use <library_function.scad>
use <library_text.scad>
use <library_line.scad>

//	튜브형태의 네모 박스, 사방 벽면만 있는 형태
//	size: 외경
module box_type_1(size, thick) {
	cube([size[0], thick, size[2]]);	//	앞
	translate([0, size[1] - thick, 0])	cube([size[0], thick, size[2]]);	//	뒤

	translate([0, 0, 0])	cube([thick, size[1], size[2]]);	//	왼쪽
	translate([size[0] - thick, 0, 0])	cube([thick, size[1], size[2]]);	//	오른쪽
}

// 끝에 반구가 더달린 실린더형태의 3차원 라인
// 대칭 사다리꼴, xz 평면에서 보았을 때
module cube_type_1(v, x) {
	rotate([0, -90, -90])
	linear_extrude(v.y)
	polygon([
		[0,		0],
		[0,		v.x],
		[v.z,	v.x - (v.x - x) / 2],
		[v.z,	(v.x - x) / 2],
		[0,		0]
	]);
}

// 한쪽으로만(x축 방향으로만) 늘어나는(또는 줄어드는) 사다리꼴-하나는 직각 유지, xz 평면에서 보았을 때
module cube_type_2(v, x) {
	rotate([0, -90, -90])
	linear_extrude(v.y)
	polygon([
		[0,		0],
		[0,		v.x],
		[v.z,	x],
		[v.z,	0],
		[0,		0]
	]);
}

// 벡터들을 이용하여 꼭지점을 직각으로만 연결하는 육면체
module cube_type_3(vectors, radious) {
	// 아래쪽
	line_type_1(vectors[0], vectors[1], radious);
	line_type_1(vectors[1], vectors[2], radious);
	line_type_1(vectors[2], vectors[3], radious);
	line_type_1(vectors[3], vectors[0], radious);

	// 위쪽
	line_type_1(vectors[4], vectors[5], radious);
	line_type_1(vectors[5], vectors[6], radious);
	line_type_1(vectors[6], vectors[7], radious);
	line_type_1(vectors[7], vectors[4], radious);
	
	// 기둥
	line_type_1(vectors[0], vectors[4], radious);
	line_type_1(vectors[1], vectors[5], radious);
	line_type_1(vectors[2], vectors[6], radious);
	line_type_1(vectors[3], vectors[7], radious);
}

// x 축으로의 모서리의 일부 각(x축으로 평행한 모서리)을 제거한 것
module cube_type_4(v, c) {
	r = is_undef(c) ? min(v.x, v.y, v.z) / 16 : c;
	stiffen = r * sqrt(2);

	translate([0, r, 0])		cube(v - [0, r * 2, 0]);
	translate([0, 0, r])		cube(v - [0, 0, r * 2]);
	translate([0, r, 0])				rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
	translate([0, r, v.z - r * 2])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
	translate([0, v.y - r, v.z - r * 2])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
	translate([0, v.y - r, 0])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
}

// xy평면에 격자 모형, 45도
module cube_type_5(size, wall, distance) {
	w = is_undef(wall) ? size.z : wall;
	dx = is_undef(distance) ? w * 4 : distance;
	intersection() {
		cube(size);
		for(cx = [0: dx: size.x + size.y]) {
			translate([cx, - w * sqrt(2), 0])	rotate([0, 0, 45])	cube([w, size.y * 2, size.z]);
			translate([cx - size.y, - w * sqrt(2), 0])	rotate([0, 0, -45])	cube([w, size.y * 2, size.z]);
		}
	}
}

// xy평면에 격자 모형, 45도
module cube_type_5(size, wall, distance) {
	w = is_undef(wall) ? size.z : wall;
	dx = is_undef(distance) ? w * 4 : distance;
	intersection() {
		cube(size);
		for(cx = [0: dx: size.x + size.y]) {
			translate([cx, - w * sqrt(2), 0])	rotate([0, 0, 45])	cube([w, size.y * 2, size.z]);
			translate([cx - size.y, - w * sqrt(2), 0])	rotate([0, 0, -45])	cube([w, size.y * 2, size.z]);
		}
	}
}

// xy평면에 테두리만 있는, 바깥쪽만 모서리 둥근 처리된된
module cube_type_6(size, width, radious) {
	w = is_undef(width) ? size.z : width;
	r = is_undef(radious) ? 0 : radious;
	r2 = r * 2;
	
	translate([0, r, 0])			cube([w, size.y - r2, size.z]);
	translate([size.x - w, r, 0])	cube([w, size.y - r2, size.z]);
	translate([r, 0, 0])			cube([size.x - r2, w, size.z]);
	translate([r, size.y - w, 0])	cube([size.x - r2, w, size.z]);

	translate([r, r, 0])	cylinder(size.z, r, r, $fn = fnRound(size.z));
	translate([size.x - r, r, 0])	cylinder(size.z, r, r, $fn = fnRound(size.z));
	translate([r, size.y - r, 0])	cylinder(size.z, r, r, $fn = fnRound(size.z));
	translate([size.x - r, size.y - r, 0])	cylinder(size.z, r, r, $fn = fnRound(size.z));
}

// 모든 모서리를 45도 각도로 잘라낸 것
module cube_type_7(v, c) {
	r = is_undef(c) ? min(v.x, v.y, v.z) / 16 : c;
	stiffen = r * sqrt(2);

	difference() {
		cube(v);

		// 아래 앞쪽
		translate([0, 0, -r])
			rotate([45, 0, 0])
			cube([v.x, stiffen, stiffen]);
		// 앞쪽 위
		translate([0, 0, v.z - r])
			rotate([45, 0, 0])
			cube([v.x, stiffen, stiffen]);
		// 뒤쪽 위
		translate([0, v.y, v.z - r])
			rotate([45, 0, 0])
			cube([v.x, stiffen, stiffen]);
		// 뒤쪽 아래
		translate([0, v.y, -r])
			rotate([45, 0, 0])
			cube([v.x, stiffen, stiffen]);

		// 왼쪽 아래
		translate([-r, 0, 0])
			rotate([0, 45, 0])
			cube([stiffen, v.y, stiffen]);
		// 오른쪽 아래
		translate([v.x - r, 0, 0])
			rotate([0, 45, 0])
			cube([stiffen, v.y, stiffen]);
		// 오른쪽 위
		translate([v.x - r, 0, v.z])
			rotate([0, 45, 0])
			cube([stiffen, v.y, stiffen]);
		// 왼쪽 위
		translate([-r, 0, v.z])
			rotate([0, 45, 0])
			cube([stiffen, v.y, stiffen]);

		// 왼쪽 앞
		translate([0, -r, 0])
			rotate([0, 0, 45])
			cube([stiffen, stiffen, v.z]);
		// 오른쪽 앞
		translate([v.x, -r, 0])
			rotate([0, 0, 45])
			cube([stiffen, stiffen, v.z]);
		// 오른쪽 뒤
		translate([v.x, v.y - r, 0])
			rotate([0, 0, 45])
			cube([stiffen, stiffen, v.z]);
		// 왼쪽 뒤
		translate([0, v.y - r, 0])
			rotate([0, 0, 45])
			cube([stiffen, stiffen, v.z]);
	}
}

module cube_types() {
	//	cube_type_1
	color("white", 1.0)	cube_type_1([16, 32, 4], 12);
	note_type_2("cube_type_1", [16, 32, 4], [12, 32, 4]);
	x1 = 24;
	
	//	cube_type_2
	let (size = [8, 32, 4]) {
		translate([x1, 0, 0]) {
			color("yellow", 1.0)	cube_type_2(size, 12);
			note_type_2("cube_type_2", size, [12, 32, 4]);
		}
	}
	x2 = x1 + 24;

	//	box_type_1: 튜브형태의 네모 박스, 사방 벽면만 있는 형태
	translate([x2, 8, 0])
	{
		color("blue", 0.5)	box_type_1([8, 16, 32], 2);
		color("white", 0.5)	note_type_2("box_type_1", [8, 16, 32]);
	}
	x5 = x2 + 24;

	// cube_type_3: 벡터들을 이용하여 꼭지점을 직각으로만 연결하는 육면체
	translate([x5, 8, 8])
	{
		x = 4;
		y = 8;
		z = 16;
		r = 1;
		v = [
			[0, 0, 0],
			[x, 0, 0],
			[x, y, 0],
			[0, y, 0],
			[0, 0, z],
			[x, 0, z],
			[x, y, z],
			[0, y, z]
		];
		cube_type_3(v, r);
		color("white", 1.0)	
		translate([-r, -r, -r])	note_type_2("cube_type_3(v, 1)", [x, y, z] + [r * 2, r * 2, r * 2]);
	}
	x7 = x5 + 24;

	//	cube_type_1
	translate([x7, 0, 0])
	{
		color("white", 1.0)	cube_type_1([16, 32, 4], 12);
		//	module note_type_2(name, vs, ve, centered = false, fs, detail = false) {
		note_type_2("note_type_2", [16, 32, 4], [12, 32, 4], false, undef, true);
	}
	x12 = x7 + 24;

	//	cube_type_4
	translate([x12, 0, 0])
	{
		color("yellow", 1.0)	cube_type_4([16, 4, 8]);
		note_type_2("cube_type_4([16, 4, 8])", [16, 4, 8]);
	}
	x14 = x12 + 24;

	//	cube_type_5
	let (size = [16, 64, 2]) {
		translate([x14, 0, 0])
		{
			color("white", 1.0)
				cube_type_5(size, 2, 8);
			note_type_2(str("cube_type_5(", size, ", 2, 8)"), size);
		}
	}
	x15 = x14 + 24;

	//	cube_type_6
	let (size = [16, 32, 4]) {
		translate([x15, 0, 0])
		{
			color("yellow", 1.0)
				cube_type_6(size, 4, 2);
			note_type_2(str("cube_type_6(", size, ", 4, 2)"), size);
		}
	}
	x16 = x15 + 24;

	//	cube_type_7
	let (size = [32, 16, 8]) {
		translate([x16, 0, 0])
		{
			color("yellow", 1.0)
				cube_type_7(size, 1);
			note_type_2(str("cube_type_7(", size, ", 1)"), size);
		}
	}
	x17 = x16 + 24;
}
cube_types();
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\common\library_cube.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\common\library_cube.scad
*/