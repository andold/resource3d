include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = default();

module epaper_part12(map = DEFAULT) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이, heightUnderPanel
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기, sizeUnderPanelHill
	echo(str(parent_module(0), ".", parent_module(1)), heightUnderPanel = heightUnderPanel);
	echo(str(parent_module(0), ".", parent_module(1)), sizeUnderPanelHill = sizeUnderPanelHill);

	difference() {
		color(COLOR) {
			snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);
			snsize = 8;
			sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
			heightUnderPanel = get(map, "under.panel.height", DEFAULT);	//	밑판의 높이

			carve(snumber, size = snsize, offset = snsize / 10, halign = "center", rotate = [0, 0, 0], translate = [sizeOutterUnderPanel.x / 2, snsize / 2 + 2, heightUnderPanel], preview = !true) {
				epaper_part04(map);
			}
		}

		translate([0, 0, heightUnderPanel + sizeUnderPanelHill.z])
		mirror([0, 0, 1])
		epaper_part10(map, female = true);
	}
}

module main(command = 0) {
	map = DEFAULT;
	
	if (command == 0) {
	} else if (command == 1) {
		epaper_part12a(map);
	} else if (command == 2) {
		epaper_part12(map);
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 2 : command);
