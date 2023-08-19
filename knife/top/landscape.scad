use <MCAD/boxes.scad>
use <common.scad>
use <../etc/corner-hole.scad>
use <../etc/utils.scad>

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
			rotate([15, 0, 0])
			cube([p[0] + 1, p[1], p[2] * 2], true);
	}
	translate([0, (p[1] - q[1]) / 2, p[2] / 2 + q[2] / 2]) cube(q, true);
}
module landscape(thick, margin, delta, prototype) {
	base =  landscapeSize(thick, margin, delta);	//	상판

	chefsInfo = chefsInfo();
	difference() {
		union() {
			//	상판
			translate([base[0] / 2, base[1] / 2, thick / 2])
			{
				roundedBox(base, 2, true);
				note(base[0], base[1], base[2], true);
			}
			
			//	서명
			color(c=PALETTE[1])
				translate([base[0] - margin / 2 - 2, margin / 4, thick])
				mark("andold", 0.2, 1);

			//	손잡이
			translate([margin + chefsInfo[0] - thick, margin - thick, 0])
			{
				x = chefsInfo[1] + thick * 2;
				y = base[1] / 2;
				z = thick * 2;
				roundedBoxNotCenter([x, y, z], 2, true);
			}
		}
		translate([margin, margin, -EPSILON])	punch(60, 16 + EPSILON * 2, 8);
	}

	p = [4, 46, 235];
	q = [20, 32, 64];
	%translate([chefsInfo[0] + margin + 44.5, margin + 23.5, -p[2] / 2 + thick * 2 + 1])
		rotate([0, 0, 180])
		chefsKnife(p, q);
}

thick = 8;
margin = 12;
delta = 8;
prototype = false;
module build(thick, margin, delta, prototype) {
	echo("landscape build start: ", thick, margin, delta, prototype);

	scale = prototype ? [1/2, 1/2, 1/2] : [1, 1, 1];
	scale(scale) {
		landscape(thick, margin, delta, prototype);
	}

	echo("landscape build done: ", thick, margin, delta, prototype);
}

build(thick, margin, delta, prototype);
