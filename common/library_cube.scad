// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>
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

// x 축으로의 모서리의 일부 각을 제거한 것
module cube_type_4(v, c) {
	r = is_undef(c) ? min(v.y, v.z) / 16 : c;
	stiffen = r * sqrt(2);

	translate([0, r, 0])		cube(v - [0, r * 2, 0]);
	translate([0, 0, r])		cube(v - [0, 0, r * 2]);
	translate([0, r, 0])				rotate([45, 0, 0])	cube([v.x, r, r]);
	translate([0, r, v.z - r * 2])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
	translate([0, v.y - r, v.z - r * 2])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
	translate([0, v.y - r, 0])		rotate([45, 0, 0])	cube([v.x, stiffen, stiffen]);
}

// xy평면에 격자 모형, 45도
module cube_type_5(size, wall) {
	intersection() {
		cube(size);
		for(cx = [0: wall * 4: size.x + size.y]) {
			translate([cx, - wall * sqrt(2), 0])	rotate([0, 0, 45])	cube([wall, size.y * 2, size.z]);
			translate([cx - size.y, - wall * sqrt(2), 0])	rotate([0, 0, -45])	cube([wall, size.y * 2, size.z]);
		}
	}
}

module cube_types() {
	//	cube_type_1
	color("white", 1.0)	cube_type_1([16, 32, 4], 12);
	note_type_1([16, 32, 4], [12, 32, 4]);
	translate([4, 24, 4])	text("cube_type_1", size = 1);
	translate([4, 22, 4])	text("[16, 32, 4], 12", size = 1);
	translate([4, 20, 4])	text("note_type_1", size = 1);
	x1 = 16 + 4;
	
	//	cube_type_2
	translate([x1, 0, 0]) {
		color("yellow", 1.0)	cube_type_2([16, 32, 4], 20);
		note_type_1([16, 32, 4], [12, 32, 4]);
		translate([4, 24, 4])	text("cube_type_2", size = 1);
		translate([4, 22, 4])	text("[16, 32, 4], 20", size = 1);
	}
	x2 = x1 + 16 + 4;

	//	box_type_1: 튜브형태의 네모 박스, 사방 벽면만 있는 형태
	translate([x2, 8, 0])
	{
		color("blue", 0.5)	box_type_1([8, 16, 32], 2);
		color("white", 0.5)	note_type_1([8, 16, 32]);
		translate([-4, -2, 0])	text("box_type_1([8, 16, 32], 2)", size = 1);
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
		translate([-r, -r, -r])	note_type_1([x, y, z] + [r * 2, r * 2, r * 2]);
		translate([0, -4, 0])	text("cube_type_3(v, 1)", size = 1);
	}
	x7 = x5 + 16;

	//	cube_type_1
	translate([x7, 64, 0])
	{
		color("white", 1.0)	cube_type_1([16, 32, 4], 12);
		//	module note_type_2(name, vs, ve, centered = false, fs, detail = false) {
		note_type_2("note_type_2", [16, 32, 4], [12, 32, 4], false, undef, true);
	}
	x12 = x7 + 16 + 4;

	//	cube_type_4
	translate([x12, 64, 0])
	{
		cube_type_4([16, 4, 8]);
		note_type_2("cube_type_4([16, 4, 8])", [16, 4, 8]);
	}
	x14 = x12 + 24;

	//	cube_type_5
	translate([x14, 64, 0])
	{
		cube_type_5([32, 64, 2], 2);
		note_type_2("cube_type_5([32, 64, 2], 2)", [32, 64, 2]);
	}
	x15 = x14 + 24;

}
cube_types();