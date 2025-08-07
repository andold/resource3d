// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>

DEFAULT_SOCKET = [
	["socket.mono.radius",	30,			"반지름, radius"],
	["socket.mono.height",	16,			"높이, height"],
	["socket.mono.thick",	3,			"두께, thick"],
	["socket.mono.corner",	1,			"모서리 깍기 반지름, corner"],

	["socket.mono.hole.radius",		1,				"벽체 고정 나사 구멍 반지름, radiusHole"],
	["socket.mono.hole.thick",		2,				"벽체 고정 나사 구멍 두께, thickHole"],
	["socket.mono.hole.distance",	[45.52, 53.21],	"벽체 고정 나사 구멍 거리, distanceHole"],

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

	carve(snumber, size = 5, offset = 0.5, rotate = [0, 0, 0], translate = [0, 0, height], preview = !true, halign = "center", valign = "center") {
		mono60(map);
	}
}

//	벽체 고정 나사 구멍
module mono60a(map) {
	//	벽체 고정 나사 구멍 거리, distanceHole
	distanceHole = get(map, "socket.mono.hole.distance", DEFAULT_SOCKET);
	thickHole = get(map, "socket.mono.hole.thick", DEFAULT_SOCKET);	//	벽체 고정 나사 구멍 두께, thickHole
	radiusHole = get(map, "socket.mono.hole.radius", DEFAULT_SOCKET);	//	벽체 고정 나사 구멍 반지름, radiusHole
	//	반지름
	radius = get(map, "socket.mono.radius", DEFAULT_SOCKET);
	//	높이
	height = get(map, "socket.mono.height", DEFAULT_SOCKET);
	corner = get(map, "socket.mono.corner", DEFAULT_SOCKET);	//	모서리 깍기 반지름

	distance = (distanceHole[0] + distanceHole[1]) / 2 / 2;
	echo(distance = distance, radiusHole = radiusHole);
	
	translate([distance, 0, 0])
	cylinder(height, radiusHole + thickHole, radiusHole + thickHole, $fn = $preview ? 16 : 256);

	translate([-distance, 0, 0])
	cylinder(height, radiusHole + thickHole, radiusHole + thickHole, $fn = $preview ? 16 : 256);
}

//	실린더 모양, 모서리 대패
module mono60b(map) {
	//	반지름
	radius = get(map, "socket.mono.radius", DEFAULT_SOCKET);
	//	높이
	height = get(map, "socket.mono.height", DEFAULT_SOCKET);
	thick = get(map, "socket.mono.thick", DEFAULT_SOCKET);	//	두께, thick
	corner = get(map, "socket.mono.corner", DEFAULT_SOCKET);	//	모서리 깍기 반지름

	union() {
		cylinder(corner, radius - corner, radius, $fn = $preview ? 16 : 256);

		translate([0, 0, corner])
		cylinder(thick - corner, radius, radius, $fn = $preview ? 16 : 256);

		translate([0, 0, thick])
		difference() {
			cylinder(height - thick * 2, radius, radius, $fn = $preview ? 16 : 256);

			translate([0, 0, -EPSILON])
			cylinder(height - thick * 2 + EPSILON * 2, radius - thick, radius - thick, $fn = $preview ? 16 : 256);
		}

		translate([0, 0, height - thick])
		cylinder(thick - corner, radius, radius, $fn = $preview ? 16 : 256);

		translate([0, 0, height - corner])
		cylinder(corner, radius, radius - corner, $fn = $preview ? 16 : 256);
	}
}

//	각종 선이 다닐수 있는 통로 확보용 파기
module mono60c(map) {
	translate([0, 0, -EPSILON]) {
		//	벽체 고정 나사 구멍 거리, distanceHole
		radius = get(map, "socket.mono.radius", DEFAULT_SOCKET);
		//	높이
		height = get(map, "socket.mono.height", DEFAULT_SOCKET);
		distanceHole = get(map, "socket.mono.hole.distance", DEFAULT_SOCKET);
		radiusHole = get(map, "socket.mono.hole.radius", DEFAULT_SOCKET);	//	벽체 고정 나사 구멍 반지름, radiusHole
		distance = (distanceHole[0] + distanceHole[1]) / 2 / 2;

		//	나사 구멍 1
		translate([distance, 0, 0])
		cylinder(height + EPSILON * 2, radiusHole, radiusHole / 2, $fn = $preview ? 16 : 256);

		//	나사 구멍 2
		translate([-distance, 0, 0])
		cylinder(height + EPSILON * 2, radiusHole, radiusHole / 2, $fn = $preview ? 16 : 256);
		
		//	전선 구멍 1
		translate([0, radius - 4, 0])
		scale([5, 2, 1])
		cylinder(height + EPSILON * 2, 1, 1, $fn = $preview ? 16 : 256);
	}
}

//	구멍 뚫린 실린더 모양, 모서리 대패
module mono60(map = default()) {
	difference() {
		union() {
			mono60b(map);
			mono60a(map);
		}

		mono60c(map);
	}
}

module usage(command) {
	echo("usage:");
	echo("	/usr/bin/openscad -D command=0 /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad");
	echo("	-D sn=nnn	일련번호 마킹");
	echo("	-D command=1	프린트");
	//	/usr/bin/openscad --export-format asciistl -D command=1 -D sn=18 -o "/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-18.stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad
	echo("	/usr/bin/openscad --export-format asciistl -D command=1 -D sn=18 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-18.stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/socket/mono60.scad");
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));
	usage(command);

	if (command == 0) {
	} else if (command == 1) {
		serial_number();
	} else if (command == 2) {
		mono60a(default());
	} else if (command == 3) {	//	구멍 뚫린 실린더 모양, 모서리 대패
		mono60b(default());
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 1 : command);
