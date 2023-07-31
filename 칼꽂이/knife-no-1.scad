use <MCAD/boxes.scad>

// 상수
THICK = 2;		//	껍질두께
ROUND = 2;	//	상판굴곡
BASE = [16, 64, THICK];	//	상판

// 주요 수치
BLADE_HOLE_WIDTH = 5;		// 날두께(4) + 여유(1)
BLADE_HOLE_HEIGHT = 48;	// 날너비(46) + 여유(2)

// 텍스트 홈파기
// 상판(base)의 왼쪽 아래 기준준
module mark(name, height, base, mx) {
	translate([(base[0]  - mx / 2 - 18) / 2, -(base[1] - mx / 2) / 2, base[2] / 2])
		linear_extrude(height, center = false)
			text(name, size = 2);
}

// 긴홈
module knife1() {
	difference() {
		union() {
			//	상판
			color(c=[0.3, 0.1, 0.0, 0.5])	roundedBox(size=BASE, radius = ROUND, sidesonly = true);

			//	꼬리표
			color(c=[0.9, 0.9, 0.9, 0.5])	mark("andold 1", 0.2, BASE, 16);
		}
		
		//	홈파기
		roundedBox(size = [BLADE_HOLE_WIDTH, BLADE_HOLE_HEIGHT, THICK + 2], radius = 1, sidesonly = true);
	}
}

knife1();

