// 라이브러리, 검증된 것만 이곳에
include	<knife-data.scad>
use	<knife-before.scad>

//	하단 가로 지지대 1
module under20(data) {
	title = str("하단 가로 지지대 1:: ", parent_module(0), ".", parent_module(1));
	echo(str(title, "(", data, ")"));
	assert(data, "파라미터 undefined");

	color("blue", 0.5)
	translate([sqrt(2) * data["기초.두께"], data["상판.크기"].y - sqrt(2) * data["기초.두께"], 0])
	rotate([0, 0, data["기초.각도.앞"]])
	rotate([0, 90, 0])
	{
		cube([data["상판.크기"].x, data["다리.두께"], sqrt(2) * (data["기초.중복"] - data["상판.크기"].y)]);

		%translate([data["상판.크기"].x / 2, data["다리.두께"] / 2, data["다리.두께"]])
		note(str(title), size = data["다리.두께"] / 4, valign = "center", halign = "center");
	}
}

//	하단 가로 지지대 1 다리
module under21(data) {
	under1_title = str("하단 가로 지지대 1 다리:: ", parent_module(0), ".", parent_module(1));
	echo(str(under1_title, "(", data, ")"));
	assert(data, "파라미터 undefined");

	color("red", 0.5)
//	translate([sqrt(2) * data["기초.두께"], data["상판.크기"].y - sqrt(2) * data["기초.두께"], 0])
	translate([sqrt(2) * data["기초.두께"], data["상판.크기"].y - sqrt(2) * data["기초.두께"], 0])
	rotate([0, 0, data["기초.각도.앞"]])
	rotate([-90, 90, 0])
	translate([sqrt(2) * data["기초.두께"], data["상판.크기"].y - sqrt(2) * data["기초.두께"], 0])
	{
		cube([data["상판.크기"].x, data["다리.두께"], sqrt(2) * (data["기초.중복"] - data["상판.크기"].y)]);

		%translate([data["상판.크기"].x / 2, data["다리.두께"] / 2, data["다리.두께"]])
		note(under1_title, size = data["다리.두께"] / 4, valign = "center", halign = "center");
	}
}

module main(command = 0) {
	echo(HR);
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		under20(DEFAULT);
	} else if (command == 1) {
		under21(DEFAULT);
	} else if (command == 2) {
		under20(DEFAULT);
		under21(DEFAULT);
	} else if (command == 3) {
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}

	echo(HR);
}

main(is_undef(command) ? 2 : command);
