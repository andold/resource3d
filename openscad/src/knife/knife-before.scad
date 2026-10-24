include	<knife-data.scad>

//	배치 래퍼 모듈만 둔다 (형상 없음). 회전/이동 값은 knife-data.scad 의 data 맵을 쓴다

//	전체 구조물을 상판위에 비스듬이 돌려서 엊저 놓는다
//	z = 벽 높이(벽.위치.1.y + 벽.위치.2.y) + 몸체.이동.z
module	basis0p(data = DEFAULT) {
	translate([data["몸체.이동"].x, data["몸체.이동"].y + data["기초.두께"] * 2, data["벽.위치.1"].y + data["벽.위치.2"].y + data["몸체.이동"].z])
	rotate([0, 0, data["몸체.회전"]])
	children();
}

//	오른쪽 벽 구조물을 해당 위치에 세운다
//	basis2p 의 왼쪽 지지대와 xz 단면이 겹치도록 이동한다 (어떤 기초.각도.앞 에서도)
//		x = (기초.중복 - 기초.길이) * cos(앞), z = 기초.중복 - 기초.길이 * sin(앞)
//	예전 z 이동 sqrt(2) * 상판.크기.y / 2 는 45도 전용이었고, 그때도 0.82mm 높았다
module	basis1p(data = DEFAULT) {
	angle = data["기초.각도.앞"];
	translate([(data["기초.중복"] - data["기초.길이"]) * cos(angle), data["상판.크기"].x, data["기초.중복"] - data["기초.길이"] * sin(angle)])
	rotate([0, 180 - angle, 0])
	rotate([0, 0, 180])
	rotate([90, 0, 0])
	children();
}

//	외쪽 벽 구조물을 세운다 (basis1p 와 같은 기초.각도.앞 만큼 기울인다)
module	basis2p(data = DEFAULT) {
	translate([data["기초.중복"] * cos(data["기초.각도.앞"]), 0, 0])
	rotate([90, 0, 0])
	translate([0, data["기초.중복"], 0])
	rotate([0, 0, data["기초.각도.앞"] + 180])
	children();
}
