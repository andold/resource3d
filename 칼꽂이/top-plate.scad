use <MCAD/boxes.scad>

//	상판

//
//	under construction
//

// 주요 수치
THICK = 3;		//	껍질두께
ROUND = 8;	//	상판굴곡
BASE_WIDTH	=	128 - 32 - 8 + 4;
BASE_HEIGHT	=	128;
BASE = [BASE_WIDTH, BASE_HEIGHT, THICK];	//	상판
BASE_MARGIN	=	32;
GUIDE_X	=	[0, 32, 64, 80, 112];
GUIDE_Y	=	[0, BASE_HEIGHT - BASE_MARGIN / 2];

// 주요 수치
BLADE_HOLE_WIDTH = [5, 3, 2, 2];
BLADE_HOLE_HEIGHT = 48;	// 날너비(46) + 여유(2)

SCISSOR_HOLE_WIDTH = 14;		//	가위 두께
SCISSOR_HOLE_HEIGHT = 40;	//	가위 너비

// 텍스트 홈파기
// 상판(base)의 왼쪽 아래 기준준
module mark(name, height, base, mx) {
	translate([(base[0]  - mx / 2 - 18) / 2, -(base[1] - mx / 2) / 2, base[2] / 2])
		linear_extrude(height, center = false)
			text(name, size = 2);
}

// 긴홈
module top_plate() {
	difference() {	//	절단면을 보기위하여
		
		// 주 물체
		union() {
			//	홈파기
			difference() {
				union() {
					//	상판
					color(c=[0.3, 0.1, 0.0, 0.5])	roundedBox(size=BASE, radius = ROUND, sidesonly = true);


					//	태그
					color(c=[0.9, 0.9, 0.9, 0.5])	mark("andold", 0.2, BASE, BASE_MARGIN);
				}
				
				//	칼날홈파기
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[0] / 2, 0, 0])
					roundedBox(size = [BLADE_HOLE_WIDTH[0], BASE[1] - BASE_MARGIN, THICK * 4], radius = 1, sidesonly = true);
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[1] / 2, 0, 0])
					roundedBox(size = [BLADE_HOLE_WIDTH[1], BASE[1] - BASE_MARGIN, THICK * 4], radius = 1, sidesonly = true);
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[2] / 2, 0, 0])
					roundedBox(size = [BLADE_HOLE_WIDTH[2], BASE[1] - BASE_MARGIN, THICK * 4], radius = 1, sidesonly = true);
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[3] / 2, 0, 0])
					roundedBox(size = [BLADE_HOLE_WIDTH[3], BASE[1] - BASE_MARGIN, THICK * 4], radius = 1, sidesonly = true);
				
				//	가위 홈파기기
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[4] / 2, -(BASE[1] - BASE_MARGIN - SCISSOR_HOLE_HEIGHT) / 2 + GUIDE_Y[0] / 2, 0])
					resize([SCISSOR_HOLE_WIDTH, SCISSOR_HOLE_HEIGHT, THICK * 2])	cylinder(h = 100, r = 100, center = true);
				translate([-(BASE[0] - BASE_MARGIN) / 2 + GUIDE_X[4] / 2, -(BASE[1] - BASE_MARGIN - SCISSOR_HOLE_HEIGHT) / 2 + GUIDE_Y[1] / 2, 0])
					resize([SCISSOR_HOLE_WIDTH, SCISSOR_HOLE_HEIGHT, THICK * 2])	cylinder(h = 100, r = 100, center = true);
			}

		}
		
		//	절단방법 기술
		//	translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
		//	translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
		//	translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
	}
}

top_plate();

