// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>
use <library_function.scad>

function fsproper(x, y, title) = min(x / len(title) / 4, y / 2);

/*
	모듈 섹션
*/

//	text() builtin 함수 대체용, 줄바꿈 출력
module text0(t, size = 10, font = "D2Coding", halign = "left", valign = "baseline", spacing = 1, hspacing = 1.5, direction = "ltr", language = "en", script = "latin") {

	lines = split(t, "\n");
	for (cx = [0:len(lines) - 1]) {
		translate([0, -cx * (size * hspacing)])
		text(lines[cx], size = size, font = font, halign = halign, valign = valign, spacing = spacing, direction = direction, language = language, script = script);
	}
}

//	2D 텍스트 또는 이미지를 (0, 0, 0)를 기준으로 xy평면에서 -z축으로 thick mm만큼 새긴다.
//	offset을 이용하여 양각으로 파낸다.
module carve(string, rotate = [0, 0, 0], translate = [0, 0, 0], offset = 1, preview = false, size = 10, font = "D2Coding", halign = "left", valign = "baseline", spacing = 1, hspacing = 1.5, direction = "ltr", language = "en", script = "latin") {
//	echo(str(parent_module(0), ".", parent_module(1), "(", string, ", ", rotate, ", ", translate, ", ", offset, ", ", preview, ", ", size, ", ", font, ", ", halign, ", ", valign, ", ", spacing, ", ", hspacing, ", ", direction, ", ", language, ", ", script, ")"));
	assert(!is_undef(string));

	slice = 0.1;
	thisRotate = preview ? [0, 0, 0] : rotate * -1;
	thisTranslate = preview ? [0, 0, 0] : translate;

	rotate([thisRotate.x, 0, 0])
	rotate([0, thisRotate.y, 0])
	rotate([0, 0, thisRotate.z])
	translate(thisTranslate) {
		difference() {
			//	전체 몸통
			translate(translate * -1)
				rotate(rotate)
					children();

			//	파내는 거, 차감하는 거
			for (cx = [0:(offset / slice) - 1]) {
				//	현재 처리해야할 위치 및 간격을 길이(mm) 단위로 환원
				mm = cx * slice;
				//	첫번째 위치, 즉 맨 위쪽의 표면에 해당하는 것은 좀더 깍아야 openscad의 프리뷰에 도움이 된다.
				extrudeHeight = (cx == 0) ? slice + EPSILON : slice;

				translate([0, 0, -slice - mm]) {
					difference() {
						linear_extrude(height = extrudeHeight, center = false, scale = 1)
						offset(delta = offset * 2 - mm)
				text0(string, size = size, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);

						linear_extrude(height = extrudeHeight, center = false, scale = 1)
						offset(delta = mm)
				text0(string, size = size, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);
					}
				}
			}
		}
		translate([0, 0, -offset]) {
			linear_extrude(height = offset, center = false, scale = 1) {
				text0(string, size = size, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);
			}
		}
	}
}

//	text와 carve를 함께 섞어 놓은 것. 출력되지 않는다.
module note(string, rotate = [0, 0, 0], translate = [0, 0, 0], offset = 1, preview = false, size = 10, font = "D2Coding", halign = "left", valign = "baseline", spacing = 1, hspacing = 1.5, direction = "ltr", language = "en", script = "latin") {
	thisRotate = preview ? [0, 0, 0] : rotate * -1;
	thisTranslate = preview ? [0, 0, 0] : translate;

	rotate(thisRotate)
	translate(thisTranslate) {
		translate(translate * -1)
		rotate(rotate)
		children();

		%text0(string, size = size, font = font, halign = halign, valign = valign, spacing = spacing, hspacing = hspacing, direction = direction, language = language, script = script);
	}
}

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
