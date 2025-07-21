include	<../common/constants.scad>
use <common.scad>

COLOR = [0.4, 0.8, 0.4, 0.5];

function PART03() = [
	[25.50, 24.00, 0.1, "외경"],
	[72.35, 0, 0, "여백"]
];

module epaper_part_03(v) {
	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	size = [ for (cx = [0:2]) v[0][cx] ];
	margin = v[1];
	fs = min([size.x, size.y, 2]) / 4;
	echo(size = size, margin = margin, fs = fs);
	
	color(COLOR)
	cube(size);

	%translate([size.x / 2, size.y / 2, size.z])
	linear_extrude(height = EPSILON) {
		text(str(parent_module(0), v), size = fs, font = "D2Coding", halign = "center");
	}

	//	가로
	translate([0, 0, size.z])
	notate([size.x, fs]);
	//	세로
	translate([size.x - fs, 0, size.z])
	notate([fs, size.y]);
}

module main() {
	v = PART03();
	epaper_part_03(v);
}

main();
