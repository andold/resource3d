use <MCAD/boxes.scad>

//	상수
BIG = [1024, 1024, 1024];

//
//	under construction
//

// 주요 수치
THICK = 2;		//	껍질두께
ROUND = 8;	//	상판굴곡
BASE_WIDTH	=	128 - 32 - 8;
BASE_HEIGHT	=	128 - 8;
BASE = [BASE_WIDTH, BASE_HEIGHT, THICK];	//	상판
BASE_MARGIN	=	16;
GUIDE_X	=	[BASE_MARGIN, BASE_MARGIN + 20, BASE_MARGIN + 36, BASE_MARGIN + 45];
GUIDE_Y	=	[0, BASE_HEIGHT - BASE_MARGIN / 2];
PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];

echo(BASE_WIDTH);

// 주요 수치
BLADE_HOLE_WIDTH = [5, 3, 2, 2];
BLADE_HOLE_HEIGHT = 48;	// 날너비(46) + 여유(2)
SCISSOR_HOLE_WIDTH = 14;		//	가위 두께
SCISSOR_HOLE_HEIGHT = 40;	//	가위 너비

// 텍스트 홈파기
// 상판(base)의 왼쪽 아래 기준준
module mark(name, height, size = 2) {
	translate([0, 0, height / 2])
		linear_extrude(height, center = false)
			text(name, size = size);
}
module print(message) {
	echo("------------------------------------------------------");
	echo(message);
	echo("------------------------------------------------------");
}

//	chefs1
//	거치 홈 너비는 날두께 4mm 이상이면 된다.
//	거치 홈 길이는 날너비 46mm 이상이면 된다.
module chefs1_plate(plate, m = THICK) {
	if (plate[1] <= 46) {
		print("홈길이가 날너비(46mm)보다 길어야 합니다.");
	} else if (plate[1] <= 46 + 4) {
		print("홈길이가 날너비보다 충분히 길어야 합니다.");
	}
		
	hole = [4 + 1, plate[1] - m * 2, plate[2] * 2];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			roundedBox(size = plate, radius = 0, sidesonly = true);
			roundedBox(size = hole, radius = hole[0] / 4, sidesonly = true);
		}
	}
	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("1", 0.2, 1);
}

//	chefs2
/*
	- 거치 홈 너비는 날두께 3mm 이상이면 된다.
	- 거치 홈 길이는 날너비 52mm 이상이면 된다.
*/
module chefs2_plate(plate, m = THICK, height = 16, width = 32) {
	if (plate[1] <= 52) {
		print("홈길이가 날너비(52mm)보다 길어야 합니다.");
	} else if (plate[1] <= 52 + 4) {
		print("홈길이가 날너비보다 충분히 길어야 합니다.");
	}
		
	hole = [3 + 1, plate[1] - m * 2, 1024];
	outter = [hole[0] + plate[2] * 2, width, height];
	inner = outter - [m * 2, m * 2, -1];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			union() {
				roundedBox(size = plate, radius = 0, sidesonly = true);
				translate([0, (outter[1] - plate[1]) / 2, outter[2] / 2])
					difference() {
						roundedBox(size = outter, radius = 1, sidesonly = true);
						roundedBox(size = inner, radius = 1, sidesonly = true);
					}
			}
			roundedBox(size = hole, radius = hole[0] / 4, sidesonly = true);
		}
	}
	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("2", 0.2, 1);
}

//	chefs3
/*
	- 거치 홈 너비는 날두께 2mm 이상이면 된다.
	- 거치 홈 길이는 날너비 41mm 이상이면 된다.
*/
module chefs3_plate(plate, m = THICK) {
	if (plate[1] <= 41) {
		print("홈길이가 날너비(41mm)보다 길게 합시다. 나중을 위해서.");
	}

	hole = [2 + 1, plate[1] - m * 2, 1024];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			roundedBox(size = plate, radius = 0, sidesonly = true);
			roundedBox(size = hole, radius = hole[0] / 4, sidesonly = true);
		}
	}

	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("3", 0.2, 1);
}

//	bread
/*
	- 날두께는 1mm 이다
	- 날너비는 10mm ~ 12mm 이다.
*/
module bread_plate(plate, m = THICK) {
	if (plate[1] <= 10) {
		print("홈길이가 날너비(10mm)보다 길게 합시다. 나중을 위해서.");
	}

	hole = [1 + 1, plate[1] - m * 2, 1024];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			roundedBox(size = plate, radius = 0, sidesonly = true);
			roundedBox(size = hole, radius = hole[0] / 4, sidesonly = true);
		}
	}

	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("B", 0.2, 1);
}

//	scissors
/*
	가위
	- 거치 홈 너비는 두께 14mm 이상이면 된다.
	- 거치 홈 길이는 40mm 근처면 된다.
*/
module scissors_plate(plate, m = THICK) {
	if (plate[0] - m * 2 <= 14) {
		print("너비는 두께(14mm)보다 커야 합니다..");
	}

	hole = [1 + 1, plate[1] - m * 2, 1024];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			roundedBox(size = plate, radius = 0, sidesonly = true);
			translate([0, 0, -16])
				resize([plate[0] - m * 2, plate[1] - m * 2, 1014])
					cylinder(1024, 1024, 1024);
		}
	}

	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("B", 0.2, 1);
}

//	일반 홈
module general_plate(plate, m = THICK, t = 1) {
	echo(plate, m, t);
	hole = [t, plate[1] - m * 2, 1024];
	translate([plate[0] / 2, plate[1] / 2, plate[2] / 2]) {
		difference() {
			roundedBox(size = plate, radius = 0, sidesonly = true);
			roundedBox(size = hole, radius = hole[0] / 4, sidesonly = true);
		}
	}

	color(c=PALETTE[3])
		translate([1, 1, plate[2]])
			mark("G", 0.2, 1);
}

// deprecated
module top_plate_by_add_each_defined_hole() {
	translate([0, 0, 0])		chefs1_plate([16, 60, THICK], THICK);
	translate([16, 0, 0])	chefs2_plate([16, 60, THICK], THICK, 16);
	translate([32, 0, 0])	chefs3_plate([12, 44, THICK], THICK);

	translate([44, 0, 0])	bread_plate([12, 16, THICK], 1);
	translate([44, 16, 0])	bread_plate([12, 18, THICK], 1);
	translate([44, 34, 0])	bread_plate([12, 20, THICK], 1);
	translate([44, 54, 0])	general_plate([8, 16, THICK], 1, 1);
	translate([44, 54, 0])	general_plate([8, 16, THICK], 1, 1);

	translate([30, 44, 0])	general_plate([8, 16, THICK], 1, 1);
	translate([38, 44, 0])	general_plate([8, 16, THICK], 1, 1);

	translate([56, 0, 0])	scissors_plate([20, 40, THICK], 2);
	translate([56, 40, 0])	scissors_plate([20, 40, THICK], 2);
}

module hole(w, h) {
	translate([w / 2, h / 2, 0])
		roundedBox(size=[w, h, 1024], radius = w / 4, sidesonly = true);
}
module ellipsis(w, h) {
	translate([w / 2, h / 2, -1024 / 2])
		resize([w, h, 1024])
			cylinder(1024, 1024, 1024);
}
module hilt(base, r) {
	translate([base[0] / 2, base[1] / 2, base[2] / 2])
		roundedBox(size=base, radius = r, sidesonly = true);
}

//
module top_plate() {
	base = BASE + [-12, 4, 0];
	HILT = [4 + THICK * 2, 32, 16];
		union() {
			//	홈파기
			difference() {
				union() {
					//	상판
					color(c=PALETTE[2])
						translate([base[0] / 2, base[1] / 2, THICK / 2])
							roundedBox(size=base, radius = ROUND, sidesonly = true);
					translate([-8, -8, 0]) {
						color(c=PALETTE[0])
							translate([BASE_MARGIN, BASE_MARGIN, 0])
									hilt(HILT, THICK);
					}
				}
				
				translate([-8, -8, 0]) {
					//	식도
					translate([BASE_MARGIN + THICK, BASE_MARGIN + THICK, 0])			hole(4, 60);
					translate([BASE_MARGIN  + THICK + 16, BASE_MARGIN + THICK, 0])	hole(5, 60);
					translate([BASE_MARGIN  + THICK + 32, BASE_MARGIN + THICK, 0])	hole(3, 60);

					// 과도
					translate([BASE_MARGIN  + THICK + 00, BASE_MARGIN + THICK + 64, 0])	hole(3, 28);

					// 빵칼
					translate([BASE_MARGIN  + THICK + 12, BASE_MARGIN + THICK + 64, 0])	hole(3, 20);
					translate([BASE_MARGIN  + THICK + 12, BASE_MARGIN + THICK + 64 + 22, 0])	hole(3, 18);
					translate([BASE_MARGIN  + THICK + 22, BASE_MARGIN + THICK + 64, 0])	hole(3, 20);
					translate([BASE_MARGIN  + THICK + 22, BASE_MARGIN + THICK + 64 + 22, 0])	hole(3, 18);
					translate([BASE_MARGIN  + THICK + 32, BASE_MARGIN + THICK + 64, 0])	hole(3, 20);
					translate([BASE_MARGIN  + THICK + 32, BASE_MARGIN + THICK + 64 + 22, 0])	hole(3, 18);

					// 가위
					translate([BASE_MARGIN  + THICK + 42, BASE_MARGIN + THICK + 0, 0])	ellipsis(16, 40);
					translate([BASE_MARGIN  + THICK + 42, BASE_MARGIN + THICK + 50, 0])	ellipsis(16, 40);
					
					// 여유
					translate([BASE_MARGIN  + THICK + 58, BASE_MARGIN + THICK + 100, 0])	rotate([0, 0, 90])	hole(3, 20);
				}

				// 모서리 구멍
				translate([4, 4, 0])	ellipsis(1, 1);
				translate([base[0] - 8, 4, 0])	ellipsis(1, 1);
				translate([base[0] - 8, base[1] - 8, 0])	ellipsis(1, 1);
				translate([4, base[1] - 8, 0])	ellipsis(1, 1);
			}
		}
				//	translate([8, 8, 0])	ellipsis(2, 2);
}
top_plate();

//	deprecated
module top_plate_by_define_hole_postion() {
	half = BASE[1] / 2 - BASE_MARGIN -  THICK;
	third = (BASE[1] - BASE_MARGIN * 2 - THICK * 2) / 3;
	forth = (BASE[1] - BASE_MARGIN * 2 - THICK * 3) / 4;

	echo(BASE_WIDTH, half, third, forth);

	difference() {	//	절단면을 보기위하여
		// 주 물체
		union() {
			//	홈파기
			difference() {
				union() {
					//	상판
					color(c=PALETTE[2])
						translate([BASE[0] / 2, BASE[1] / 2, THICK / 2])
							roundedBox(size=BASE, radius = ROUND, sidesonly = true);

					//	태그
					color(c=PALETTE[3])
						translate([BASE[0] - 16, ROUND, BASE[2]])
							mark("andold", 0.2, BASE, BASE_MARGIN);
				}
				
				//	칼날홈파기
				//	1번 제일 두꺼운 칼날 홈
				translate([GUIDE_X[0], BASE_MARGIN, -THICK])
					translate([BLADE_HOLE_WIDTH[0] / 2, half / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[0], half, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[0], BASE[1] - BASE_MARGIN -half, -THICK])
					translate([BLADE_HOLE_WIDTH[0] / 2, half / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[0], half, THICK * 4], radius = 1, sidesonly = true);

				//	두번째로 두꺼운 칼날 홈
				translate([GUIDE_X[1], BASE_MARGIN, -THICK])
					translate([BLADE_HOLE_WIDTH[1] , (third) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[1], third, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[1], BASE_MARGIN + third + THICK, -THICK])
					translate([BLADE_HOLE_WIDTH[1] , (third) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[1], third, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[1], BASE_MARGIN + (third + THICK) * 2, -THICK])
					translate([BLADE_HOLE_WIDTH[1] , (third) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[1], third, THICK * 4], radius = 1, sidesonly = true);

				//	빵칼 칼날 홈파기
				translate([GUIDE_X[2], BASE_MARGIN, -THICK])
					translate([BLADE_HOLE_WIDTH[2] , (forth) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[2], forth, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[2], BASE_MARGIN + (forth + THICK) * 1, -THICK])
					translate([BLADE_HOLE_WIDTH[2] , (forth) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[2], forth, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[2], BASE_MARGIN + (forth + THICK) * 2, -THICK])
					translate([BLADE_HOLE_WIDTH[2] , (forth) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[2], forth, THICK * 4], radius = 1, sidesonly = true);
				translate([GUIDE_X[2], BASE_MARGIN + (forth + THICK) * 3, -THICK])
					translate([BLADE_HOLE_WIDTH[2] , (forth) / 2, THICK * 2])
						roundedBox(size = [BLADE_HOLE_WIDTH[2], forth, THICK * 4], radius = 1, sidesonly = true);

				//	가위 홈파기
				translate([GUIDE_X[3], BASE_MARGIN , -THICK])
					translate([SCISSOR_HOLE_WIDTH / 2,SCISSOR_HOLE_HEIGHT / 2, THICK* 2])
						resize([SCISSOR_HOLE_WIDTH, SCISSOR_HOLE_HEIGHT, THICK * 4])	cylinder(h = 100, r = 100, center = true);
				translate([GUIDE_X[3], BASE[1] - BASE_MARGIN - SCISSOR_HOLE_HEIGHT , -THICK])
					translate([SCISSOR_HOLE_WIDTH / 2,SCISSOR_HOLE_HEIGHT / 2, THICK* 2])
						resize([SCISSOR_HOLE_WIDTH, SCISSOR_HOLE_HEIGHT, THICK * 4])	cylinder(h = 100, r = 100, center = true);
			}

		}
		
		//	절단방법 기술
		//	translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
		//	translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
		//	translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
	}

}

//top_plate();

