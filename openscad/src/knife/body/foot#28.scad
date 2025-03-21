use <MCAD/boxes.scad>

include	<../../common/constants.scad>
use <../../common/library.scad>

DEFAULT_PARAM = [
		4,		//	thick = 4;
		1,		//	margin = 1;		//	하층판 결합부위 여유 공간
		200,	//	overlap = 32;	//	하층판과 기초판이 겹치는 길이
		128,	//	height = 128;	//	기초판의 높이
		30,	//	anglex = -30;	//	앞으로 기울어지는 정도
		-30,	//	anglez = -30;	//	옆으로 돌아가는 정도
		0		//	reserved
];

/*
	튀어나오는 쪽에 발 세우기
*/
module basis01_type_3_foot() {
	echo("basis01_type_3_foot 처음: ", DEFAULT_PARAM);

	thick = DEFAULT_PARAM[0];
	radious = thick;

	outter = radious * 4;
	h = 57.7 + 13;
	inner = radious * 1.05;
	difference() {
		union() {
			translate([inner, inner, 0])		cylinder(h + inner * 2, outter, outter, $fn=FN);
		}
		hull() {
			line_type_1([0, 0, h], [radious * 8, 0, h], inner);
			translate([0, 0, radious * 8])	line_type_1([0, 0, h], [radious * 8, 0, h], inner);
		}
		hull() {
			line_type_1([0, 0, h], [0, radious * 8, h], inner);
			translate([0, 0, radious * 8])	line_type_1([0, 0, h], [0, radious * 8, h], inner);
		}
	}

	echo("basis01_type_3_foot 끝: ", DEFAULT_PARAM);
}
basis01_type_3_foot();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\foot#28.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\knife\body\foot#28.scad
*/