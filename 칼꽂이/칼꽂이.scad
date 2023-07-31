use <MCAD/boxes.scad>
use <칼.scad>

// 상수
height = 24;
HEIGHT = height;
MARGIN = 1;
THICK = 3;
BIG = [1024, 1024, 1024];
opacity = 1;
colorScissor = [0.2, 0.3, 0.4, opacity];

// 측정

data = [
	[17, 20, 4, 46],	// 1번칼, 제일 긴거
	[25, 54, 3, 0],	// 상판
	[0, 0, 0, 0]	// 점, 호환성 예약
];
palette = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 0.5],	//	흰색, 상판
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];

echo(version=version());

module knifeNo1() {
	object = data[0];

	color(c=palette[0]) translate([0, object[1] / 2, HEIGHT / 2]) roundedBox(size=[object[0], object[1], HEIGHT], radius = 1, sidesonly = false);
	color(c=palette[1]) translate([0, object[3] / 2, -HEIGHT / 2]) roundedBox(size=[object[2], object[3], HEIGHT], radius = 1, sidesonly = false);
}

module moldKnifeNo1() {
	knife = data[0];
	object = data[1];

	// 상판
	difference() {
		color(c=palette[2]) roundedBox(size=object, radius = 3, sidesonly = true);

		hilt = [knife[0], knife[1], HEIGHT]; // 손잡이
		hiltMold = hilt + [MARGIN * 2, MARGIN * 2, 0];	// 손잡이 주형

		blade = [knife[2], knife[3], HEIGHT];
		bladeMold = blade + [MARGIN * 1, MARGIN * 2, 0];	// 칼날 주형

		translate([0, - bladeMold[1] / 2  + hiltMold[1] / 2])
			roundedBox(size=hiltMold, radius = 2, sidesonly = true);
		
		translate([0, 0, 0])
		cube(bladeMold, center = true);
	}
}

module prototype() {
	knife = data[0];
	outter = [knife[0], knife[1], HEIGHT] +  [MARGIN * 2, MARGIN * 2, 0];
	inner = outter - [THICK * 2, THICK * 2, THICK * 2];

	
	object = data[1];
	translate([32, 0,  (inner[2] - THICK) / 2]) {
		color(c=palette[1]) difference() {
			union() {
				roundedBox(size=object, radius = THICK, sidesonly = true);
				color(c=palette[0]) translate([0, -(knife[3] + MARGIN * 2 - inner[1]) / 2, -(outter[2] - THICK) / 2]) difference() {
					roundedBox(size=outter, radius = 3, sidesonly = false);
					translate([0, 0, THICK / 2]) roundedBox(size=inner, radius = 3, sidesonly = false);
					translate([0, 0, BIG[2] / 2 + inner[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기

			//		translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
			//		translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
			//		translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
				}
			}
			translate([0, -(knife[3] + MARGIN * 2 - inner[1]) / 2, 0]) translate([0, 0, THICK / 2]) roundedBox(size=inner, radius = 3, sidesonly = false);	//	손잡이 주형
			translate([0, 0, 0])	roundedBox(size=[knife[2] + MARGIN, knife[3] + MARGIN * 2, HEIGHT * 2], radius = 0, sidesonly = true);	//		// 칼날 주형

	//		translate([BIG[0] / 2, 0, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// x축 절단면 보기
	//		translate([0, BIG[1] / 2, 0]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// y축 절단면 보기
	//		translate([0, 0, BIG[2] / 2]) roundedBox(size=BIG, radius = 0, sidesonly = false);	// z축 절단면 보기
		}
	}

}

prototype();






















