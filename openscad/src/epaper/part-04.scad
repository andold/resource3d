include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-06.scad>	//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
use <part-07.scad>	//	연결 부속, 수직 최대각도는 45도.

//	패널 밑에 받치는 밑판
ID = "④";
COLOR = [0.8, 0.4, 0.3, 1];

p6 = PART06();
size6 = p6[0][0];
//echo("..............", size6 = size6);

NOTE_MARGIN = 6;

p2 = PART02();
s2 = p2[0][0];	//	디스플레이 패널의 크기
m2 = p2[0][1];	//	디스플레이 패널의 필요(필수) 여백

p3 = PART03();

function PART04(v = [
		[undef, undef, 2, "밑판의 높이"],
		[3, 3, 1, "둔덕의 크기", "upstairs"],
		[0.5, 0.5, 0.2, "패널 확보 여백", "marginActive"],
		[3/4, "모서리 대패의 반경"],
		[16, 16, "밑판 최외곽 최소 너비", "rail"],
		[0.5, 8, "밑판 구멍내는 비율 및 원의 크기"],
		"패널 밑에 받치는 밑판"
	]) = let(
			upstairs = v[1],
			marginActive = v[2],
			size3 = p3[0]
			) [[
		[
			upstairs.x * 2 + marginActive.x * 2 + size6.x,
			upstairs.y * 2 + marginActive.y * 2 + size6.y,
			v[0].z + upstairs.z,
			"계산된 전체 외경, sizeLowerOutter"
		],
		[
			marginActive.x * 2 + size6.x,
			marginActive.y * 2 + size6.y,
			upstairs.z,
			"계산된 내경, sizeLowerInner"
		],
		for (cx = v) cx
	],
	p2,
	p3
];
/*
p4 = PART04();	//	패널 밑에 받치는 밑판
s4 = p4[0][0];
psize = v[0][0];	//	밑판 외경
size4 = v[0][0];	//	밑판 외경
height = v[0][2].z;	//	밑판 1층의 높이
upstairs = v[0][3];	//	밑판 2층 둔덕의 크기
marginActive = v[0][4];	//	패널 확보 여백
radius = v[0][5][0];	//	모서리 대패의 반경
rail = v[0][6];		//	밑판 최외곽 최소 너비
hole = v[0][7];		//	밑판 구멍내는 비율 및 원의 크기
/* */

//	밑판 구멍내기
module epaper_part_04a1(v) {
//	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	s4 = v[0][0];		//	전체 외경
	height = v[0][2].z;	//	밑판의 높이
	margin = v[0][6];	//	밑판 최외곽 최소 너비
	hole = v[0][7];		//	밑판 구멍내는 비율 및 원의 크기

	percent = hole[0];
	radius = hole[1];
	
	size = [s4.x - margin.x * 2, s4.y - margin.y * 2, height];	//	계산된 크기
	areaBase = size.x * size.y;
	areaCircle = PI * radius * radius;
	county = floor(sqrt(areaBase / areaCircle * percent));
	countx = floor(size.x * county / size.y);
	delta = [
		(size.x - radius * 2 * countx) / (countx - 1),
		(size.y - radius * 2 * county) / (county - 1)
	];

	$fn = $preview ? 8 : 32;
	for (cx = [0:countx - 1]) {
		for (cy = [0:county - 1]) {
			translate([cx * (radius * 2 + delta.x) + radius, cy * (delta.y + radius * 2) + radius, -EPSILON])
			cylinder(size.z + EPSILON * 2, radius, radius);
		}
	}
}

module epaper_part_04a_note(v) {
//	echo("밑판 수치 표시", str(parent_module(0), "(", v[0][0], ")"));

	assert(!is_undef(v));

	s4 = v[0][0];		//	전체 외경
	height = v[0][2].z;	//	밑판의 높이
	margin = v[0][6];	//	밑판 최외곽 최소 너비
	radius = v[0][5][0];	//	모서리 대패의 반경
	size = [s4.x - radius * 2, s4.y - radius * 2, height - radius];
	fs = min(size);
//	echo(s4 = s4, height = height, margin = margin, radius = radius);

	//	가로
	translate([0, -NOTE_MARGIN, size.z])
	notate([size.x, fs]);

	//	세로
	translate([-NOTE_MARGIN, 0, size.z])
	notate([fs, size.y]);

	translate([-NOTE_MARGIN, 0, 0])
	rotate([90, 0, 0])
	notate([fs, size.z]);
}

//	밑판
module epaper_part_04a(v) {
//	echo(str(parent_module(0), "(", v[0][0], ")"));

	assert(!is_undef(v));

	s4 = v[0][0];		//	전체 외경
	height = v[0][2].z;	//	밑판의 높이
	margin = v[0][6];	//	밑판 최외곽 최소 너비
	radius = v[0][5][0];	//	모서리 대패의 반경
	size = [s4.x - radius * 2, s4.y - radius * 2, height - radius * 2];
	fs = min(size);
//	echo(parent_module(0), s4 = s4, height = height, margin = margin, radius = radius, size = size, fs = fs);

	difference() {
		//	통짜
		color(COLOR)
		cube(size);

		//	구멍
		translate([margin.x, margin.y, 0])
		epaper_part_04a1(v);	//	구멍
	}
	
	epaper_part_04a_note(v);
}

//	위판
module epaper_part_04b(v) {
//	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	psize = v[0][0];	//	전체 외경
	upstairs = v[0][3];	//	둔덕의 크기
	height = v[0][2].z;	//	밑판의 높이
	radius = v[0][5][0];	//	모서리 대패의 반경
	margin = v[2][1];	//	연결단자의 위치

	//	외경
	size = [psize.x - radius * 2, psize.y - radius * 2, upstairs.z];
//	echo(parent_module(0), psize = psize, size = size, radius = radius);
	padding = [upstairs.x - radius * 2, upstairs.y - radius * 2, upstairs.z - radius];
	fs = 0.5;

	//	색상을 밑판보다 진하게
	cdelta = 0.1;
	ccolor = [COLOR[0] - cdelta, COLOR[1] - cdelta, COLOR[2] - cdelta, COLOR[3]];

	translate([0, 0, height - radius * 2]) {
		// 아래
		translate([0, 0, 0])
		color(ccolor)
		cube([size.x, padding.y, size.z]);
		translate([-NOTE_MARGIN+2, 0, 0])	notateV([fs, padding.y]);
		translate([size.x / 2, 0, 0])		notateV([fs, padding.y]);
		translate([-NOTE_MARGIN+2, 0, 0])
		rotate([90, 0, 0])
		notateV([fs, size.z]);

		//	위
		translate([0, size.y - padding.y, 0])
		{
			color(ccolor)
			cube([size.x, padding.y, size.z]);
			translate([0, 0, size.z])
			notate([size.x, fs]);
			translate([-NOTE_MARGIN, 0, 0])
			rotate([90, 0, 0])
			notate([min(size.z / 2, fs), size.z]);
		}

		//	왼쪽
		translate([0, 0, 0])
		color(ccolor)
		cube([padding.x, size.y, size.z]);

		//	오른쪽
		translate([size.x - padding.x, 0, 0])
		color(ccolor)
		cube([padding.x, size.y, size.z]);
	}
}

//	아래쪽에 구멍내는 거, 연결선 빠져 나가는 구멍
module epaper_part_04c(v) {
//	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	upstairs = v[0][3];	//	둔덕의 크기
	marginActive = v[0][4];	//	패널 확보 여백
	size3 = v[2][0];	//	연결단자의 크기
	margin = v[2][1];	//	연결단자의 위치
	height = v[0][2].z;	//	밑판의 높이

	size = [
		size3.x + marginActive.x * 2,
		upstairs.y + marginActive.y + EPSILON,
		height + marginActive.z + EPSILON
	];
	fs = min(size);

	translate([0, -EPSILON, -EPSILON])
	cube(size);

	translate([0, -NOTE_MARGIN+2, -EPSILON])
	notate([size.x, fs]);
}

module epaper_part_04d(v) {
//	echo(str(parent_module(0), "(", v[0][0], ")", HR));

	assert(!is_undef(v));

	difference() {
		union() {
			epaper_part_04a(v);	//	1층
			epaper_part_04b(v);	//	2층
		}

	}
}

module epaper_part_04_notate(v) {
//	echo(str(parent_module(0), "(", v[0][0], ")"));

	assert(!is_undef(v));

	p4 = v[0][0];
	psize = [ for (cx = [0:2]) p4[cx] ];	//	전체 외경
	fs = min(min(psize), 2);
	
//	echo(p4 = p4, psize = psize, fs = fs);

	translate([0, -NOTE_MARGIN - 4, 0])	notate([psize.x, 2], up = false);	//	가로
	translate([-NOTE_MARGIN - 4, 0, 0])	notate([2, psize.y], up = false);	//	세로

	translate([psize.x / 2, psize.y - fs * 4, psize.z])
	%linear_extrude(height = EPSILON) {
		text(str(ID, v[0][0]), font = "D2Coding", size = fs, halign = "center");
	}
}

module epaper_part_04(v = PART04()) {
//	echo(str(parent_module(0), "(", v[0][0], ")", HR));

	assert(!is_undef(v));

	psize = [ for (cx = [0:2]) v[0][0][cx] ];	//	전체 외경
	upstairs = v[0][3];	//	둔덕의 크기
	radius = v[0][5][0];	//	모서리 대패의 반경
	margin = v[2][1];	//	연결단자의 위치
	fs = 2;
//	echo(parent_module(0), psize = psize, radius = radius);

	$fn = $preview ? 4 : 16;
	difference() {
		translate([radius, radius, radius])
		minkowski() {
//			union() {
				epaper_part_04d(v);
				color(COLOR)
				sphere(radius);
				notateH([margin.x, 2], up = false);
//			}
		}

		translate([upstairs.x + margin.x, 0, 0])
		epaper_part_04c(v);

		translate([0, -NOTE_MARGIN + 2, 0])	{
			notateH([upstairs.x, fs], up = false);
			translate([upstairs.x, 0, 0])	notateH([margin.x, fs], up = false);

			translate([psize.x - upstairs.x, 0, 0])	notateH([upstairs.x, fs], up = false);
			translate([psize.x - (upstairs.x + margin.x), 0, 0])	notate([margin.x, fs], up = false);
		}
	}

	epaper_part_04_notate(v);
}

module main() {
	hr();
	
	v = PART04();
	
	epaper_part_04(v);

	hr();
}

main();
