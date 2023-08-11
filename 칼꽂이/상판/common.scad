use <MCAD/boxes.scad>
use <../기타/corner-hole.scad>
use <../기타/utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 1.0],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];
ZERO = [0, 0, 0];
HALF = [1/2, 1/2, 1/2];
ONE = [1, 1, 1];
EPSILON = 0.1;

// export
function coreWidth(delta = 8)  = (3 + 3 + 3) + (16 + 16) + (3 + 4 + 5) + delta * 7;
function chefsInfo(delta = 8)  = [(3 + 3 + 3) + (16 + 16) + delta * 5, (3 + 4 + 5) + delta * 2];	//	[x위치, 길이]
function coreSize(delta = 8, thick = 8)  = [coreWidth(delta), 60, thick];

module test(delta = 4) {
	a = [];
	dx = 0;
	for (cx = [0:delta: 256]) {
		dx = dx + delta;
		a = concat(a, [dx]);
		echo(dx, a);
	}
}
//test();

module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly);
}

// export
module punch(height = 60, thick = 8, delta = 8) {
	// 과도, 빵칼
	breadStart = 0;
	translate([breadStart, 0, 0])					roundedBoxNotCenter([3, height, thick], 1);
	translate([breadStart + (3 + delta), 0, 0])		roundedBoxNotCenter([3, height, thick], 1);
	translate([breadStart + (3 + delta) * 2, 0, 0])	roundedBoxNotCenter([3, height, thick], 1);
	breadLength = (3 + delta) * 2 + 3;

	// 가위
	scissorStart = breadStart + breadLength + delta;
	scissor = [16, 40];
	translate([scissorStart,						(height - scissor[1]) / 2, 0])	ellipsis(scissor[0], scissor[1], thick);
	translate([scissorStart + scissor[0] + delta,	(height - scissor[1]) / 2, 0])	ellipsis(scissor[0], scissor[1], thick);
	scissorLength = scissor[0] * 2 + delta;
	
	//	식도
	chefsStart = scissorStart + scissorLength + delta;
	translate([chefsStart, 0, 0])						roundedBoxNotCenter([3, height, thick], 1);
	translate([chefsStart + 3 + delta, 0, 0])			roundedBoxNotCenter([4, height, thick], 1);
	translate([chefsStart + (3 + 4) + delta * 2, 0, 0])	roundedBoxNotCenter([5, height, thick], 1);
	chefsLength = (3 + 4 + 5) + delta * 2;
	echo("last x position, ie width", delta, breadStart, breadLength, scissorStart, scissorLength, chefsStart, chefsLength);
}
punch();
module hilt(height = 60, thick = 8, delta = 8) {
	HILT = [41, 40, 16];	//	손잡이
	color(c=PALETTE[0])
		translate([100 + 5 - 6, HILT[1] / 2 - 2, HILT[2] / 2])
			roundedBox(HILT, 4, true);
}
