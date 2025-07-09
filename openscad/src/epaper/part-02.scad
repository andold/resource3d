// 라이브러리, 검증된 것만 이곳에
SIZE = [25.50, 24.00];
MARGIN = [72.35];

function PART_02() = [SIZE.x, SIZE.y, 0.1];
function MARGIN_02() = [MARGIN.x, 0, 0];

module epaper_display_part_02() {
	color([0.9, 0.5, 0.0], 0.9)
	cube(PART_02());
}

epaper_display_part_02();
