// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>
use <library_function.scad>

function fsproper(x, y, title) = min(x / len(title) / 4, y / 2);

/*
	모듈 섹션
*/

// 치수 표시
module note_type_1(vs, ve, centered = false, fs, detail = false) {
	DEFAULT_MIN_FONT_SIZE = 0.2;

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
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ex, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, xyfs * 1.5, z + EPSILON])
			rotate([0, 0, 180])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ex, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// x, -z view
		if (detail) {
			translate([x / 2, xyfs * 1.5, -EPSILON])
				rotate([180, 0, 0])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(x, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y - xyfs * 1.5, -EPSILON])
				rotate([180, 0, 180])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(x, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		zxfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(z, x) / 16, 20)) : fs;
		// x, y view
		if (detail) {
			translate([x / 2, y + EPSILON, z - zxfs * 1.5])
				rotate([90, 0, 180])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(ex, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y + EPSILON, zxfs * 1.5])
				rotate([90, 180, 180])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(x, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z - zxfs * 1.5])
			rotate([90, 0, 0])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ex, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, -EPSILON, zxfs * 1.5])
			rotate([90, 180, 0])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(x, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		yzfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(y, z) / 16, 20)) : fs;
		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z - yzfs * 1.5])
				rotate([90, 0, 90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(ey, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x + EPSILON, y / 2, yzfs * 1.5])
				rotate([-90, 0, -90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(y, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// y, -x view
		translate([-EPSILON, y / 2, yzfs * 1.5])
			rotate([-90, 0, 90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(y, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([-EPSILON, y / 2, z - yzfs * 1.5])
			rotate([90, 0, -90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ey, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, z view
		translate([(x - ex) / 2 + xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, 90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ey, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - (x - ex) / 2 - xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, -90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ey, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, -z view
		if (detail) {
			translate([x - xyfs * 1.5, y / 2, -EPSILON])
				rotate([180, 0, 90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(y, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([xyfs * 1.5, y / 2, -EPSILON])
				rotate([180, 0, -90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(y, 2), mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, x view
		if (detail) {
			translate([x + EPSILON, y - yzfs * 1.5, z / 2])
				rotate([90, 90, 90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(ez, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x + EPSILON, yzfs * 1.5, z / 2])
				rotate([90, -90, 90])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(z, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, -x view
		translate([-EPSILON, yzfs * 1.5, z / 2])
			rotate([-90, 90, 90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(z, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([-EPSILON, y - yzfs * 1.5, z / 2])
			rotate([-90, -90, 90])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ez, 2), mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// z, y view
		if (detail) {
			translate([x - zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, -90, 0])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(ez, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, 90, 0])
				linear_extrude(EPSILON, center = true)
				text(str(strfix(z, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// z, -y view
		translate([zxfs * 1.5, -EPSILON, z / 2])
			rotate([90, -90, 0])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(z, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - zxfs * 1.5, -EPSILON, z / 2])
			rotate([90, 90, 0])
			linear_extrude(EPSILON, center = true)
			text(str(strfix(ez, 2), mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
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
	xyfs = is_undef(fs)
			? max(	DEFAULT_MIN_FONT_SIZE,
					(x > y && y >= z)
						? fsproper(x, y, name)
						: min(min(x, y) / 16, 20)
			)
			: fs;
	zxfs = is_undef(fs)
			? max(	DEFAULT_MIN_FONT_SIZE,
					(z > x && x >= y)
						? fsproper(z, x, name)
						: min(min(z, x) / 16, 20)
			)
			: fs;
	yzfs = is_undef(fs) ? max(DEFAULT_MIN_FONT_SIZE, min(min(y, z) / 16, 20)) : fs;
	note_type_1(vs, ve, centered, fs, detail);
	%color("Black")
	translate(center)
	{
		// x, z view
		translate([x / 2, y / 2, z + EPSILON])
			rotate([0, 0, 180])
			rotate([0, 0, x < y ? 90 : 0])
			linear_extrude(EPSILON, center = true)
			text(name, size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

		// x, -z view
		if (detail) {
			translate([x / 2, y / 2, -EPSILON])
				rotate([180, 0, 180])
				rotate([0, 0, x < y ? 90 : 0])
				linear_extrude(EPSILON, center = true)
				text(name, size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, y view
		if (detail) {
			translate([x / 2, y + EPSILON, z / 2])
				rotate([90, 0, 180])
				rotate([0, 0, x < z ? 90 : 0])
				linear_extrude(EPSILON, center = true)
				text(name, size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z / 2])
			rotate([90, 0, 0])
			rotate([0, 0, x < z ? 90 : 0])
			linear_extrude(EPSILON, center = true)
			text(name, size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z / 2])
				rotate([-90, 180, -90])
				rotate([0, 0, y < z ? 90 : 0])
				linear_extrude(EPSILON, center = true)
				text(name, size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// y, -x view
		translate([-EPSILON, y / 2, z / 2])
			rotate([90, 0, -90])
			rotate([0, 0, y < z ? 90 : 0])
			linear_extrude(EPSILON, center = true)
			text(name, size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
	}
}
