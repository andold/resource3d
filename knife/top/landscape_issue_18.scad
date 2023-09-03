//	손잡이 등받이 #18
use <common.scad>
use <landscape.scad>
use <../../common/library.scad>

module punches(height = 2) {
	thick = 60;
	chefsStart = 0;
	translate([chefsStart, 0, 0])						roundedBoxNotCenter([3, height, thick], 1);
	translate([chefsStart + 3 + 15, 0, 0])				roundedBoxNotCenter([4, height, thick], 1);
	translate([chefsStart + (3 + 4) + (15 + 20), 0, 0])	roundedBoxNotCenter([5, height, thick], 1);
}
module back_of_knife(thick = 2, step = 0) {
	param = [
		63, //	칼손잡이 받침대 가로 길이
		8,	//	칼손잡이 받침대 상판 윗면기준으로 높이
		8,	//	칼손잡이 받침대 구멍기준으로 앞쪽 가장자리까지의 거리
		8,	//	칼손잡이 받침대 맨 왼쪽 구멍기준으로 왼쪽 가장자리까지의 거리
		8,	//	칼손잡이 받침대 맨 오른쪽 구멍기준으로 오른쪽 가장자리까지의 거리
		47,	//	구멍들의 가로 길이
		2,	//	구멍들속에 들어가는 높이
		0	//	reserved
	];
	base = [63, 60, 8];
	height = 32;

	// 상판 참조용
	if ($preview) {
		%translate([144 + thick, 48 + (8 - step), 8 + param[6]])
			rotate([90, 180, 0])
			*landscape(8, 8, 12);
	}
	
	// 구멍들
	translate([param[0] + thick, 60 + height, param[6]])
		rotate([90, 180, 0])
		translate([param[3], 0, 0])
		punches(param[6]);
	
	// 등받이
	cube([base[0] + thick * 2, height, param[6]]);
	note_type_1([base[0] + thick * 2, height, param[6]]);
	
	//	앞쪽까지
	translate([thick, height - thick, thick])	cube([param[0], thick, param[2]]);

	//	아래쪽으로
	translate([0, height - thick, 0])	cube([thick, param[2] + thick, param[1] + thick]);
	translate([param[0] + thick, height - thick, 0])	cube([thick, param[2] + thick, param[1] + thick]);
	
	// 덮개 앞쪽
	translate([param[0] + thick * 2, height - thick, param[1] + thick])
		rotate([0, 0, 90])
		cube_type_2([thick, param[0] + thick * 2, thick], thick * 2);
	// 덮개 옆쪽
	translate([0, height - thick, param[1] + thick])
		cube_type_2([thick, param[2] + thick, thick], thick * 2);
	translate([param[0] + thick * 2, (param[2] + thick) + height - thick, param[1] + thick])
		rotate([0, 0, 180])
		cube_type_2([thick, param[2] + thick, thick], thick * 2);

}

module samples() {
	echo("$fn=", $fn);
	back_of_knife();
}

module build(renderMode = false) {
	if (renderMode) {
		$fn = 256;
		back_of_knife();
	} else {
		samples();
	}
}
build();