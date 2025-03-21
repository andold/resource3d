// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<constants.scad>
use <library_function.scad>
use <library_text.scad>
use <library_cube.scad>
use <utils.scad>

/*
	모듈 섹션
*/
// 상하 모서리의 일부 각을 제거한 것
module cylinder_type_1(height, radious, cut) {
	fn = fnRound(radious);
	translate([0, 0, 0])			cylinder(cut,				radious - cut,	radious,		$fn = fn);
	translate([0, 0, cut])			cylinder(height - cut * 2,	radious,		radious,		$fn = fn);
	translate([0, 0, height - cut])	cylinder(cut,				radious,		radious - cut,	$fn = fn);
}

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

// 밑둥이 잘린 구
module sphere_type_1(r) {
	translate([r, r, r / 2])
	difference() {
		sphere(r, $fn = FN);
		translate([-r * 1.5, -r * 1.5, -r * 4 + r / 2])	cube(r * 3);
	}
}

/*
	홈파기, 트리머
*/
//	외경계산결과, r: 반지름, delta: 한쪽 여유
function trimmer_type_1_height(r, delta, y, z) =
	z	+ sqrt((r + delta) * (r + delta) - (r - delta) * (r - delta))
		+ sqrt((r + delta) * (r + delta) - ((r + delta) * sin(OVERHANG_THRESHOLD)) * ((r + delta) * sin(OVERHANG_THRESHOLD)))
		+ ((r + delta) * sin(OVERHANG_THRESHOLD)) * sin(OVERHANG_THRESHOLD)
;
module trimmer_type_1(r, delta, y, z) {
	r2 = r * 2;			//	지름
	delta2 = delta * 2;	//	양쪽 여유 합
	rplus = r + delta;
	rminus = r - delta;

	// 진입로
	cube_type_1([rplus * 2, y, z], rminus * 2);
	// 정착
	translate([rplus, 0, z + sqrt(rplus * rplus - rminus * rminus)])
		rotate([-90, 0, 0])
		cylinder(y, rplus, rplus, $fn = fnRound(rplus));
	// 오버행 제거
	let (
		x = rplus * sin(OVERHANG_THRESHOLD),
		z_start = z + sqrt(rplus * rplus - rminus * rminus) + sqrt(rplus * rplus - x * x),
	
		reserved = 0
	) {
		translate([rplus - x, 0, z_start])
			cube_type_1([x * 2, y, x * sin(OVERHANG_THRESHOLD)], 0);

		note_type_1([rplus * 2, y, z_start + x * sin(OVERHANG_THRESHOLD)]);
	}
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
	translate([0, 0, -8])
		cylinder(8, 7.9 / 2, 7.9 / 2, $fn = fnRound(4));
//	color("Lavender", 0.5)
	{
		cylinder(3, 7.9 / 2, 3.8 / 2, $fn = fnRound(4));
		translate([0, 0, 3])	cylinder(y, 3.8 / 2, 3.8 / 2, $fn = fnRound(2));
		translate([0, 0, 3 + y])	cylinder(25 - 3 - y, 3.4 / 2, 3.4 / 2, $fn = fnRound(2));
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
	x13 = x12 + 24;
	
	translate([x13, 64, 0])
	{
		cube_type_4([16, 4, 8]);
		note_type_2("cube_type_4([16, 4, 8])", [16, 4, 8]);
	}
	x14 = x13 + 24;

	translate([x14, 64, 0])
	{
		cylinder_type_1(8, 4, 1);
		note_type_2("cylinder_type_1(8, 4, 1)", [8, 8, 8], [8, 8, 8], true, undef, true);
	}
	x15 = x14 + 24;

	translate([x15, 64, 0])
	{
		trimmer_type_1(4, MINIMUM, 32, 4);
		translate([-8, -4, 0])	rotate([0, 0, 0])	text("trimmer_type_1(4, MINIMUM, 32, 4)", size = 1);
	}
}
samples();