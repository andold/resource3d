// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use	<../common/library_line.scad>

DEFAULT = [
	["base.tolerance",				[0.4, 0.8, 0.05],	"유격 최소 최대 toleranceBase"],
	
	["male.handle.size",			[24, 20, 8],	"사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle"],
	["male.rectangle.padding",		[4, 4, 8],		"사각형 모형 손잡이 paddingMaleRectangle"],
	["male.cylender.size",			[8, 8, 8],		"원기둥 모형 크기 sizeMaleCylender"],
	["male.cylender.size.range",	[0, 2, 0.5],	"원기둥 모형 크기의 최소 최대 sizeRangeMaleCylender"],

	"andold", ""
];
function default() = DEFAULT;

//	library 대체
//	직사각형(외경)의 지시선, 대칭
module lineindex(point, size, symmetry = [], dimension = ["xy"]) {
	assert(!is_undef(point) && !is_undef(symmetry) && !is_undef(dimension));

	for (cx = dimension) {
		if (cx == "xy") {
			lineindex0(point, size, symmetry);
		} else if (cx == "yz") {
			rotate([90, 0, 90])
			lineindex0([point.y, point.z], [size.y, size.z], []);
		} else if (cx == "zx") {
			rotate([0, -90, -90])
			lineindex0([point.z, point.x], [size.z, size.x], []);
		} else {
			echo("NOT SUPPORTED", cx);
		}
	}
}
module lineindex0(point, size, symmetry) {
	echo(point = point, size = size, symmetry = symmetry);
	lineindex1(point, size);
	for (cx = symmetry) {
		if (cx == "x") {
			lineindex1([size.x - point.x, point.y], size);
		} else if (cx == "y") {
			lineindex1([point.x, size.y - point.y], size);
		} else if (cx == "xy") {
			lineindex1([point.y, point.x], size);
		} else if (cx == "xyx") {
			lineindex1([size.x - point.y, point.x], size);
		} else if (cx == "xyy") {
			lineindex1([point.y, size.y - point.x], size);
		} else {
			echo("NOT SUPPORTED", cx);
		}
	}
}
module lineindex1(point, size) {
	echo(point = point, size = size);
	if (point.x != 0) {
		translate([point.x, -size.y / 10, 0])
		rotate([0, 0, 90])
		lineindex2(size.y * 12 / 10);
	}
	if (point.y != 0) {
		translate([-size.x / 10, point.y, 0])
		lineindex2(size.x * 12 / 10);
	}
}
module lineindex2(length) {
//	echo(length = length);
	polygon([
		[0, 0],
		[length, 0],
		[length, 0.1],
		[0, 0.1]
	]);
}

//	손잡이 - 원기둥 모양
module diagnose_joint0b(map, note = false) {
	sizeHandle = get(map, "male.handle.size", DEFAULT);	//	사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle

	translate([sizeHandle.x / 2, sizeHandle.x / 2, 0])
	cylinder(sizeHandle.z, sizeHandle.x / 2, sizeHandle.y / 2);
}

//	원기둥 모양
module diagnose_joint2(map, note = false) {
	sizeHandle = get(map, "male.handle.size", DEFAULT);	//	사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle
	sizeMaleCylender = get(map, "male.cylender.size", DEFAULT);	//	원기둥 모형 크기 sizeMaleCylender

	//	결합부분
	description = str(parent_module(0), "\nmale.cylender\nsize: ", sizeMaleCylender);
	translate([sizeHandle.x / 2, sizeHandle.x / 2, sizeHandle.z])
	note(description, size = 0.4, rotate = [0, 0, 0], translate = [0, 0, sizeMaleCylender.z], offset = 0.1, halign = "center", valign = "center", preview = false) {
		cylinder(sizeMaleCylender.z, sizeMaleCylender.x / 2, sizeMaleCylender.y / 2);
	}

	//	손잡이
	diagnose_joint0b(map);
}

//	원기둥 모양 주물
module diagnose_joint3(map, note = false, size = [24, 24, 24]) {
	toleranceBase = get(map, "base.tolerance", DEFAULT);	//	유격 최소 최대 toleranceBase
	sizeHandle = get(map, "male.handle.size", DEFAULT);	//	사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle
	sizeMaleCylender = get(map, "male.cylender.size", DEFAULT);	//	원기둥 모형 크기 sizeMaleCylender
 
	count = (toleranceBase[1] - toleranceBase[0] + toleranceBase[2]) / toleranceBase[2];

	mirror([0, 0, 1])
	difference() {
		cube([size.x * count, size.y, size.z]);

		translate([0, 0, -(sizeHandle.z + EPSILON)])
		for (cx = [toleranceBase[0]:toleranceBase[2]:toleranceBase[1]]) {
			index = (cx - toleranceBase[0]) / toleranceBase[2];
			translate([index * size.x, 0, 0])
			translate([-sizeHandle.x / 2 + size.x / 2, -sizeHandle.x / 2 + size.y / 2, 0])
			diagnose_joint2([
				["male.handle.size", sizeHandle],
				["male.cylender.size", [sizeMaleCylender.x + cx, sizeMaleCylender.y + cx, sizeMaleCylender.z]],
			], false);
		}
	}
}

//	사다리꼴 원기둥 모양
module diagnose_joint4(map, note = false) {
//	toleranceBase = get(map, "base.tolerance", DEFAULT);	//	유격 최소 최대 toleranceBase
	sizeHandle = get(map, "male.handle.size", DEFAULT);	//	사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle
	sizeRangeMaleCylender = get(map, "male.cylender.size.range", DEFAULT);	//	원기둥 모형 크기의 최소 최대 sizeRangeMaleCylender
	sizeMaleCylender = get(map, "male.cylender.size", DEFAULT);	//	원기둥 모형 크기 sizeMaleCylender
	paddingMaleRectangle = get(map, "male.rectangle.padding", DEFAULT);	//	사각형 모형 손잡이 paddingMaleRectangle

	for (cx = [sizeRangeMaleCylender[0]:sizeRangeMaleCylender[2]:sizeRangeMaleCylender[1]]) {
		title = str(sizeMaleCylender.x + cx, " x ", sizeMaleCylender.y);
		size = sizeHandle.x / 8;
		translate([
			(cx - sizeRangeMaleCylender[0]) / sizeRangeMaleCylender[2] * (sizeHandle.x + paddingMaleRectangle.x),
			0,
			0
		])
		carve(title, size = size, rotate = [180, 0, 0], translate = [sizeHandle.x / 2, -sizeHandle.x / 2, 0], offset = size / 10, halign = "center", valign = "center", preview = false) {
			diagnose_joint2([
				["male.handle.size", sizeHandle],
				["male.cylender.size", [sizeMaleCylender.x + cx, sizeMaleCylender.y, sizeMaleCylender.z]],
			], false);
		}
	}
}

//	사다리꼴 원기둥 모양 주물
module diagnose_joint5(map, note = false) {
	sizeHandle = get(map, "male.handle.size", DEFAULT);	//	사각형/모형 손잡이 크기 sizeMaleHandle sizeHandle
	sizeRangeMaleCylender = get(map, "male.cylender.size.range", DEFAULT);	//	원기둥 모형 크기의 최소 최대 sizeRangeMaleCylender
	sizeMaleCylender = get(map, "male.cylender.size", DEFAULT);	//	원기둥 모형 크기 sizeMaleCylender

	//	1개의 영역
	maxCylenderRadius = max(sizeMaleCylender.x, sizeMaleCylender.y) + sizeRangeMaleCylender[1];
	padding = [
		maxCylenderRadius * 2,
		maxCylenderRadius * 2,
		sizeMaleCylender.z + sizeHandle.z
	];

	for (cx = [sizeRangeMaleCylender[0]:sizeRangeMaleCylender[2]:sizeRangeMaleCylender[1]]) {
		index = (cx - sizeRangeMaleCylender[0]) / sizeRangeMaleCylender[2];
		translate([0, index * padding.y, 0])
		diagnose_joint3([
			["male.handle.size", sizeHandle],
			["male.cylender.size", [sizeMaleCylender.x + cx, sizeMaleCylender.y, sizeMaleCylender.z]],
			for (cx = map) cx
		], false, padding);
	}
}

module usage(command) {
	echo("usage:");
	echo("	/usr/bin/openscad -D command=0 /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/diagnose-joint.scad");
	echo("	~/apps/bin/makestl.sh /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/diagnose-joint.scad sn command");
	echo("	-D sn=nnn	일련번호 마킹");
	echo("	-D command=1	프린트");
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));
	usage(command);

	if (command == 0) {
		usage(command);
	} else if (command == 1) {
	} else if (command == 2) {
	} else if (command == 3) {
	} else if (command == 4) {
		diagnose_joint2(DEFAULT);	//	원기둥 모양
	} else if (command == 5) {
		diagnose_joint3(DEFAULT);	//	원기둥 모양
	} else if (command == 6) {
		diagnose_joint4(DEFAULT);	//	사다리꼴 원기둥 모양
	} else if (command == 7) {
		diagnose_joint5(DEFAULT);	//	사다리꼴 원기둥 모양
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 7 : command);
