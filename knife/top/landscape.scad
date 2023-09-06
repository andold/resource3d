use <MCAD/boxes.scad>

include	<../../common/constants.scad>
use <../../common/library.scad>

use <common.scad>
use <../../common/utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];
ZERO = [0, 0, 0];
EPSILON = 0.01;

// export
function landscapeSize(thick, margin, delta)  = coreSize(delta, thick) + [margin * 2, margin * 2, 0];
module chefsKnife(p, q) {
	difference() {
		union() {
			color("White", 1.0)	cube(p, true);
			note(p[0], p[1], p[2], true);
		}
		translate([0, 0, -p[2] / 1.8])
			rotate([15, 0, 0]) {
				cube([p[0] + 1, p[1], p[2] * 2], true);
			}
	}
	translate([0, (p[1] - q[1]) / 2, p[2] / 2 + q[2] / 2]) cube(q, true);
}
module landscape(thick, margin, delta) {
	base =  landscapeSize(thick, margin, delta);	//	상판
	
	THICK_BACK_OF_KNIFE = 2;
	height_back_of_knife = 32;

	chefsInfo = chefsInfo();
	difference() {
		union() {
			//	상판
			translate([base[0] / 2, base[1] / 2, thick / 2])
			{
				roundedBox(base, 2, true, $fn = FN);
				note(base[0], base[1], base[2], true);
			}
			
			//	서명
			color(c=PALETTE[2])
				translate([base[0] - margin / 2 - 2, margin / 4, thick / 2])
				linear_extrude(0.4, center = false, slices = $preview ? 20 : 16 * 4)	text("andold", size = 4, halign = "right", $fn = FN)
			;

			//	손잡이
			translate([margin + chefsInfo[0] - thick, margin - thick, 0])
			{
				x = chefsInfo[1] + thick * 2;
				y = base[1] / 2;
				z = thick * 2;
				roundedBoxNotCenter([x, y, z], 2, true);
				note_type_1([x, y, z]);
				// 손잡이 등받이
				translate([0, margin - thick + THICK_BACK_OF_KNIFE, z])
				{
					roundedBoxNotCenter([x, THICK_BACK_OF_KNIFE, height_back_of_knife], 0.5, true);
					note_type_1([x, THICK_BACK_OF_KNIFE, height_back_of_knife]);
				}
			}

			// 빵칼등의 등받이
			translate([delta, margin - thick / 2 + THICK_BACK_OF_KNIFE, thick])
			{
				roundedBoxNotCenter([32, THICK_BACK_OF_KNIFE, height_back_of_knife], 0.5, true);
				note_type_2("빵칼 등받이", [32, THICK_BACK_OF_KNIFE, height_back_of_knife]);
			}
		}

		// 칼구멍
		translate([margin, margin, -EPSILON])	punch(60, 16 + EPSILON * 2, 8);

		// 나사구멍
		nut_radius = RADIUS_HOLE_NUT_25;
		nut_height = 25;
		// 왼쪽
		translate([-EPSILON, thick / 2, thick / 2])
			rotate([0, 90, 0])
			cylinder(nut_height, nut_radius, nut_radius, $fn = $preview ? 16 : 360);
		translate([-EPSILON, base[1] - thick / 2, thick / 2])
			rotate([0, 90, 0])
			cylinder(nut_height, nut_radius, nut_radius, $fn = $preview ? 16 : 360);
		//	오른쪽
		translate([base[0] + EPSILON, thick / 2, thick / 2])
			rotate([0, -90, 0])
			cylinder(nut_height, nut_radius, nut_radius, $fn = $preview ? 16 : 360);
		translate([base[0] + EPSILON, base[1] - thick / 2, thick / 2])
			rotate([0, -90, 0])
			cylinder(nut_height, nut_radius, nut_radius, $fn = $preview ? 16 : 360);
	}

	p = [4, 46, 235];
	q = [20, 32, 64];
	%translate([chefsInfo[0] + margin + 44.5, margin + 23.5, -p[2] / 2 + thick * 2 + 1])
		rotate([0, 0, 180])
		chefsKnife(p, q);
}

module landscapePrototype(param) {
	size = landscapeSize(param[0], param[1], param[2]);
	cube(size);
	note_type_2("Prototype", size);
}

module build(target, step) {
	echo("landscape build start: ", target, step);

	if (!$preview) {
		$fn = 360;
	}

	thick = 8;
	margin = 12;
	delta = 8;
	param = [thick, margin, delta];

	if (target == 1) {
		landscape(thick, margin, delta);
	} else if (target == 2) {
		landscapePrototype(param);
	}

	echo("landscape build done: ", target, step);
}

target = 1;
build(target, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\landscape.stl -D target=1 C:\src\eclipse-workspace\resource3d\knife\top\landscape.scad
*/