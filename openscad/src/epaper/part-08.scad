include	<../common/constants.scad>
use <common.scad>

//	모난 구석이 없는 네모 상자
COLOR = [0.3, 0.4, 0.7, 0.9];

module epaper_part08_notate(w) {
	echo(str(parent_module(0), ".", parent_module(1), "(", w, ")"));
	assert(!is_undef(w));

	radius = w[3];
	fontSize = min(w) / 4;

	assert(!is_undef(radius));
	assert(is_num(fontSize));

	//	title(모듈 이름) 표시
	//title = str(parent_module(1), ".", parent_module(2), w);
	title = str(parent_module(1), w);
	color("white")
	translate([w.x / 2, 0, w.z / 2])
	rotate([90, 0, 0])
	%linear_extrude(height = EPSILON) {
		text(title, font = "D2Coding", size = fontSize, halign = "center");
	}
	
	//	x축 길이 표시
	translate([0, -fontSize, 0])	notate([w.x, fontSize]);	//	제일긴거
	translate([0, 0, 0])			notate([radius, fontSize]);	//	왼쪽
	translate([radius, 0, 0])		notate([w.x - radius * 2, fontSize]);	//	중앙
	translate([w.x - radius, 0, 0])	notate([radius, fontSize]);	//	오른쪽
	
	//	y축 길이 표시
	translate([-fontSize, 0, 0])	notate([fontSize, w.y]);
	translate([0, 0, 0])			notate([fontSize, radius]);
	translate([0, radius, 0])		notate([fontSize, w.y - radius * 2]);
	translate([0, w.y - radius, 0])	notate([fontSize, radius]);

	//	y축 길이 표시
	translate([0, -fontSize, 0])	rotate([0, -90, 0])	notate([w.z, fontSize]);
	translate([0, 0, 0])			rotate([0, -90, 0])	notate([radius, fontSize]);
	translate([0, 0, radius])			rotate([0, -90, 0])	notate([w.z - radius * 2, fontSize]);
	translate([0, 0, w.z - radius])	rotate([0, -90, 0])	notate([radius, fontSize]);
}
module epaper_part08(v = [32, 8, 16, 2]) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	w = is_undef(v) ? [32, 8, 16, 2] : v;
	radius = w[3];

	assert(!is_undef(w));
	assert(!is_undef(radius));

	$fn = $preview ? 16 : 32;
	color(COLOR)
	translate([radius, radius, radius])
	minkowski() {
		cube([w.x - radius * 2, w.y - radius * 2, w.z - radius * 2]);
		
		translate([0, 0, 0])
		sphere(radius);
	}
	
	epaper_part08_notate(w);
}

module main() {
	hr();

	epaper_part08();

	hr();
}

main();
