include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-06.scad>

//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
//	모난 구석이 없는 네모 상자
ID = "⑧";
COLOR = [0.3, 0.4, 0.7, 0.9];

function COLOR08() = COLOR;

module epaper_part_08(v) {
	hr();
	echo("epaper_part_08", parent_module(1), v);

	w = is_undef(v) ? [32, 8, 16, 2] : v;
	fontSize = min(w) / 4;

	$fn = 32;
	color(COLOR)
	minkowski() {
		translate([w[3], w[3], w[3]])
		cube([w.x - w[3] * 2, w.y - w[3] * 2, w.z - w[3] * 2]);
		
		translate([0, 0, 0])
		sphere(w[3]);
	}
	
	//	x축 길이 표시
	translate([0, -fontSize, 0])	notate([w.x, fontSize]);	//	제일긴거
	translate([0, 0, 0])			notate([w[3], fontSize]);	//	왼쪽
	translate([w[3], 0, 0])			notate([w.x - w[3] * 2, fontSize]);	//	중앙
	translate([w.x - w[3], 0, 0])	notate([w[3], fontSize]);	//	오른쪽
	
	//	y축 길이 표시
	translate([-fontSize, 0, 0])	notate([fontSize, w.y]);
	translate([0, 0, 0])			notate([fontSize, w[3]]);
	translate([0, w[3], 0])			notate([fontSize, w.y - w[3] * 2]);
	translate([0, w.y - w[3], 0])	notate([fontSize, w[3]]);

	//	y축 길이 표시
	translate([0, -fontSize, 0])		rotate([0, -90, 0])	notate([w.z, fontSize]);
	translate([0, 0, 0])				rotate([0, -90, 0])	notate([w[3], fontSize]);
	translate([0, 0, w[3]])				rotate([0, -90, 0])	notate([w.z - w[3] * 2, fontSize]);
	translate([0, 0, w.z - w[3]])	rotate([0, -90, 0])	notate([w[3], fontSize]);
}

module main() {
	epaper_part_08();
}

main();
