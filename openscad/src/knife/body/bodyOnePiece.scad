use <MCAD/boxes.scad>
use <landscapeForBodyOnePiece.scad>
use <utils.scad>

ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];

// 주요 상수
THICK = 4;
HEIGHT = 235;
OPACITY = 0.75;

function bodyOnePieceSize()  = [landscapeForBodyOnePieceSize()[0], landscapeForBodyOnePieceSize()[1], HEIGHT];

module pillar(size = [128, 64, 32], param = [THICK, THICK / 2 * 3]) {
	echo("pillar", size, param);
	translate([0, 0, 0])	cylinder(size[2], param[0], param[0]);

	translate([0, 0, param[1]])	cylinder(param[0], param[0], param[0] * 2);
	translate([0, 0, param[0] + param[1]])	cylinder(param[0], param[0] * 2, param[0]);

	translate([0, 0, size[2] - param[0] * 2 - param[1]])	cylinder(param[0], param[0], param[0] * 2);
	translate([0, 0, size[2] - param[0] * 1 - param[1]])	cylinder(param[0], param[0] * 2, param[0]);
}
module pillars(size = [128, 64, 32], param = [THICK, THICK / 2 * 3]) {
	echo("pillars", size, param);
	translate([0,			0,			0])	pillar(size, param);
	translate([size[0],		0,			0])	pillar(size, param);
	translate([size[0],		size[1],	0])	pillar(size, param);
	translate([0,			size[1],	0])	pillar(size, param);
	translate([size[0] / 2,	0,			0])	pillar(size, param);
	translate([size[0] / 2,	size[1],	0])	pillar(size, param);

	//pillar(size, param);
}
module side(size = [128, 64, THICK], param = [THICK, THICK / 2 * 3]) {
	dx = size[2] * size[0] / size[1];
	echo("side", size, dx);
	color("gray", 0.5)	{
		linear_extrude(param[0])	polygon([
			[0, 0],
			[dx, 0],
			[size[0], size[1]],
			[size[0] - dx, size[1]],
		]);
		linear_extrude(param[0])	polygon([
			[0, size[1]],
			[dx, size[1]],
			[size[0], 0],
			[size[0] - dx, 0],
		]);
	}
}
//side();
module partitionFront(size = [128, 64, 256], param = [4, 8]) {
	x = size[2] - param[0] * 4 - param[1] * 2;
	y = size[0] / 2 - param[0] * 2;
	z = param[0] * 2;
	echo("partitionFront", size, param, x, y, z);

	translate([y, 0, x])
	rotate([0, 90, 90])
	side([x, y, z]);
}
//sideFront();
module partitionSide(size = [128, 64, 256], param = [4, 8]) {
	x = size[2] - param[0] * 4 - param[1] * 2;
	y = size[1] - param[0] * 2;
	z = param[0] * 2;

	translate([0, 0, x])
	rotate([0, 90, 0])
	side([x, y, z]);
}
module sides(size = [128, 64, THICK], param = [THICK, THICK / 2 * 3]) {
	translate([param[0],				-param[0] / 2,			param[1] + param[0] * 2])	partitionFront(size, param);
	translate([size[0] / 2 + param[0],	-param[0] / 2,			param[1] + param[0] * 2])	partitionFront(size, param);
	translate([param[0],				size[1] - param[0] / 2,	param[1] + param[0] * 2])	partitionFront(size, param);
	translate([size[0] / 2 + param[0],	size[1] - param[0] / 2,	param[1] + param[0] * 2])	partitionFront(size, param);

	translate([-param[0] / 2,	param[0] * 1, param[1] + param[0] * 2])	partitionSide(size, param);
	translate([size[0] - param[0] / 2,	param[0] * 1, param[1] + param[0] * 2])	partitionSide(size, param);
}
module bodyOnePiece() {
	size = bodyOnePieceSize();
	param = [THICK, THICK / 2 * 3];
	//scale(ZERO)
	pillars(size, param);
	//scale(ZERO)
	sides(size, param);
}

module assemble() {
	size = bodyOnePieceSize();
	bodyOnePiece();
	translate([0, 0, size[2]])	landscapeForBodyOnePiece();
}

assemble();
//bodyOnePiece();
//scale(HALF)	bodyOnePiece();
