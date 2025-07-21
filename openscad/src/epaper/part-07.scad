include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-06.scad>	//	그룹 of part1, part2, part3

//	연결 부속, 수직 최대각도는 45도.
COLOR = [0.6, 0.4, 0.3, 0.9];
function extraMargin(v = [0.8, 4, 1.6, 0.4, 0.4]) = pointToLineDistance(v[0], v[2], 0, 0, -v[3], v[2] + v[4]) - v[0];
function margin07(v = [0.8, 4, 1.6, 0.4, 0.4]) = [
	v[4],	//	기준점으로부터 왼쪽
	0.1,
	0.1,
	pointToLineDistance(v[0], v[2], 0, 0, -v[3], v[2] + v[4]) - v.x,
	
	0	//	reserved
];

module epaper_part_07_female(v, m) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", v, m, ")"));

	assert(!is_undef(v));

	sm = !is_undef(m) ? m : [
				v[4],	//	기준점으로부터 왼쪽
				0.1,
				0.1,
				pointToLineDistance(v[0], v[2], 0, 0, -v[3], v[2] + v[4]) - v.x,
				
				0	//	reserved
			];
//	echo(str(parent_module(0), ".", parent_module(1)), sm);

	//	title(모듈 이름) 표시
	title = str(parent_module(0), ".", parent_module(1), v, m);
	color("white")
	translate([v.x + sm[3], v.y / 2, v.z / 2])
	rotate([90, 0, 90])
	%linear_extrude(height = EPSILON) {
		text(title, font = "D2Coding", size = min(v) / 4, halign = "center");
	}

	x = v[0];
	y = v[1];
	z = v[2];
	x1 = v[3];
	z1 = v[4];

	points = [
		[-sm[0] - EPSILON,		-EPSILON],
		[v.x + sm[3] + EPSILON,	-EPSILON],
		[v.x + sm[3] + EPSILON,	z + z1 + sm.z + EPSILON],
		[v.x + sm[3] + EPSILON,	z + z1 + sm.z + EPSILON],
		[-x1 - EPSILON,			z + z1 + sm.z + EPSILON],
		[-x1 - EPSILON,			z + z1 + EPSILON],

		[-EPSILON,				z]
	];
//	echo(str(parent_module(0), ".", parent_module(1)), points);

	epaper_part_07_male(v);

//	#
	color(COLOR)
	translate([0, y + sm.y, 0])
	rotate([90, 0, 0])
	{
		linear_extrude(height = y + sm.y * 2)
		polygon(points = points);
	}
	
	epaper_part_07_female_notate(v, sm);
}
module epaper_part_07_female_notate(v, m) {
	fs = min(v) / 4;

	translate([-m.x, -m.y - fs, 0])
	notate([m.x, fs]);

	translate([v.x, -m.y - fs, 0])
	notate([m[3], fs], up = false);

	translate([v.x, -m.y, v.z + v[4] + m.z])
	notate([m.y, fs]);

	translate([-m.x - fs, 0, v.z + v[4]])
	rotate([90, 0, 0])
	notate([m.z, fs]);
}
module epaper_part_07_male(v) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	fontSize = min(v) / 4;
	x = v[0];
	y = v[1];
	z = v[2];
	x1 = v[3];
	z1 = v[4];
	points = [
		[0,			0],
		[x,			0],
		[x,			z],
		[x - x1,	z + z1],
		[-x1,		z + z1],

		[0 ,		z],
	];
	margin = margin07(v);

	//	title(모듈 이름) 표시
	title = str(parent_module(0), ".", parent_module(1), v);
	color("white")
	translate([v.x, v.y / 2, v.z / 2])
	rotate([90, 0, 90])
	%linear_extrude(height = EPSILON) {
		text(title, font = "D2Coding", size = min(v) / 4, halign = "center");
	}

	translate([0, y, 0])
	rotate([90, 0, 0])
	{
		color(COLOR)
		linear_extrude(height = y)
		polygon(points = points);

		//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
		translate([0, 0, y])
		notate([x, fontSize], prefix = DIGIT[0]);
	translate([x, 0, y])
	notate([margin[3], fontSize]);
		translate([x, 0, y])
		notate([fontSize, z], prefix = DIGIT[2]);
		translate([-fontSize / 2, z, y])
		notate([fontSize, z1], prefix = DIGIT[4]);
		translate([-x1, z - fontSize / 2, y])
		notate([x1, fontSize], prefix = DIGIT[3]);
	}
	translate([-fontSize * 3 / 2, 0, 0])
	notate([fontSize, y], prefix = DIGIT[1]);

}
module epaper_part_07(v, female = false, m) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", v, female, m, ")"));

	sv = is_undef(v) ? [0.4, 1.6, 4, 0.4, 0.4] : v;

	if (female) {
		epaper_part_07_female(sv, m);
	} else {
		epaper_part_07_male(sv);
	}


}

module main() {
	v = [0.8, 4, 1.6, 0.4, 0.4];
	//epaper_part_07(v, false);
	epaper_part_07(v, true);
}

main();
