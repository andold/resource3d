// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>

use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-04.scad>
//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝ

ID = "⑤";
MARGIN_BACKGROUND = [8, 8];
COLOR = [0.3, 0.5, 0.1, 0.9];

function PART05() = [PART04().x, PART04().y, 1];
function PADDING05() = [0.5, 0.5];

pNotate = [PART05().x - 16, 16];

module background_05() {
	margin02 = MARGIN02();
	margin04 = MARGIN04();
	part05 = PART05();

	translate([-PART05().x - MARGIN_BACKGROUND.x, 0, 0])
	epaper_part_04();

	translate([margin02.x + margin04.x, margin02.y + margin04.y + MARGIN_BACKGROUND.y, 0])
	translate([0, part05.y, 0])
	epaper_display_part_01();
}
module epaper_display_part_05() {
	part01 = PART01();
	part02 = PART02();

	margin02 = MARGIN02();
	margin04 = MARGIN04();
	part05 = PART05();

	s01 = [
		part01.x + PADDING05().x * 2,
		part01.y + PADDING05().y * 2,
		part05.z
	];
	p01 = [
		(PART05().x - s01.x) / 2,
		s01.y + (PART04().y - part01.y) - (margin02.y + margin04.y) - PADDING05().y,
		0
	];
	dpy = 4;
	difference() {
		union() {
			//	원래판
			color(COLOR)
			cube(PART05());
			%translate([0, PART05().y / 2, PART05().z])	text(ID, font = "D2Coding", size = 2);

			%color("yellow")
			translate([2, PART05().y - 3, PART05().z + EPSILON * 2])
			linear_extrude(height = PART05().z) {
				text(str(ID, " Cover Outter: ", PART05().x, " x ", PART05().y, " x ", PART05().z, "mm"), font = "D2Coding", size = 2);
			}
			
			//	왼쪽
			translate([0, p01.y - dpy, PART05().z])
			notate([(PART05().x - s01.x) / 2, 2]);

			translate([(PART05().x - s01.x) / 2, p01.y - dpy, PART05().z])
			notate([(s01.x), 2]);

			translate([PART05().x - (PART05().x - s01.x) / 2, p01.y - dpy, PART05().z])
			notate([(PART05().x - s01.x) / 2, 2]);
		}
		
		//	삭제판, Active Area
		translate([p01.x, p01.y - s01.y, -EPSILON])
		cube([s01.x, s01.y, s01.z + EPSILON * 2]);
	}

	dpx = part05.x - p01.x * 2 - 4;
	translate([p01.x + dpx, 0, PART05().z])
	notate([2, p01.y - s01.y]);

	translate([p01.x + dpx, p01.y - s01.y, PART05().z])
	notate([2, part01.y + PADDING05().y * 2]);

	translate([p01.x + dpx, p01.y, PART05().z])
	notate([2, part05.y - p01.y]);
}
module main() {
	%background_05();
	epaper_display_part_05();
}

main();
