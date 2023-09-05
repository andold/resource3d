// 유용한 것들, 검증된 것만
use <MCAD/boxes.scad>
include	<constants.scad>
include	<library.scad>

// 가장 긴 족의 2.1배
function big(v) = [
	max(v.x, v.y, v.z) * 2.1,
	max(v.x, v.y, v.z) * 2.1,
	max(v.x, v.y, v.z) * 2.1
];

// 임시
module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly, $fn = FN);
}

// 라이브러리 아닌가
module windows(x, y, z, dx = 4, dy = 4, countx = 2, county = 2) {
//	echo(x, y, z, dx, dy, countx, county);
	w = (x + dx) / countx;
	h = (y + dy) / county;
	for (cw = [0:w:x - dx]) {
		for (ch = [0:h:y - dy]) {
			translate([cw, ch, -1])
				roundedBoxNotCenter([w - dx, h - z, z * 4], z / 2, true, $fn = FN);
		}
	}
}

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

//	끝이 구인 선
module line_sphere(start, end, thickness = 1) {
    hull() {
        translate(start) sphere(thickness, $fn = FN);
        translate(end) sphere(thickness, $fn = FN);
    }
}

// 치수 표시, 라이브러리가 더 적합할 듯
// deprecated. use note_type_1 in library
module note(x, y, z, centered = false, fs, detail = false) {
	note_type_1([x, y, z], [x, y, z], centered, fs, detail);
	echo("WARNING! module note in utils.scad was DEPRECATED. USE note_type_1 in library. called by ", parent_module(1), $parent_modules);
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


module samples() {
	cube([32, 16, 4]);
	note(32, 16, 4);
}
samples();