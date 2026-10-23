use <MCAD/boxes.scad>

include	<../../common/constants.scad>
include	<../knife-data.scad>
use <../../common/library.scad>
use <../../common/library_text.scad>

use <common.scad>
use <../../common/utils.scad>

PALETTE = [
	[0.3, 0.1, 0.0, 0.5],	//	갈색, 칼손잡이
	[0.5, 0.5, 0.5, 0.5],	//	회색, 칼날
	[0.9, 0.9, 0.9, 1.0],	//	흰색, 상판
	[0.0, 0.0, 0.9, 0.5],	//	파랑
	[0.0, 0.0, 0.0, 0.0]	//	검정 투명, 호환성 예약
];

//	인자가 없으면 data 의 값을 쓴다 (기존 호출부 landscape(thick, margin, delta) 호환)
function landscapeThick(thick, data)	= is_undef(thick) ? data["상판.크기"].z : thick;
function landscapeMargin(margin, data)	= is_undef(margin) ? data["상판.여백"] : margin;
function landscapeDelta(delta, data)	= is_undef(delta) ? data["칼구멍.간격"] : delta;

// export
function landscapeSize(thick, margin, delta, data = DEFAULT) = let(
	m = landscapeMargin(margin, data)
)	coreSize(landscapeDelta(delta, data), landscapeThick(thick, data), data) + [m * 2, m * 2, 0];

module chefsKnife(p, q) {
	difference() {
		union() {
			color("White", 1.0)	cube(p, true);
			note_type_1([p[0], p[1], p[2]]);
		}
		translate([0, 0, -p[2] / 1.8])
			rotate([15, 0, 0]) {
				cube([p[0] + 1, p[1], p[2] * 2], true);
			}
	}
	translate([0, (p[1] - q[1]) / 2, p[2] / 2 + q[2] / 2]) cube(q, true);
}

//	─── 배치 래퍼 ───────────────────────────────────────────────
//	칼구멍 영역의 원점(좌하단)으로 옮긴다
module landscape0p(margin) {
	translate([margin, margin, 0])
	children();
}

//	손잡이 가이드 위치: 식도 구멍들을 thick 만큼 둘러싼다
module landscape1p(thick, margin, delta, data) {
	translate([margin + chefsInfo(delta, data)[0] - thick, margin - thick, 0])
	children();
}

//	빵칼 등받이 위치
module landscape2p(thick, margin, delta, data) {
	translate([delta, margin - thick / 2 + data["상판.등받이.두께"], thick])
	children();
}

//	좌우 끝면 나사구멍 위치: side = 0 왼쪽, 1 오른쪽 / row = 0 앞, 1 뒤
module landscape3p(base, thick, side, row) {
	translate([side == 0 ? -EPSILON : base.x + EPSILON, row == 0 ? thick / 2 : base.y - thick / 2, thick / 2])
	rotate([0, side == 0 ? 90 : -90, 0])
	children();
}

//	─── 형상 ────────────────────────────────────────────────────
//	상판 본체 + 서명
module landscape_plate(base, thick, margin, data) {
	echo(str("상판 본체::", parent_module(0), ".", parent_module(1), "(", base, ")"));

	translate([base.x / 2, base.y / 2, thick / 2])
	roundedBox(base, data["상판.모서리반경"], true, $fn = FN);
	note_type_1([base.x, base.y, base.z]);

	//	서명
	color(c = PALETTE[2])
	translate([base.x - margin / 2 - 2, margin / 4, thick / 2])
	linear_extrude(data["상판.서명.두께"], center = false, slices = $preview ? 20 : 16 * 4)
	text(data["상판.서명"], size = data["상판.서명.크기"], halign = "right", $fn = FN);
}

//	손잡이 가이드 + 손잡이 등받이. 원점은 가이드의 좌하단
module landscape_handle(base, thick, margin, delta, data) {
	x = chefsInfo(delta, data)[1] + thick * 2;
	y = base.y / 2;
	z = data["상판.손잡이.높이"];
	back = [x, data["상판.등받이.두께"], data["상판.등받이.높이"]];
	echo(str("손잡이 가이드::", parent_module(0), ".", parent_module(1), "(", [x, y, z], ", ", back, ")"));

	roundedBoxNotCenter([x, y, z], 2, true);
	note_type_1([x, y, z]);

	// 손잡이 등받이
	translate([0, margin - thick + data["상판.등받이.두께"], z]) {
		roundedBoxNotCenter(back, 0.5, true);
		note_type_1(back);
	}
}

//	빵칼 등받이. 원점은 등받이의 좌하단
module landscape_bread_back(data) {
	size = [data["상판.빵칼등받이.길이"], data["상판.등받이.두께"], data["상판.등받이.높이"]];
	echo(str("빵칼 등받이::", parent_module(0), ".", parent_module(1), "(", size, ")"));

	roundedBoxNotCenter(size, 0.5, true);
	note_type_2("빵칼 등받이", size);
}

//	나사구멍 하나 (z 방향)
module landscape_hole(data) {
	cylinder(data["상판.나사.깊이"], RADIUS_HOLE_NUT_25, RADIUS_HOLE_NUT_25, $fn = $preview ? 16 : 360);
}

//	확인용 식도 (유령)
module landscape_ghost(thick, margin, delta, data) {
	p = data["상판.유령칼.날"];
	q = data["상판.유령칼.손잡이"];
	%translate([chefsInfo(delta, data)[0] + margin + 44.5, margin + 23.5, -p[2] / 2 + data["상판.손잡이.높이"] + 1])
		rotate([0, 0, 180])
		chefsKnife(p, q);
}

module landscape(thick, margin, delta, data = DEFAULT) {
	t = landscapeThick(thick, data);
	m = landscapeMargin(margin, data);
	d = landscapeDelta(delta, data);
	base = landscapeSize(t, m, d, data);	//	상판
	echo(str("상판::", parent_module(0), ".", parent_module(1), "(", t, ", ", m, ", ", d, ")"), base = base);

	difference() {
		union() {
			landscape_plate(base, t, m, data);

			landscape1p(t, m, d, data)
			landscape_handle(base, t, m, d, data);

			landscape2p(t, m, d, data)
			landscape_bread_back(data);
		}

		// 칼구멍: 상판과 손잡이 가이드를 함께 관통한다
		landscape0p(m)
		translate([0, 0, -EPSILON])
		punch(undef, data["상판.손잡이.높이"] + EPSILON * 2, d, data);

		// 나사구멍
		for (side = [0, 1], row = [0, 1])
			landscape3p(base, t, side, row)
			landscape_hole(data);
	}

	landscape_ghost(t, m, d, data);
}

module landscapePrototype(param, data = DEFAULT) {
	size = landscapeSize(param[0], param[1], param[2], data);
	cube(size);
	note_type_2("Prototype", size);
}

module build(target, step, data = DEFAULT) {
	echo("landscape build start: ", target, step);

	if (!$preview) {
		$fn = 360;
	}

	thick = data["상판.크기"].z;
	margin = data["상판.여백"];
	delta = data["칼구멍.간격"];
	param = [thick, margin, delta];

	if (target == 1) {
		landscape(thick, margin, delta, data);
	} else if (target == 2) {
		landscapePrototype(param, data);
	}

	echo("landscape build done: ", target, step);
}

target = 1;
build(target, $t);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe --export-format asciistl -o C:\src\eclipse-workspace\resource3d\stl\landscape.stl -D target=1 C:\src\eclipse-workspace\resource3d\knife\top\landscape.scad
*/
