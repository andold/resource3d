use <MCAD/boxes.scad>
use <top-plate.scad>

// 상수
ZERO = [0, 0, 0];
ONE = [1, 1, 1];

module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
}

module lineBox(outter = [100, 100, 100], t = 2) {
	size = outter - [t*2, t*2, t*2];
	center = false;

	scale(ONE) translate([t, t, t])	{
		
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

// 몸통
module body(s) {
	if (s[2] < 235)	echo("................. ERROR ............ 너무 낮아서 칼이 들어가질 않아요 ........................................................................");

	translate([s[1], 0, 0])		rotate([0, 0, 90]) {
		lineBox(s);
		translate([0, 0, s[2]])	top_plate();
	}
}

//	벽 모델링 자료
module wall(x, y, z) {
	points = [
		[0,	0],
		[0,	y],
		[-1,	y],
		[-1,	-1],
		[x,	-1],
		[x,	0],
		[0,	0],

		[0,	0],
		[0,	70.7],	//	70.7
		[180,	70.7],	//	180
		[180,	57.7],	//	20
		[167,	57.7],	//	13
		[167,	0],		//	57.7
		[0, 0]			//	167
	];
	translate([0, y / 2, 0])	rotate([90, 0, 0])	linear_extrude(x)	polygon(points);
}

// 지지대 모델링 자료
module buttress(x, y, z) {
	points = [
		[0,	70.7],	//	70.7
		[0,	z],		//	dy
		[x,	z],		//	x
		[x,	0],		// y
		[167,	0],		// 167
		[167,	57.7]	,	// 57.7
		[180,	57.7],	// 13
		[180,	70.7],	// 20
		[180,	70.7],	// 20
		[0,	70.7]	//	70.7
	];
	translate([0, y, 0])	rotate([90, 0, 0])	linear_extrude(y)	polygon(points);
}
module basis() {
	main = [78, 126, 240];	//	높이는 230mm 이상이어야 한다.
	full = [240, 128, main[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	scale(ONE)		color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);	//	ZERO ONE
	translate([0, 0, 70.7 + 32])
		translate([0, 64, 64])		rotate([20, 0, 0])		rotate([0, 45, 0])		rotate([0, 0, -30])
		color([0.8, 0.8, 0.0, 0.8])
		body(main)
	;

	//color([0.8, 0.0, 0.8, 0.5])	lineBox(full, 1);	//	점유 영역?
	scale(ONE)		translate(nature)	color([0.0, 0.0, 0.8, 0.5])	buttress(full[0], full[1], full[2]);	//	지지대
	translate([main[0] + 512, 0, 0])
		body(main);
}

basis();
