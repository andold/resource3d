include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>

//	암막상자
DEFAULT = [
	["원본.각목",				[600, 18, 18, 9],	"원본 각목 18 x 18 x 600 x 9"],
	["원본.암막지",				[900, 3000, 1, 1],	"원본 암막지 900 x 3000 x 1 x 1"],
	["각목.뚜껑.여유",			[5, 0, 0],	"원본 각목 18 x 18 x 600 x 9"],
	
	"andold", "" 
];
function default() = DEFAULT;

//	원본
module blackout01(map) {
//	echo(str("", parent_module(0), ".", parent_module(1), "(", map, ")"), HR);
	assert(!is_undef(map));

	originLumber = get(map, "원본.각목", DEFAULT);
	originFabric = get(map, "원본.암막지", DEFAULT);

	for (cx = [1:originLumber[3]]) {
        description = str(parent_module(0), "원본.각목 : ", cx, " : ",
                        originLumber.x, " x ", originLumber.y, " x ", originLumber.z,
                        "");
		translate([0, cx * originLumber.y * 2, 0])
            carve(description, size = 4, offset = 0.4, rotate = [0, 0, 0], preview = !true, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
			cube([originLumber.x, originLumber.y, originLumber.z]);
	}
}

//	뚜껑 구조물
module blackout0203(map) {
	echo(str("", parent_module(0), ".", parent_module(1), "(", map, ")"), HR);
	assert(!is_undef(map));

	SCALE_TEXT = 5;
	originLumber = get(map, "원본.각목", DEFAULT);

	translate([0, 0, originLumber.x / 2 + originLumber.y * 2])
	color("Olive", 0.2) {
		let (size = [originLumber.x / 2 - originLumber.y * 2, originLumber.y, originLumber.z]) {
		
			translate([originLumber.y, originLumber.y, 0])
			carve(str("1", ".  ", parent_module(1), " : ", size.x, " x ", size.y, " x ", size.z)
				, size = originLumber.y / SCALE_TEXT
				, offset = originLumber.y / SCALE_TEXT / 10
				, rotate = [0, 0, 0]
				, preview = !true
			, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
			cube(size);
		
			translate([originLumber.y, originLumber.x / 2, 0])
			carve(str("2", ".  ", parent_module(1), " : ", size.x, " x ", size.y, " x ", size.z)
				, size = originLumber.y / SCALE_TEXT
				, offset = originLumber.y / SCALE_TEXT / 10
				, rotate = [0, 0, 0]
				, preview = !true
			, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
			cube(size);
		}
		translate([originLumber.x / 4 + originLumber.y * 1.5, 0, originLumber.y])
		rotate([0, 0, 90])
		let (size = [originLumber.x / 2 + originLumber.y * 2, originLumber.y, originLumber.z]) {
			carve(str("1", ".  ", parent_module(1), " : ", size.x, " x ", size.y, " x ", size.z)
				, size = originLumber.y / SCALE_TEXT
				, offset = originLumber.y / SCALE_TEXT / 10
				, rotate = [0, 0, 0]
				, preview = !true
			, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
			cube(size);
	
			translate([0, originLumber.y * 2, 0])
			carve(str("2", ".  ", parent_module(1), " : ", size.x, " x ", size.y, " x ", size.z)
				, size = originLumber.y / SCALE_TEXT
				, offset = originLumber.y / SCALE_TEXT / 10
				, rotate = [0, 0, 0]
				, preview = !true
			, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
			cube(size);
		}
	}
}

//	세로:상하 구조물:지지대
module blackout0202(map) {
	SCALE_TEXT = 5;
	originLumber = get(map, "원본.각목", DEFAULT);
	
	color("DimGray", 0.2) {
		translate([originLumber.y, 0, originLumber.y])
		rotate([0, -90, 0])
		carve(str("1", ".  ", parent_module(1), originLumber.x / 2, " x ", originLumber.y, " x ", originLumber.z)
			, size = originLumber.y / SCALE_TEXT
			, offset = originLumber.y / SCALE_TEXT / 10
			, rotate = [90, 0, 0]
			, preview = !true
			, translate = [originLumber.y / 2, -originLumber.y / 2, originLumber.z])
		cube([originLumber.x / 2, originLumber.y, originLumber.z]);

		translate([originLumber.y, originLumber.x / 2 + originLumber.y, originLumber.y])
		rotate([0, -90, 0])
		carve(str("3", ".  ", parent_module(1), originLumber.x / 2, " x ", originLumber.y, " x ", originLumber.z)
			, size = originLumber.y / SCALE_TEXT
			, offset = originLumber.y / SCALE_TEXT / 10
			, rotate = [90, 0, 0]
			, preview = !true
			, translate = [originLumber.y / 2, -originLumber.y / 2, originLumber.z])
		cube([originLumber.x / 2, originLumber.y, originLumber.z]);

		translate([originLumber.x / 2, 0, originLumber.y])
		rotate([0, -90, 0])
		carve(str("2", ".  ", parent_module(1), originLumber.x / 2, " x ", originLumber.y, " x ", originLumber.z)
			, size = originLumber.y / SCALE_TEXT
			, offset = originLumber.y / SCALE_TEXT / 10
			, rotate = [90, 0, 0]
			, preview = !true
			, translate = [originLumber.y / 2, -originLumber.y / 2, originLumber.z])
		cube([originLumber.x / 2, originLumber.y, originLumber.z]);

		translate([originLumber.x / 2, originLumber.x / 2 + originLumber.y, originLumber.y])
		rotate([0, -90, 0])
		carve(str("4", ".  ", parent_module(1), originLumber.x / 2, " x ", originLumber.y, " x ", originLumber.z)
			, size = originLumber.y / SCALE_TEXT
			, offset = originLumber.y / SCALE_TEXT / 10
			, rotate = [90, 0, 0]
			, preview = !true
			, translate = [originLumber.y / 2, -originLumber.y / 2, originLumber.z])
		cube([originLumber.x / 2, originLumber.y, originLumber.z]);
	}
}

//	위/아래 구조물
module blackout0201(map) {
	SCALE_TEXT = 5;
	originLumber = get(map, "원본.각목", DEFAULT);
	
	color("BurlyWood", 0.2)
	carve("1"
		, size = originLumber.y / SCALE_TEXT
		, offset = originLumber.y / SCALE_TEXT / 10
		, rotate = [0, 0, 0]
		, preview = !true
		, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
	cube([originLumber.x / 2, originLumber.y, originLumber.z]);
	
	color("BurlyWood", 0.2)
	translate([0, originLumber.x / 2 + originLumber.y, 0])
	carve("3", size = originLumber.y / SCALE_TEXT, offset = originLumber.y / SCALE_TEXT / 10, rotate = [0, 0, 0], preview = !true, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
	cube([originLumber.x / 2, originLumber.y, originLumber.z]);

	color("Khaki", 0.2)
	translate([originLumber.y, originLumber.y, 0])
	rotate([0, 0, 90])
	carve("2", size = originLumber.y / SCALE_TEXT, offset = originLumber.y / SCALE_TEXT / 10, rotate = [0, 0, 0], preview = !true, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
	cube([originLumber.x / 2, originLumber.y, originLumber.z]);

	color("Khaki", 0.2)
	translate([originLumber.x / 2, originLumber.y, 0])
	rotate([0, 0, 90])
	carve("4", size = originLumber.y / SCALE_TEXT, offset = originLumber.y / SCALE_TEXT / 10, rotate = [0, 0, 0], preview = !true, translate = [originLumber.y / 2, originLumber.y / 2, originLumber.z])
	cube([originLumber.x / 2, originLumber.y, originLumber.z]);
}

module blackout02(map) {
	echo(str("", parent_module(0), ".", parent_module(1), "(", map, ")"), HR);
	assert(!is_undef(map));
	originLumber = get(map, "원본.각목", DEFAULT);

	color("BurlyWood", 0.5)
	translate([-originLumber.x * 1, -(originLumber[3] + 1) * originLumber.y * 2, 0])
	blackout01(DEFAULT);	//	원본

	blackout0201(map);	//	위/아래 구조물

	translate([0, 0, originLumber.x / 2 + originLumber.y])
	blackout0201(map);	//	위/아래 구조물

	blackout0202(map);	//	세로:상하 구조물:지지대

	blackout0203(map);	//	뚜껑 구조물
}

//	모든 지시선
module blackout_note(map) {
	assert(!is_undef(map));
	
//	lineindex([0, 0], 600);
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
	} else if (command == 1) {
		blackout01(DEFAULT);	//	원본
	} else if (command == 2) {
		blackout02(DEFAULT);
	} else {
		echo("NOT SUPPORTED");
	}
    
    blackout_note(DEFAULT);
}

main(is_undef(command) ? 2 : command);
