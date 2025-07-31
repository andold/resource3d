// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>

DEFAULT_SOCKET = [
	["socket.mono.radius",	30,			"반지름, radius"],
	["socket.mono.height",	5,			"높이, height"],
	["socket.mono.corner",	1,			"모서리 깍기 반지름, corner"],

	"andold", ""
];
function default() = DEFAULT_SOCKET;

//	일련번호
module serial_number(map = default()) {
	//	반지름
	radius = get(map, "socket.mono.radius", DEFAULT_SOCKET);
	//	높이
	height = get(map, "socket.mono.height", DEFAULT_SOCKET);

	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);

	$fn = $preview ? 32 : 256;
	carve(snumber, size = radius / 6, offset = radius / 60, rotate = [0, 0, 0], translate = [radius, 0, height], preview = true, halign = "center", valign = "center") {
		mono60(map);
	}
}

//	실린더 모양, 모서리 대패
module mono60(map = default()) {
	//	반지름
	radius = get(map, "socket.mono.radius", DEFAULT_SOCKET);
	//	높이
	height = get(map, "socket.mono.height", DEFAULT_SOCKET);
	//	모서리 깍기 반지름
	corner = get(map, "socket.mono.corner", DEFAULT_SOCKET);
	
	minkowski() {
		translate([radius, 0, corner])
		cylinder(height - corner * 2, radius - corner, radius - corner);
		
		sphere(corner);
	}
}

module usage(command) {
	if (is_undef(command)) {
		echo("usage:");
		echo("/usr/bin/openscad --export-format asciistl -D command=1 -D sn=10 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S').stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad");
		echo("	-D sn=nnn		 일련번호 마킹");
		echo("	-D command=1	 프린트");
		//	/usr/bin/openscad --export-format asciistl -D command=1 -D sn=15 -o "/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-015.stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad
		echo("						/usr/bin/openscad --export-format asciistl -D command=1 -D sn=15 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-015.stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad");
	} else if (command == 0) {
		echo("이것을 합니다");
	} else if (command == 1) {
		echo("출력합니다");
	} else {
	}
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));
	usage(command);

	if (command == 0) {
	} else if (command == 1) {
		serial_number();
	} else if (command == 2) {
	} else {
		echo("NOT SUPPORTED");
	}

	usage();
}

main(is_undef(command) ? 2 : command);
