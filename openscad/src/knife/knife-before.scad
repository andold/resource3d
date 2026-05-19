include	<knife-data.scad>

//	전체 구조물을 상판위에 비스듬이 돌려서 엊저 놓는다
module	basis0p(data = DEFAULT) {
	translate([data["몸체.이동"].x, data["몸체.이동"].y + data["기초.두께"] * 2, data["벽.위치.1"].y + data["벽.위치.2"].y + 0.82])
	rotate([0, 0, data["몸체.회전"]])
	children();
}

//	오른쪽 벽 구조물을 해당 위치에 세운다
module	basis1p(data = DEFAULT) {
	translate([0, data["상판.크기"].x, 0])
	translate([0, 0, sqrt(2) *  data["상판.크기"].y / 2])
	rotate([0, 180 -  data["기초.각도.앞"], 0])
	rotate([0, 0, 180])
	rotate([90, 0, 0])
	children();
}

//	외쪽 벽 구조물을 세운다
module	basis2p(data = DEFAULT) {
	translate([data["기초.중복"] * cos(data["기초.각도.앞"]), 0, 0])
	rotate([90, 0, 0])
	translate([0, data["기초.중복"], 0])
	rotate([0, 0, 45 + 180])
	children();
}
