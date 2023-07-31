use <MCAD/boxes.scad>

//
//	under construction
//

// 상수
THICK = 2;			//	껍질두께
WIDTH	=	300;	//	몸통 너비
DEEP	=	300;	//	깊이
HEIGHT	=	500;	//	전체 홈 높이이
ROUND = 2;	//	굴곡
BIG = [1024, 1024, 1024];	//	절단면을 보기 위한 절단 물체(아주 큰거면 다됨)

// 주요 수치
SHELF_WIDTH	=	180;	//	선반 너비
SHELF_HEIGHT	=	70;	//	선반 높이
HOLE_WIDTH		=	14;	//	파인곳 너비
HOLE_HEIGHT	=	50;	//	파인곳 높이

// 텍스트 홈파기
// 상판(base)의 왼쪽 아래 기준준
module mark(name = "andold", height = 4, base = BASE, mx = ROUND * 2) {
	translate([-base[0] / 2 + mx, base[1] / 2 - mx, base[2] / 2 - height])
		rotate([180, 0, 0])
			linear_extrude(THICK, center = false)
				text(name, size = 1, language = "kr", font = "NanumGothic");
}

module prototype() {
	difference() {	//	절단면을 보기위하여
		
		// 주 물체
		union() {
			//	홈파기
			difference() {
				union() {
					color(c=[0.3, 0.1, 0.0, 0.5])	roundedBox(size=[WIDTH - (SHELF_WIDTH - HOLE_WIDTH), DEEP, HOLE_HEIGHT], radius = ROUND, sidesonly = true);
					color(c=[0.3, 0.1, 0.0, 0.9])
						translate([0, 0, -HOLE_HEIGHT])
							roundedBox(size=[WIDTH - (SHELF_WIDTH), DEEP, SHELF_HEIGHT - HOLE_HEIGHT], radius = ROUND, sidesonly = true);
					color(c=[0.8, 0.8, 0.8, 0.0])
						translate([-WIDTH / 2, 0, HEIGHT/2])
							translate([HOLE_WIDTH/2, 0, -HOLE_HEIGHT/2])
								roundedBox(size=[HOLE_WIDTH, WIDTH, HOLE_HEIGHT], radius = ROUND, sidesonly = true);
					color(c=[0.8, 0.8, 0.8, 0.0])
						translate([-WIDTH / 2, 0, HEIGHT/2])
							translate([SHELF_WIDTH/2, 0, -HOLE_HEIGHT-SHELF_HEIGHT])
								roundedBox(size=[SHELF_WIDTH, WIDTH, SHELF_HEIGHT], radius = ROUND, sidesonly = true);
				}
			}

		}
		
		//	절단방법 기술
		//	translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
		//	translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
		//	translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
	}

}

rotate([180, 0, 0])
	prototype();
