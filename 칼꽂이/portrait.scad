use <MCAD/boxes.scad>
use <utils.scad>

//	상수
BIG = [1024, 1024, 1024];
ZERO=[0, 0, 0];
ONE=[1, 1, 1];
PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];

// [가로, 세로, 높이], 홈너비
module hilt(base, r) {
//	//cylinder(base[2], base[0], base[0]);
	scale(ONE)	translate([base[0] / 2, base[1] / 2, base[2] / 2])
		roundedBox(size=base, radius = r, sidesonly = true);
}
module hilt_v_1(base, r) {
	translate([base[0] / 2, base[1] / 2, base[2] / 2])
		scale([1, 1, 1])	roundedBox(size=[base[0], base[1], base[2]], radius = r, sidesonly = true);
}

function portraitSize()  = [78, 126, 3];
module portrait() {
	base = portraitSize();	//	상판
	t = base[2];		//	thick 껍질 두께
	m = 16;	//	margin 여유
	HILT = [4 + t * 2, 32, 16];	//	손잡이

	difference() {
		union() {
			//	상판
			color(c=PALETTE[2])		translate([base[0] / 2, base[1] / 2, t / 2])		roundedBox(size=base, radius = m / 4, sidesonly = true);
			
			//	서명
			color(c=PALETTE[1])		translate([base[0] - m / 2 - 2, m / 4, t])		mark("andold", 0.2, 1);

			//	손잡이
			translate([-8, -8, 0])		color(c=PALETTE[0])	translate([m, m, 0])		hilt(HILT, t);
		}
		
		translate([-8, -8, 0]) {
			//	식도
			translate([m + t, m + t, 0])			hole(4, 60);
			translate([m  + t + 16, m + t, 0])	hole(5, 60);
			translate([m  + t + 32, m + t, 0])	hole(3, 60);

			// 과도
			translate([m  + t + 00, m + t + 70, 0])	hole(3, 36);

			// 빵칼
			translate([m  + t + 10, m + t + 70, 0])	hole(3, 36);
			translate([m  + t + 20, m + t + 70, 0])	hole(3, 36);
			translate([m  + t + 30, m + t + 70, 0])	hole(3, 36);

			// 가위
			translate([m  + t + 42, m + t + 0, -1])		ellipsis(16, 40);
			translate([m  + t + 42, m + t + 65, -1])		ellipsis(16, 40);
			
			// 여유
		}

		// 모서리 구멍
		translate([m / 4,					m / 4,					0])	ellipsis(1, 1);
		translate([base[0] - m / 4,	m / 4,					0])	ellipsis(1, 1);
		translate([base[0] - m / 4,	base[1] - m / 4,	0])	ellipsis(1, 1);
		translate([m / 4,					base[1] - m / 4,	0])	ellipsis(1, 1);

		translate([m / 4 - 1 / 2,					m / 4 - 1 / 2,					t - 1])	ellipsis(2, 2);
		translate([base[0] - m / 4  - 1 / 2,	m / 4 - 1 / 2,					t - 1])	ellipsis(2, 2);
		translate([base[0] - m / 4  - 1 / 2,	base[1] - m / 4 - 1 / 2,	t - 1])	ellipsis(2, 2);
		translate([m / 4 - 1 / 2,					base[1] - m / 4 - 1 / 2,	t - 1])	ellipsis(2, 2);
	}
}
