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
EPSILON = 0.1;

// export
function landscapeSize(thick, margin, delta)  = coreSize(delta, thick) + [margin * 2, margin * 2, 0];
module landscape(thick, margin, delta, prototype) {
	base =  landscapeSize(thick, margin, delta);	//	상판

	difference() {
		union() {
			//	상판
			color(c=PALETTE[2])
				translate([base[0] / 2, base[1] / 2, thick / 2])
				roundedBox(base, 2, true);
			
			//	서명
			color(c=PALETTE[1])		translate([base[0] - margin / 2 - 2, margin / 4, thick])		mark("andold", 0.2, 1);

			//	손잡이
			chefsInfo = chefsInfo();
			translate([margin + chefsInfo[0] - thick, margin - thick, 0])		color(c=PALETTE[0])
			roundedBoxNotCenter([chefsInfo[1] + thick * 2, base[1] / 2, thick * 2], 2, true);
		}
		translate([margin, margin, -EPSILON])	punch(60, 16 + EPSILON * 2, 8);
	}
}

thick = 8;
margin = 12;
delta = 8;
prototype = false;
module build(thick, margin, delta, prototype) {
	echo("landscape build start: ", thick, margin, delta, prototype);

	if (prototype) {
		scale([1/2, 1/2, 1/2])	landscape(thick, margin, delta, prototype);
	} else {
		landscape(thick, margin, delta, prototype);
	}

	echo("landscape build done: ", thick, margin, delta, prototype);
}

build(thick, margin, delta, prototype);
