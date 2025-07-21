include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>

//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
function PART06() = let(
						p1 = PART01(),
						p2 = PART02(),
						size2 = p2[0],
						p3 = PART03(),
						size3 = p3[0]) [[
		[size2.x, size2.y, size2.z, "주요 크기. Display Panel과 동일다."],
		[size2.x, size2.y + size3.y, size2.z, "외경"],
		[0, 0, size3.y, 0, "여백(top, left, bottom, right)"],
	],
	p3,
	p2,
	p1,
	"waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3"
];
function MARGIN06() = [0, -PART03().y, 0];

module log(v) {
	if (is_list(v)) {
		for (cx = [0:len(v) - 1]) {
			echo("index:", cx, " = ", v[cx]);
		}
	} else {
		echo("NOT LIST", v);
	}
}

module epaper_part_06(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"), HR);
	log(v);

	assert(!is_undef(v));

	sizeActiveArea = v[3];	//	Active Area 실제 그림이 그려지는 화면 영역, sizeActiveArea
	sizeDisplayPanel = v[2][0];	//	부품의 크기", "sizeDisplayPanel"
	marginActiveArea = v[2][1];	//	Active Area의 상대적 위치 = 좌상단의 여백", "marginActiveArea
	sizeConnect = v[1][0];
	margin3 = v[1][1];
	echo(sizeActiveArea = sizeActiveArea, sizeDisplayPanel = sizeDisplayPanel, marginActiveArea = marginActiveArea, sizeConnect = sizeConnect, margin3 = margin3);
	
	translate([marginActiveArea.x, (sizeDisplayPanel.y - sizeActiveArea.y) - marginActiveArea.y, sizeDisplayPanel.z])
	epaper_part_01();
	
	epaper_part_02();

	translate([margin3.x, -sizeConnect.y, 0])
	epaper_part_03(v[1]);
	
	%
	color("white")
	translate([0, -2.2, 0])
	linear_extrude(height = EPSILON) {
		text(str("⑥ = ①+②+③"), font = "D2Coding", size = 2);
	}
}

module main() {
	v = PART06();
	epaper_part_06(v);
	echo(fff());
}

main();
