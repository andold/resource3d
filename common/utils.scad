// 유용한 것들, 검증된 것만
use <MCAD/boxes.scad>
include	<constants.scad>

// 가장 긴 족의 2.1배
function big(v) = [
	max(v.x, v.y, v.z) * 2.1,
	max(v.x, v.y, v.z) * 2.1,
	max(v.x, v.y, v.z) * 2.1
];

// 임시
module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly);
}

// 라이브러리 아닌가
module windows(x, y, z, dx = 4, dy = 4, countx = 2, county = 2) {
//	echo(x, y, z, dx, dy, countx, county);
	w = (x + dx) / countx;
	h = (y + dy) / county;
	for (cw = [0:w:x - dx]) {
		for (ch = [0:h:y - dy]) {
			translate([cw, ch, -1])
				roundedBoxNotCenter([w - dx, h - z, z * 4], z / 2, true);
		}
	}
}

// 벡터 회전 계산
function rotate_vector(angle, vector) = [
	rotatez_vector(angle[2], rotatey_vector(angle[1], rotatex_vector(angle[0], vector)))[0],
	rotatez_vector(angle[2], rotatey_vector(angle[1], rotatex_vector(angle[0], vector)))[1],
	rotatez_vector(angle[2], rotatey_vector(angle[1], rotatex_vector(angle[0], vector)))[2]
];
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

//	끝이 구인 선
module line_sphere(start, end, thickness = 1) {
    hull() {
        translate(start) sphere(thickness);
        translate(end) sphere(thickness);
    }
}

// 치수 표시, 라이브러리가 더 적합할 듯
module note(x, y, z, centered = false, fs, detail = false) {
	echo("note", x, y, z, centered, fs, detail);
	mm = " mm";	//	"㎜";
	center = centered ? [-x / 2, -y / 2, -z / 2] : [0, 0, 0];
	%color("Black")
	translate(center)
	{
		// x, z view
		xyfs = is_undef(fs) ? max(1, min(min(x, y) / 16, 20)) : 1;
		translate([x / 2, y - xyfs * 1.5, z + EPSILON])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, xyfs * 1.5, z + EPSILON])
			rotate([0, 0, 180])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

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
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
			translate([x / 2, y + EPSILON, zxfs * 1.5])
				rotate([90, 180, 180])
				linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		}

		// x, -y view
		translate([x / 2, -EPSILON, z - zxfs * 1.5])
			rotate([90, 0, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x / 2, -EPSILON, zxfs * 1.5])
			rotate([90, 180, 0])
			linear_extrude(EPSILON, center = true)	text(str(x, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");

		yzfs = is_undef(fs) ? max(1, min(min(y, z) / 16, 20)) : 1;
		// y, x view
		if (detail) {
			translate([x + EPSILON, y / 2, z - yzfs * 1.5])
				rotate([90, 0, 90])
				linear_extrude(EPSILON, center = true)	text(str(y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// y, z view
		translate([xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, 90])
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");
		translate([x - xyfs * 1.5, y / 2, z + EPSILON])
			rotate([0, 0, -90])
			linear_extrude(EPSILON, center = true)	text(str(y, mm), size = xyfs, halign = "center", language = "kr", font = "NanumGothic");

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
				linear_extrude(EPSILON, center = true)	text(str(z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = yzfs, halign = "center", language = "kr", font = "NanumGothic");

		// z, y view
		if (detail) {
			translate([x - zxfs * 1.5, y + EPSILON, z / 2])
				rotate([-90, -90, 0])
				linear_extrude(EPSILON, center = true)	text(str(z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
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
			linear_extrude(EPSILON, center = true)	text(str(z, mm), size = zxfs, halign = "center", language = "kr", font = "NanumGothic");
	}
}
module boardPattern(size = [128, 64, 4], degree = 60, stick = [THICK, THICK, 32]) {
	intersection() {
		cube([size[0], size[1], stick[1]]);
		for (dx = [-1024: stick[2]: 1024]) {
			translate([dx, -cos(degree) * stick[1], -1])	rotate([0, 0, degree])	cube([1024, stick[0], stick[1]]);
			mirror([1, 0, 0])
			translate([dx, -cos(degree) * stick[1], -1])	rotate([0, 0, degree])	cube([1024, stick[0], stick[1]]);
		}
	}
}

// 제외 예정
module mark(name, height, size = 2) {
	linear_extrude(height, center = false)	text(name, size = size);
}

// 제외 예정
module hole(w, h, z) {
	translate([w / 2, h / 2, z / 2])		roundedBox(size=[w, h, z], radius = w / 4, sidesonly = true);
}

// 모호하다
module ellipsis(w = 32, h = 16, z = 4) {
	translate([w / 2, h / 2, 0])
		resize([w, h, z])
			cylinder(1024, 1024, 1024);
}

// 제외 예정
module cornerHole(base, m, in, out, height) {
	delta = (out - in) / 2;
		translate([m,					m,					0])	ellipsis(in, in);
		translate([base[0] - m,	m,					0])	ellipsis(in, in);
		translate([base[0] - m,	base[1] - m,		0])	ellipsis(in, in);
		translate([m,					base[1] - m,		0])	ellipsis(in, in);

		translate([m - delta,					m - delta,					height])	ellipsis(out, out);
		translate([base[0] - m  - delta,	m - delta,					height])	ellipsis(out, out);
		translate([base[0] - m  - delta,	base[1] - m - delta,	height])	ellipsis(out, out);
		translate([m - delta,					base[1] - m - delta,	height])	ellipsis(out, out);
}

// 제외 예정
module lineBox(outter = [100, 100, 100], t = 2) {
	size = outter - [t*2, t*2, t*2];
	center = false;

	translate([t, t, t])	{
		
	// x
	translate([0, 0, 0])						rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, size[1], 0])			rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, size[1], size[2]])	rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);
	translate([0, 0, size[2]])			rotate([0, 90, 0])		cylinder(h = size[0], r = t, center = center);

	// y
	translate([0, 0, 0])						rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([size[0], 0, 0])			rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([size[0], 0, size[2]])	rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);
	translate([0, 0, size[2]])			rotate([270, 0, 0])		cylinder(h = size[1], r = t, center = center);

	// z
	translate([0, 0, 0])						rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([size[0], 0, 0])			rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([size[0], size[1], 0])	rotate([0, 0, 0])		cylinder(h = size[2], r = t, center = center);
	translate([0, size[1], 0])	rotate([0, 0, 0])				cylinder(h = size[2], r = t, center = center);
	}
}

// 제외 예정
module hide(show = 0) {
	if (show > 0) children();
	else scale([0, 0, 0])	children();
}

module samples() {
	cube([32, 16, 4]);
	note(32, 16, 4);
}
samples();