// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<constants.scad>
use <utils.scad>

// z축 0로로
function set_z(v, z) = [v.x, v.y, z];

// 벡터 회전 계산
function rotate_vector(angle, vector) = rotatez_vector(angle[2], rotatey_vector(angle[1], rotatex_vector(angle[0], vector)));
// x축 기준 회전 벡터 회전 계산
function rotatex_vector(anglex, vector) = [
	vector[0],
	-vector[2] * sin(anglex) + vector[1] * cos(anglex),
	vector[2] * cos(anglex) + vector[1] * sin(anglex)
];
// y축 기준 회전 벡터 회전 계산
function rotatey_vector(angley, vector) = [
	vector[0] * cos(angley) + vector[2] * sin(angley),
	vector[1],
	-vector[0] * sin(angley) + vector[2] * cos(angley)
];

// z축 기준 회전 벡터 회전 계산
function rotatez_vector(anglez, vector) = [
	-vector[1] * sin(anglez) + vector[0] * cos(anglez),
	vector[1] * cos(anglez) + vector[0] * sin(anglez),
	vector[2]
];

//	육면체에서 꼭지점들을 벡터로
function	vectors_from_cube(size) = [
	[0,			0,		0],
	[size.x,	0,		0],
	[size.x,	size.y,	0],
	[0,			size.y,	0],

	[0,			0,		size.z],
	[size.x,	0,		size.z],
	[size.x,	size.y,	size.z],
	[0,			size.y,	size.z]
];

// 끝에 반구가 더달린 실린더형태의 3차원 라인
module line_type_1(start, end, r1, r2) {
	r22 = is_undef(r2) ? r1 : r2;
    hull() {
        translate(start) sphere(r1, $fn = FN);
        translate(end) sphere(r22, $fn = FN);
    }

	dx = end.x - start.x;
	dy = end.y - start.y;
	dz = end.z - start.z;
	rx = dy == 0 ? 0 : atan(dz / dy);
	ry = dz == 0 ? 0 : 90 + atan(dx / dz);
	rz = dx == 0 ? 0 : atan(dy / dx);
	d = sqrt(dx * dx + dy * dy + dz * dz);
	fs = max(0.5, min(d / 32, 20));
	%translate([(start.x + end.x) / 2 + max(r1, r22), (start.y + end.y) / 2 + max(r1, r22), (start.z + end.z) / 2 + max(r1, r22)])
		rotate([rx, ry, rz])
		linear_extrude(EPSILON, center = true)	text(str(d, " mm"), size = fs, halign = "center", language = "kr", font = "NanumGothic");
}
*line_type_1([0, 0, 0], [4, 8, 0], 1);

// 밑둥이 잘린 구
module sphere_type_1(r) {
	translate([r, r, r / 2])
	difference() {
		sphere(r, $fn = FN);
		translate([-r * 1.5, -r * 1.5, -r * 4 + r / 2])	cube(r * 3);
	}
}

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

// 치수 표시
module note_type_1(vs, ve, centered = false, fs, detail = false) {
	DEFAULT_MIN_FONT_SIZE = 0.5;

	x = vs.x;
	y = vs.y;
	z = vs.z;
	ex = is_undef(ve) ? vs.x : ve.x;
	ey = is_undef(ve) ? vs.y : ve.y;
	ez = is_undef(ve) ? vs.z : ve.z;
	mm = " mm";	//	"㎜";
	center = centered ? [-vs.x / 2, -vs.y / 2, -vs.z / 2] : [0, 0, 0];
	%color("Black")
	translate(center)
	{
		// x, z view
		xyfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(x, y) / 16, 20)) : fs;
		translate([x / 2, y - xyfs * 1.5, z + EPSILON])
			linear_extrude(EPSILON, center = true)	text(str(ex, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, xyfs * 1.5, z + EPSILON])
			rotate([0, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(ex, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// x, -z view
		if (detail) {
			translate([x / 2, xyfs * 1.5, -EPSILON])
				rotate([180, 0, 0])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y - xyfs * 1.5, -EPSILON])
				rotate([180, 0, 180])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		zxfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(z, x) / 16, 20)) : fs;
		// x, y view
		if (detail) {
			translate([x / 2, y + EPSILON, z - zxfs * 1.5])
				rotate([90, 0, 180])
				linear_extrude(EPSILON, center = true)	text(str(ex, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y + EPSILON, zxfs * 1.5])
				rotate([90, 180, 180])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z - zxfs * 1.5])
			rotate([90, 0, 0])
			linear_extrude(EPSILON, center = true)	text(str(ex, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, -EPSILON, zxfs * 1.5])
			rotate([90, 180, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		yzfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(y, z) / 16, 20)) : fs;
		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z - yzfs * 1.5])
				rotate([90, 0, 90])
				linear_extrude(EPSILON, center = true)	text(str(ey, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x + EPSILON, y / 2, yzfs * 1.5])
				rotate([-90, 0, -90])
				linear_extrude(EPSILON, center = true)	text(str(y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// y, -x view
		translate([-EPSILON, y / 2, yzfs * 1.5])
			rotate([-90, 0, 90])
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([-EPSILON, y / 2, z - yzfs * 1.5])
			rotate([90, 0, -90])
			linear_extrude(EPSILON, center = true)	text(str(ey, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, z view
		translate([(x - ex) / 2 + xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, 90])
			linear_extrude(EPSILON, center = true)	text(str(ey, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - (x - ex) / 2 - xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, -90])
			linear_extrude(EPSILON, center = true)	text(str(ey, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, -z view
		if (detail) {
			translate([x - xyfs * 1.5, y / 2, -EPSILON])
				rotate([180, 0, 90])
				linear_extrude(EPSILON, center = true)	text(str(y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([xyfs * 1.5, y / 2, -EPSILON])
				rotate([180, 0, -90])
				linear_extrude(EPSILON, center = true)	text(str(y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, x view
		if (detail) {
			translate([x + EPSILON, y - yzfs * 1.5, z / 2])
				rotate([90, 90, 90])
				linear_extrude(EPSILON, center = true)	text(str(ez, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x + EPSILON, yzfs * 1.5, z / 2])
				rotate([90, -90, 90])
				linear_extrude(EPSILON, center = true)	text(str(z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, -x view
		translate([-EPSILON, yzfs * 1.5, z / 2])
			rotate([-90, 90, 90])
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([-EPSILON, y - yzfs * 1.5, z / 2])
			rotate([-90, -90, 90])
			linear_extrude(EPSILON, center = true)	text(str(ez, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// z, y view
		if (detail) {
			translate([x - zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, -90, 0])
				linear_extrude(EPSILON, center = true)	text(str(ez, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, 90, 0])
				linear_extrude(EPSILON, center = true)	text(str(z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, -y view
		translate([zxfs * 1.5, -EPSILON, z / 2])
			rotate([90, -90, 0])
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - zxfs * 1.5, -EPSILON, z / 2])
			rotate([90, 90, 0])
			linear_extrude(EPSILON, center = true)	text(str(ez, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
	}
}

// 치수 표시 with name
module note_type_2(name, vs, ve, centered = false, fs, detail = false) {
	DEFAULT_MIN_FONT_SIZE = 0.5;

	x = vs.x;
	y = vs.y;
	z = vs.z;
	ex = is_undef(ve) ? vs.x : ve.x;
	ey = is_undef(ve) ? vs.y : ve.y;
	ez = is_undef(ve) ? vs.z : ve.z;
	mm = " mm";	//	"㎜";
	center = centered ? [-vs.x / 2, -vs.y / 2, -vs.z / 2] : [0, 0, 0];
	xyfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(x, y) / 16, 20)) : fs;
	zxfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(z, x) / 16, 20)) : fs;
	yzfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(y, z) / 16, 20)) : fs;
	note_type_1(vs, ve, centered, fs, detail);
	%color("Black")
	translate(center)
	{
		// x, z view
		translate([x / 2, y / 2, z + EPSILON])
			rotate([0, 0, 180])
			rotate([0, 0, x < y ? 90 : 0])
			linear_extrude(EPSILON, center = true)	text(name, size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// x, -z view
		if (detail) {
			translate([x / 2, y / 2, -EPSILON])
				rotate([180, 0, 180])
				rotate([0, 0, x < y ? 90 : 0])
				linear_extrude(EPSILON, center = true)	text(name, size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, y view
		if (detail) {
			translate([x / 2, y + EPSILON, z / 2])
				rotate([90, 0, 180])
				rotate([0, 0, x < z ? 90 : 0])
				linear_extrude(EPSILON, center = true)	text(name, size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z / 2])
			rotate([90, 0, 0])
			rotate([0, 0, x < z ? 90 : 0])
			linear_extrude(EPSILON, center = true)	text(name, size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z / 2])
				rotate([-90, 180, -90])
				rotate([0, 0, y < z ? 90 : 0])
				linear_extrude(EPSILON, center = true)	text(name, size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// y, -x view
		translate([-EPSILON, y / 2, z / 2])
			rotate([90, 0, -90])
			rotate([0, 0, y < z ? 90 : 0])
			linear_extrude(EPSILON, center = true)	text(name, size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
	}
}

//	튜브형태의 네모 박스, 사방 벽면만 있는 형태
//	size: 외경
module box_type_1(size, thick) {
	cube([size[0], thick, size[2]]);	//	앞
	translate([0, size[1] - thick, 0])	cube([size[0], thick, size[2]]);	//	뒤

	translate([0, 0, 0])	cube([thick, size[1], size[2]]);	//	왼쪽
	translate([size[0] - thick, 0, 0])	cube([thick, size[1], size[2]]);	//	오른쪽
}


module joint_female_type_1(radius, angles, radius1) {
	#sphere(radius);
	r1 = is_undef(radius1) ? radius / 4 : radius1;
	for (cx = [0:len(angles) - 1]) {
		distance = sqrt(angles[cx].x * angles[cx].x + angles[cx].y * angles[cx].y + angles[cx].z * angles[cx].z);
		start = [
			angles[cx].x / distance * r1 * 1.5,
			angles[cx].y / distance * r1 * 1.5,
			angles[cx].z / distance * r1 * 1.5
		];
		end = [
			angles[cx].x / distance * radius,
			angles[cx].y / distance * radius,
			angles[cx].z / distance * radius
		];
		line_type_1(start, end, r1);
	}
}


// 타원통
module ellipsis(x, y, z) {
	translate([x / 2, y / 2, 0])
		resize([x, y, z])
			cylinder(1, 1, 1, $fn = FN);
}

// 검은색 나사못을 박을 자리를 위한 주물, ref) https://github.com/andold/resource3d/blob/main/README.md
module casting_black_25(y, legend = false) {
//	color("Black", 0.5)
		translate([0, 0, -8])
		cylinder(8, 7.9 / 2, 7.9 / 2, $fn = FN);
//	color("Lavender", 0.5)
	{
		cylinder(3, 7.9 / 2, 3.8 / 2, $fn = FN);
		translate([0, 0, 3])	cylinder(y, 3.8 / 2, 3.8 / 2, $fn = FN);
		translate([0, 0, 3 + y])	cylinder(25 - 3 - y, 3.4 / 2, 3.4 / 2, $fn = FN);
	}
	%if (legend) {
		translate([0, -5, -2])	rotate([90, 0, 0])	text("extra for space", 1, halign="center");
		translate([0, -5, 1])	rotate([90, 0, 0])	text("7.9 mm", 1, halign="center");
		translate([0, -3, 8])	rotate([90, 0, 0])	text("3.8 mm", 1, halign="center");
		translate([0, -3, 24])	rotate([90, 0, 0])	text("3.4 mm", 1, halign="center");

		translate([5, 4, 1])	rotate([90, 90, 0])	text("3.0 mm", 1, halign="center");
		translate([2, 2, 6])	rotate([90, 90, 0])	text(str(y, " mm"), 1, halign="center");
		translate([2, 1.5, 20])	rotate([90, 90, 0])	text(str(25 - 3 - y, " mm"), 1, halign="center");
	}
}

module samples() {
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

	//	sphere_type_1
	color("green", 1.0)	
	translate([x2, 8, 0])
	{
		sphere_type_1(8);
		note_type_1([16, 16, 12], [16, 16, 12]);
		translate([4, -4, 0])	text("sphere_type_1(8)", size = 1);
	}
	x3 = x2 + 16 + 4;

	// cylinder_type_1 끝이 구인 실린더
	color("pink", 1.0)
	{
		line_type_1([x3, 16, 0], [x3 + 2, 16, 32], 4, 2);
		translate([68, 16, 0])
		{
			translate([0, 0, 16])	note_type_1([8, 8, 32], [4, 4, 32], true);
			translate([-8, -12, 0])	text("line_type_1([68, 16, 0], [70, 16, 32], 4, 2)", size = 1);
		}
	}
	x4 = x3 + 32;

	//	box_type_1: 튜브형태의 네모 박스, 사방 벽면만 있는 형태
	translate([x4, 8, 0])
	{
		color("blue", 0.5)	box_type_1([8, 16, 32], 2);
		color("white", 0.5)	note_type_1([8, 16, 32]);
		translate([-4, -2, 0])	text("box_type_1([8, 16, 32], 2)", size = 1);
	}
	x5 = x4 + 24;

	//	joint_female_type_1
	translate([x5, 8, 8])
	{
		joint_female_type_1(4, [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [1, 1, 1]]);
		color("white", 1.0)	
		note_type_1([8, 8, 8], [8, 8, 8], true);
		translate([-8, -10, 0])	text("joint_female_type_1(4, [[1, 0, 0], ...[1, 1, 1]]", size = 1);
	}
	x6 = x5 + 24;

	// cube_type_3: 벡터들을 이용하여 꼭지점을 직각으로만 연결하는 육면체
	translate([x6, 8, 8])
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
	x7 = x6 + 16;

	// ellipsis: 타원통
	translate([x7, 8, 8])
	{
		color("green", 1.0)	
		ellipsis(8, 4, 16);
		color("white", 1.0)	
		note_type_1([8, 4, 16]);
		translate([0, -4, 0])	text("ellipsis(8, 4, 16)", size = 1);
	}

// 검은색 나사못을 박을 자리를 위한 주물, ref) https://github.com/andold/resource3d/blob/main/README.md
	translate([0, 64, 0])
	{
		casting_black_25(8, true);
		translate([-4, -8, 0])	text("casting_black_25(8)", size = 1);
	}
	x11 = 16 + 4;

	//	cube_type_1
	translate([x11, 64, 0])
	{
		color("white", 1.0)	cube_type_1([16, 32, 4], 12);
		//	module note_type_2(name, vs, ve, centered = false, fs, detail = false) {
		note_type_2("note_type_2", [16, 32, 4], [12, 32, 4], false, undef, true);
	}
	x12 = x11 + 16 + 4;

	translate([x12, 64, 0])
	line_type_1([0, 0, 0], [4, 8, 12], 1);
}
samples();