use <MCAD/boxes.scad>
use <wall.scad>
use <landscape.scad>

// 상수
ZERO = [0, 0, 0];
ONE = [1, 1, 1];

function topPlateSize()  = landscapeSize();
function bodySize()  = [topPlateSize()[0] + 2, topPlateSize()[1] + 2, 240];
module sides(base, t = 4, delta = 64, degree = 30) {
	translate([base[0],	0,					base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);
	translate([base[0],	base[1] - t,	base[2]])	rotate([0, 90, 90])	side([base[2], base[0], t]);

	translate([0,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
	translate([base[0] - t,	0,	base[2]])	rotate([0, 90, 0])	side([base[2], base[1], t]);
}

module side(base, delta = 64, degree = 30) {
	inner = [base[0] - base[2] * 2, base[1] - base[2] * 2, base[2] + 2];
	stick = [1024, base[2], base[2]];
	difference() {
		cube(base);
		translate([base[2], base[2], -1])
			cube(inner);
	}
	intersection() {
		cube(base);
		for (dx=[-base[0] * 2:delta:base[0] * 2]) {
			translate([dx, 0, 0])			rotate([0, 0, degree])	cube(stick);
			translate([dx, base[1], 0])			rotate([0, 0, -degree])	cube(stick);
		}
	}
}
module body() {
	base = bodySize();
	if (base[2] < 235)	echo("................. ERROR ............ 너무 낮아서 칼이 들어가질 않아요 ........................................................................");

	s = [base[0] + 4, base[1] + 4, base[2]];
	translate([base[1], 0, 0])		rotate([0, 0, 90]) {
		difference() {
			sides(s, 4);
			translate([3, 3, base[2] - 2])	landscape();
		}
	}
}


module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
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
	main = bodySize();	//	높이는 230mm 이상이어야 한다.
	full = [240, 128, main[2] + 70.7];
	nature = [32, 0, 0];		//	자연스럽게 놓여진 위치

	color([0.8, 0.8, 0.8, 0.5])	wall(640, 640);
	translate([0, 0, 70.7 + 32])
		translate([0, 64, 64])
			//rotate([20, 0, 0])
			rotate([0, 45, 0])
			//rotate([0, 0, -30])
			color([0.8, 0.8, 0.0, 0.8])
		body()
	;

	//color([0.8, 0.0, 0.8, 0.5])	lineBox(full, 1);	//	점유 영역?
	scale(ONE)		translate(nature)	color([0.0, 0.0, 0.8, 0.5])	buttress(full[0], full[1], full[2]);	//	지지대
	translate([main[0] + 512, 0, 0])
		body();
}

basis();
