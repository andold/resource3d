use <MCAD/boxes.scad>
use <corner-hole.scad>
use <utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 1.0],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];
ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
EPSILON = 0.1;

// 리트랙션을 줄일려면, 각진선이 유리하다
module hole(w, h, z) {
	translate([w / 2, h / 2, z / 2])
		roundedBox([w, h, z], w / 4, true);
}

function punchSize()  = [105, 60, 4];
function landscapeForBodyOnePieceSize()  = punchSize() + [20, 0, 0];
module punch(height = 4) {
	// 과도, 빵칼
	translate([0, 0])		hole(3, 60, height);
	translate([12, 0])		hole(3, 60, height);
	translate([24, 0])		hole(3, 60, height);

	// 가위
	scissor = [16, 40];
	translate([32, 60 / 2 - scissor[1] / 2, 0])		ellipsis(16, 40, height);
	translate([54, 60 / 2 - scissor[1] / 2, 0])		ellipsis(16, 40, height);
	
	//	식도
	translate([76, 0, 0])		hole(4, 60, height);
	translate([88, 0, 0])		hole(3, 60, height);
	translate([100, 0, 0])		hole(5, 60, height);
}

module landscapeForBodyOnePiece() {
	base = landscapeForBodyOnePieceSize();	//	상판
	size = base + [24, 24, 0];
	t = base[2];				//	thick 껍질 두께
	m = 20;	//	margin 여유
	HILT = [41, 40, 16];	//	손잡이

	difference() {
		union() {
			//	상판
			color(c=PALETTE[2])
				translate([size[0] / 2 - t * 3, size[1] / 2 - t * 3, t / 2])
					roundedBox(size, 4, true);
			
			//	서명
			color(c=PALETTE[1])	translate([size[0] - m / 2 - 2, m / 4, t])		mark("andold", 0.2, 1);

			//	손잡이
			color(c=PALETTE[0])
				translate([100 + 5 - 6, HILT[1] / 2 - 2, HILT[2] / 2])
					roundedBox(HILT, 4, true);

		}
		
		translate([8, 0, -EPSILON])	punch(HILT[2] + EPSILON * 2);
		
		// 모서리 구멍, 연결부위
		h = t + EPSILON  * 2;
		top = 4 + EPSILON * 2;
		bottom = 8 + EPSILON * 2;
		translate([0,		0,			-EPSILON])						cylinder(h, bottom, top);
		translate([0,		base[1],	-EPSILON])				cylinder(h, bottom, top);
		translate([base[0],	base[1],	-EPSILON])	cylinder(h, bottom, top);
		translate([base[0],	0,			-EPSILON])				cylinder(h, bottom, top);
	}
}
scale(HALF)	landscapeForBodyOnePiece();

