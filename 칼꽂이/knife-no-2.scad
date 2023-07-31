use <MCAD/boxes.scad>

// 상수
THICK = 2;		//	껍질두께
HEIGHT = 16;	//	전체 홈 높이이
ROUND = 2;	//	상판굴곡
BASE = [32, 70, THICK];	//	상판
BIG = [1024, 1024, 1024];	//	절단면을 보기 위한 절단 물체(아주 큰거면 다됨)

// 주요 수치
BLADE_HOLE_WIDTH = 4;		// 날두께(2) + 여유(2)
BLADE_HOLE_HEIGHT = 60;	// 날너비(52) + 여유(8)
HILT_HOLE_WIDTH = 24;			//	손잡이두께(20) + 여유(4)
HILT_HOLE_HEIGHT = 33 + 4;		//	손잡이너비(33) + 여유(4)

// 텍스트 홈파기
// 상판(base)의 왼쪽 아래 기준준
module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
}

module hiltMold(inner, t = THICK, r = ROUND) {
	outter = inner + [t + 2, t + 2, 0];
	difference() {
		roundedBox(size=outter, radius = r, sidesonly = true);
		roundedBox(size=inner + [0, 0, 1], radius = r, sidesonly = true);
	}
}

// 긴홈, 손잡이가 밑에 있는 것것
module knife2() {
	difference() {	//	절단면을 보기위하여
		
		// 주 물체
		union() {
			//	홈파기
			difference() {
				union() {
					//	상판
					color(c=[0.8, 0.8, 0.8, 0.5])	roundedBox(size=BASE, radius = ROUND, sidesonly = true);

					//	손잡이집
					color(c=[0.3, 0.1, 0.0, 0.5])
						translate([0, -(BLADE_HOLE_HEIGHT - HILT_HOLE_HEIGHT) / 2 , -HEIGHT / 2])
							hiltMold([HILT_HOLE_WIDTH, HILT_HOLE_HEIGHT, HEIGHT], THICK, ROUND);
					//	태그
					//color(c=[0.1, 0.1, 0.1, 0.5])	mark("칼 No. 2", 0.2, BASE, ROUND * 2);
				}
				
				//	칼날홈파기
				roundedBox(size = [BLADE_HOLE_WIDTH, BLADE_HOLE_HEIGHT, HEIGHT * 4], radius = 1, sidesonly = true);

				// 손잡이 홈파기
				translate([0, -(BLADE_HOLE_HEIGHT - HILT_HOLE_HEIGHT) / 2 , 0])
					roundedBox(size = [HILT_HOLE_WIDTH, HILT_HOLE_HEIGHT, THICK + 2], radius = 1, sidesonly = true);

				//	꼬리표
				//mark("칼 No. 2", 0.2, BASE, ROUND);
			}

		}
		
		//	절단방법 기술
		//	translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
		//	translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
		//	translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
	}

}

rotate([180, 0, 0])
	knife2();
