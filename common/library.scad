// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<constants.scad>
use <utils.scad>

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
// 치수 표시
module note_type_1(vs, ve, centered = false, fs, detail = false) {
	x = vs.x;
	y = vs.y;
	z = vs.z;
	mm = " mm";	//	"㎜";
	center = centered ? [-vs.x / 2, -vs.y / 2, -vs.z / 2] : [0, 0, 0];
	%color("Black")
	translate(center)
	{
		// x, z view
		xyfs = is_undef(fs) ? max(1, min(min(x, y) / 16, 20)) : 1;
		translate([x / 2, y - xyfs * 1.5, z + EPSILON])
			linear_extrude(EPSILON, center = true)	text(str(ve.x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, xyfs * 1.5, z + EPSILON])
			rotate([0, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(ve.x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// x, -z view
		if (detail) {
			translate([x / 2, xyfs * 1.5, -EPSILON])
				rotate([180, 0, 0])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y - xyfs * 1.5, -EPSILON])
				rotate([180, 0, 180])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		zxfs = is_undef(fs) ? max(1, min(min(z, x) / 16, 20)) : 1;
		// x, y view
		if (detail) {
			translate([x / 2, y + EPSILON, z - zxfs * 1.5])
				rotate([90, 0, 180])
				linear_extrude(EPSILON, center = true)	text(str(ve.x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y + EPSILON, zxfs * 1.5])
				rotate([90, 180, 180])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z - zxfs * 1.5])
			rotate([90, 0, 0])
			linear_extrude(EPSILON, center = true)	text(str(ve.x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, -EPSILON, zxfs * 1.5])
			rotate([90, 180, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		yzfs = is_undef(fs) ? max(1, min(min(y, z) / 16, 20)) : 1;
		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z - yzfs * 1.5])
				rotate([90, 0, 90])
				linear_extrude(EPSILON, center = true)	text(str(ve.y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(ve.y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, z view
		translate([(x - ve.x) / 2 + xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, 90])
			linear_extrude(EPSILON, center = true)	text(str(ve.y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - (x - ve.x) / 2 - xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, -90])
			linear_extrude(EPSILON, center = true)	text(str(ve.y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

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
				linear_extrude(EPSILON, center = true)	text(str(ve.z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(ve.z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// z, y view
		if (detail) {
			translate([x - zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, -90, 0])
				linear_extrude(EPSILON, center = true)	text(str(ve.z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(ve.z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
	}
}

module samples() {
	//	cube_type_1
	color("white", 1.0)	cube_type_1([16, 32, 4], 12);
	note_type_1([16, 32, 4], [12, 32, 4]);
	
	//	cube_type_2
	translate([20, 0, 0]) {
		color("yellow", 1.0)	cube_type_2([16, 32, 4], 20);
		note_type_1([16, 32, 4], [12, 32, 4]);
	}
}
samples();