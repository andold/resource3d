// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use	<../common/library_line.scad>

DEFAULT = [
	["filament.holder",		"필라멘트 걸이 고정물, holderFilament"],
	["filament.holder.corner.plane.radius",		1,	"필라멘트 걸이 모서리 대패 반지름, radiusCornerPlaneHolderFilament"],
	["filament.holder.radius",			30.03 / 2 + 1 - 1,		"필라멘트 걸이 반지름, radiusHolderFilament"],
	["filament.holder.radius.outter",	(30.03 / 2 + 1 - 1) / 4,	"필라멘트 걸이 홀더의 바깥쪽으로의 곡선 반지름, radiusOutterHolderFilament"],
	["filament.holder.thick",			3 - 2,				"필라멘트 걸이 두께, thickHolderFilament"],
	["filament.holder.width",			24 - 2,				"필라멘트 걸이 너비, widthHolderFilament"],
	["filament.holder.margin",			30,					"필라멘트 걸이 좁히는 최대 거리, marginHolderFilament"],
	["filament.holder.arrow.size",		[64 - 2, 4 - 2, 8 - 2],	"필라멘트 걸이 표시자 크기, sizeArrowHolderFilament"],

	""
];

//	필라멘트 걸이 표시자
module filamentHolderArrow(map) {
	sizeArrowHolderFilament = get(map, "filament.holder.arrow.size", DEFAULT);	//	필라멘트 걸이 표시자 크기, sizeArrowHolderFilament
	radiusCornerPlaneHolderFilament = get(map, "filament.holder.corner.plane.radius", DEFAULT);	//	필라멘트 걸이

	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);

	carve(snumber, size = sizeArrowHolderFilament.y * 3 / 5, offset = sizeArrowHolderFilament.y / 10, rotate = [0, 0, 0], translate = [sizeArrowHolderFilament.x - sizeArrowHolderFilament.y / 10 * 4, sizeArrowHolderFilament.y / 5, sizeArrowHolderFilament.z], preview = !true, halign = "right", valign = "bottom") {
		minkowski()
		{
			cube(sizeArrowHolderFilament);

			translate([0, 0, -radiusCornerPlaneHolderFilament])
			sphere(radiusCornerPlaneHolderFilament);
		}
	}
}

//	필라멘트 걸이 고정물 절반, 대칭
module filamentHolderJointHalf(map) {
	radiusHolderFilament = get(map, "filament.holder.radius", DEFAULT);	//	필라멘트 걸이 반지름, radiusHolderFilament
	radiusOutterHolderFilament = get(map, "filament.holder.radius.outter", DEFAULT);	//	필라멘트 걸이 홀더의 바깥쪽으로의 곡선 반지름, radiusOutterHolderFilament
	thickHolderFilament = get(map, "filament.holder.thick", DEFAULT);	//	필라멘트 걸이 너비, widthHolderFilament
	widthHolderFilament = get(map, "filament.holder.width", DEFAULT);	//	필라멘트 걸이 두께, thickHolderFilament
	marginHolderFilament = get(map, "filament.holder.margin", DEFAULT);	//	필라멘트 걸이 좁히는 최대 거리, marginHolderFilament

	rotate([0, 0, -90])
	translate([-(thickHolderFilament + radiusHolderFilament + radiusOutterHolderFilament), 0, 0]) {
		mirror([0, 0, 1])
		translate([(thickHolderFilament + radiusHolderFilament + radiusOutterHolderFilament), 0, -widthHolderFilament])
		rotate_extrude(angle=180, convexity=10, $fn = $preview ? 16 : 512)
		translate([radiusHolderFilament, 0])
		square([thickHolderFilament, widthHolderFilament]);

		mirror([0, 1, 0])
		rotate_extrude(angle=90, convexity=10, $fn = $preview ? 16 : 512)
		translate([radiusOutterHolderFilament, 0])
		square([thickHolderFilament, widthHolderFilament]);
	}
}

//	필라멘트 걸이 고정물
module filamentHolderJoint(map) {
	degree = -50;
	
	rotate([0, 0, degree])
	filamentHolderJointHalf(map);
	
	mirror([1, 0, 0])
	rotate([0, 0, degree])
	filamentHolderJointHalf(map);
}

//	필라멘트 걸이
module filamentHolder1(map) {
	radiusHolderFilament = get(map, "filament.holder.radius", DEFAULT);	//	필라멘트 걸이 반지름, radiusHolderFilament
	radiusCornerPlaneHolderFilament = get(map, "filament.holder.corner.plane.radius", DEFAULT);	//	필라멘트 걸이
	
	minkowski()
	{
		translate([0, radiusHolderFilament, 0]) {
			filamentHolderJoint(map);
			
		}
		
		translate([0, 0, -radiusCornerPlaneHolderFilament])
		sphere(radiusCornerPlaneHolderFilament);
	}

	sizeArrowHolderFilament = get(map, "filament.holder.arrow.size", DEFAULT);	//	필라멘트 걸이 표시자 크기

	translate([-(sizeArrowHolderFilament.y / 2), 0, 0])
	rotate([0, 0, -90])
	filamentHolderArrow(map);
}

//	필라멘트 걸이 모서리 대패 처리
module filamentHolder(map) {
	radiusHolderFilament = get(map, "filament.holder.radius", DEFAULT);	//	필라멘트 걸이 반지름, radiusHolderFilament
	radiusCornerPlaneHolderFilament = get(map, "filament.holder.corner.plane.radius", DEFAULT);	//	필라멘트 걸이 모서리 대패 반지름, radiusCornerPlaneHolderFilament

	translate([0, -radiusHolderFilament, radiusCornerPlaneHolderFilament])
	filamentHolder1(map);
}

//	오버행 처리
module overhang(map) {
}

module usage() {
	snumber = is_undef(sn) ? 999 : sn;

	echo("usage:");
	echo("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=999 -o /media/owl/data/resource3d/stl/20991231235959.stl /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/filament-holder.scad");
	echo(str("		/usr/bin/openscad --export-format asciistl -D command=1 -D sn=", snumber, " -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-", snumber, ".stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/filament-holder.scad"));
	echo();
	echo("	-D sn=nnn	 일련번호 마킹");
	echo("	-D command=1	 출력합니다");
	echo();
}

module main(command = 0) {
	echo(HR);
	echo(str("", parent_module(0), "(", command, ")"));
	usage();

	if (command == 0) {
	} else if (command == 1) {
		filamentHolder(DEFAULT);
	} else if (command == 2) {
	} else if (command == 3) {
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}

	echo(HR);
}

main(is_undef(command) ? 1 : command);
