use <MCAD/boxes.scad>
use <utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];

// [가로, 세로, 높이], 홈너비
module hilt(base, r) {
	translate([base[0] / 2, base[1] / 2, base[2] / 2])	roundedBox(size=base, radius = r, sidesonly = true);
}

function landscapeSize()  = [160, 88, 3];
module landscape() {
	base =  landscapeSize();	//	상판
	t = base[2];		//	thick 껍질 두께
	m = 16;	//	margin 여유
	HILT = [16, 32, 16];	//	손잡이

	difference() {
		union() {
			//	상판
			color(c=PALETTE[2])		translate([base[0] / 2, base[1] / 2, t / 2])		roundedBox(size=base, radius = m / 4, sidesonly = true);
			
			//	서명
			color(c=PALETTE[1])		translate([base[0] - m / 2 - 2, m / 4, t])		mark("andold", 0.2, 1);

			//	손잡이
			translate([0, 0, 0])		color(c=PALETTE[0])		translate([m - HILT[0]/ 2 + 4 / 2, m - 4, 0])		hilt(HILT, 4);
		}
		
		translate([0, 0, 0]) {
			//	식도
			translate([m, m, 0])			hole(4, 60);
			translate([m + 16, m, 0])	hole(3, 60);

			// 과도
			translate([m + 32, m])		hole(3, 60);
			translate([m + 48, m])		hole(3, 60);

			// 빵칼
			translate([m + 64, m])	hole(3, 60);

			// 가위
			scissor = [16, 40];
			translate([base[0] - m - 5 - 48, base[1] / 2 - scissor[1] / 2, -1])		ellipsis(16, 40);
			translate([base[0] - m - 5 - 24, base[1] / 2 - scissor[1] / 2, -1])		ellipsis(16, 40);
			
			translate([base[0] - m - 5, m, 0])	hole(5, 60);
			// 여유
		}

		// 모서리 구멍
		cornerHole(base, m / 2, 2, 4, 2);
	}
}
landscape();
