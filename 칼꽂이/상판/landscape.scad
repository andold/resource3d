use <MCAD/boxes.scad>
use <common.scad>
use <../기타/corner-hole.scad>
use <../기타/utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];
ZERO = [0, 0, 0];
EPSILON = 0.1;

// 주요 상수
MARGIN = 12;
THICK = 8;
DELTA = 8;

// export
function landscapeSize()  = coreSize(DELTA, THICK) + [MARGIN * 2, MARGIN * 2, 0];
module landscape() {
	base =  landscapeSize();	//	상판
	t = base[2];		//	thick 껍질 두께
	m = MARGIN;	//	margin 여유

	difference() {
		union() {
			//	상판
			color(c=PALETTE[2])		translate([base[0] / 2, base[1] / 2, t / 2])	roundedBox(base, 2, true);
			
			//	서명
			color(c=PALETTE[1])		translate([base[0] - m / 2 - 2, m / 4, t])		mark("andold", 0.2, 1);

			//	손잡이
			chefsInfo = chefsInfo();
			translate([m + chefsInfo[0] - t, m - t, 0])		color(c=PALETTE[0])
			roundedBoxNotCenter([chefsInfo[1] + t * 2, base[1] / 2, t * 2], 2, true);
		}
		translate([m, m, -EPSILON])	punch(60, 16 + EPSILON * 2, 8);
	}
}
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
scale(ONE)
scale(HALF)
landscape();

