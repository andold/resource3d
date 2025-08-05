// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use	<../common/library_line.scad>

DEFAULT = [
	["desk.thick",	18.6,	"탁자의 두께, thickDesk"],

	["clip.edge",		"판넬 가장자리에 끼우는 클립, clipEdge"],
	["clip.edge.polygon",	[
		[31, 63, 2],	//	밑판
		[2, undef, 18.6 + 2.0],	//	위로
		[23, 2, -2.0],	//	위판 첫번째, 아래로 꺽이는 정도
		[8, 2, 1.5],	//	위판 두번째, 다시 위로 꺽이는 정도
		[0, 0, 0]
	],	"판넬 가장자리에 끼우는 클립의 도형 정의, polygonClipEdge"],
	["clip.edge.corner.plane.radius",	0.5,	"클립 모서리 대패 반지름, radiusCorner"],

	["cable.radius",	[2.5, 3.5, 4, 4.5],	"케이블 지름들, radiusCables"],
	["cable.holder",		"케이블 걸이 구멍, cableHolder"],
	["cable.holder.radius",		2.5,	"반지름, 케이블 걸이 구멍, radiusCableHolder"],
	["cable.holder.thick",		1,	"두께에 해당, 케이블 걸이 구멍, thickCableHolder"],
	["cable.holder.gap",		1,	"틈새, 케이블 걸이 구멍, gapCableHolder"],
	["cable.holder.radius.out",	1,	"반지름, 바깥 케이블 걸이 구멍, radiusOutCableHolder"],

	["desk.cable.holder.count",	4,	"케이블 걸이 갯수, countCableHolder"],
	["desk.cable.holder.margin",	[8, -0.5, 1],	"케이블 걸이 여백, marginCableHolder"],
	
	["desk.cable.clip",							"탁자 전선 걸이, clip"],
	["desk.cable.clip.size",	[64, 32, 3],	"탁자 전선 걸이 크기, sizeClip"],

	["desk.cable.clip.hole",					"탁자 전선 걸이의 케이블 홈, hole"],
	["desk.cable.clip.hole.radius.inner",	5,	"케이블 홈 내경, radiusInnerHole"],
	["desk.cable.clip.hole.radius.outter",	8,	"케이블 홈 외경, radiusOutterHole"],
	["desk.cable.clip.hole.height",			8,	"케이블 홈 높이, heightHole"],
	["desk.cable.clip.hole.count",			3,	"홈의 갯수, 탁자 전선 걸이의 케이블 홈, countHole"],

	""
];

//	판넬 가장자리에 끼우는 클립
module clip0(map) {
	thickDesk = get(map, "desk.thick", DEFAULT);	//	탁자의 두께, thickDesk
	polygonClipEdge = get(map, "clip.edge.polygon", DEFAULT);	//	판넬 가장자리에 끼우는 클립의 도형 정의, polygonClipEdge
	
	cube(polygonClipEdge[0]);

	translate([0, 0, polygonClipEdge[0].z])
	cube([polygonClipEdge[1].x, polygonClipEdge[0].y, polygonClipEdge[1].z]);

	degree1 = atan(polygonClipEdge[2][2] / polygonClipEdge[2][0]);
	translate([0, 0, polygonClipEdge[0].z + polygonClipEdge[1].z])
	rotate([0, -degree1, 0])
	cube([polygonClipEdge[2][0] / cos(degree1), polygonClipEdge[0].y, polygonClipEdge[2][1]]);

	degree2 = atan(polygonClipEdge[3][2] / polygonClipEdge[3][0]);
	translate([polygonClipEdge[2][0], 0, polygonClipEdge[0].z + polygonClipEdge[1].z + polygonClipEdge[2][2]])
	rotate([0, -degree2, 0])
	cube([polygonClipEdge[3][0] / cos(degree1), polygonClipEdge[0].y, polygonClipEdge[3][1]]);
	//	note
	lineindex([
		polygonClipEdge[2][0],
		0,
		0
	], [
		polygonClipEdge[1].x,
		thickDesk,
		thickDesk
	], false, false, false, dimension = "zx");
}

module clip(map) {
	radiusCorner = get(map, "clip.edge.corner.plane.radius", DEFAULT);	//	클립 모서리 대패 반지름, radiusCorner

	snumber = str("sn: ", is_undef(sn) ? floor(rands(0, 999, 1)[0]) : sn);
	carve(snumber, size = 5, offset = 0.5, rotate = [180, 0, 90], translate = [10, 20, 0], preview = !true, halign = "left", valign = "center") {
		minkowski() {
			translate([radiusCorner, radiusCorner, radiusCorner])
			clip0(map);
			
			sphere(radiusCorner);
		}
	}
}

module clipNote(map) {
	thickDesk = get(map, "desk.thick", DEFAULT);	//	탁자의 두께, thickDesk
	polygonClipEdge = get(map, "clip.edge.polygon", DEFAULT);	//	판넬 가장자리에 끼우는 클립의 도형 정의, polygonClipEdge
	radiusCorner = get(map, "clip.edge.corner.plane.radius", DEFAULT);	//	클립 모서리 대패 반지름, radiusCorner

	%translate([polygonClipEdge[1].x + radiusCorner * 2, 0, polygonClipEdge[0].z + radiusCorner * 2])
	cube([polygonClipEdge[0].x - polygonClipEdge[1][0], polygonClipEdge[0].y + radiusCorner * 2, thickDesk]);
}

//	케이블 걸치는 구멍 반쪽, 대칭이니까
module cableHolderHalf(map) {
	radiusCableHolder = get(map, "cable.holder.radius", DEFAULT);	//	반지름, 케이블 걸이 구멍, radiusCableHolder
	thickCableHolder = get(map, "cable.holder.thick", DEFAULT);	//	두께에 해당, 케이블 걸이 구멍, thickCableHolder
	gapCableHolder = get(map, "cable.holder.gap", DEFAULT);	//	틈새, 케이블 걸이 구멍, gapCableHolder
	radiusOutCableHolder = get(map, "cable.holder.radius.out", DEFAULT);	//	반지름, 바깥 케이블 걸이 구멍, radiusOutCableHolder
	
	$fn = 32;

	rotate([0, 0, -90])
	translate([-(radiusCableHolder + thickCableHolder + 1), 0, 0]) {
		mirror([0, 0, 1])
		translate([(radiusCableHolder + thickCableHolder + 1), 0, 0])
		rotate_extrude(angle=180, convexity=10)
		translate([radiusCableHolder + thickCableHolder, 0])
		circle(thickCableHolder);

		mirror([0, 1, 0])
		rotate_extrude(angle=90 + 45, convexity=10)
		translate([radiusOutCableHolder, 0])
		circle(thickCableHolder);
	}
}

//	케이블 걸치는 구멍
module cableHolder(map, degree) {
	//degree = -35;

	rotate([0, 0, degree])
	cableHolderHalf(map);

	mirror([1, 0, 0])
	rotate([0, 0, degree])
	cableHolderHalf(map);
}

//	케이블 걸치는 구멍들
module cableHolders(map) {
	countCableHolder = get(map, "desk.cable.holder.count", DEFAULT);	//	케이블 걸이 갯수, countCableHolder
	marginCableHolder = get(map, "desk.cable.holder.margin", DEFAULT);	//	케이블 걸이 여백, marginCableHolder
	radiusCableHolder = get(map, "cable.holder.radius", DEFAULT);	//	반지름, 케이블 걸이 구멍, radiusCableHolder
	thickCableHolder = get(map, "cable.holder.thick", DEFAULT);	//	두께에 해당, 케이블 걸이 구멍, thickCableHolder

	delta = (64 - (marginCableHolder.x * 2 + radiusCableHolder * 2 * countCableHolder)) / (countCableHolder - 1) + radiusCableHolder * 2;
	translate([marginCableHolder.x, marginCableHolder.y, marginCableHolder.z])
	for (cx  = [0:countCableHolder - 1]) {
		translate([radiusCableHolder + delta * cx, radiusCableHolder + thickCableHolder * 2, 0])
		cableHolder(map, -(35 + cx * 3));
	}
}

//	오버행 처리
module overhang(map) {
	thickDesk = get(map, "desk.thick", DEFAULT);	//	탁자의 두께, thickDesk
	polygonClipEdge = get(map, "clip.edge.polygon", DEFAULT);	//	판넬 가장자리에 끼우는 클립의 도형 정의, polygonClipEdge
	radiusCorner = get(map, "clip.edge.corner.plane.radius", DEFAULT);	//	클립 모서리 대패 반지름, radiusCorner

	size = [polygonClipEdge[0].x - polygonClipEdge[1].x + radiusCorner, NOZZLE, polygonClipEdge[1].z];
	starty = 0;
	endy = polygonClipEdge[0].y + radiusCorner;

	//	시작
	translate([radiusCorner * 1 + polygonClipEdge[1].x, starty, radiusCorner * 1 + polygonClipEdge[0].z])
	cube(size);

	//	끝
	translate([0, endy, 0])
	translate([radiusCorner * 1 + polygonClipEdge[1].x, starty, radiusCorner * 1 + polygonClipEdge[0].z])
	cube(size);

	//	중간
	translate([0, (starty + endy) / 2, 0])
	translate([radiusCorner * 1 + polygonClipEdge[1].x, starty, radiusCorner * 1 + polygonClipEdge[0].z])
	cube(size);
}

//	탁자 전선 걸이
module deskCableClip(map) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	COLOR = [1, 1, 0, 0.5];
	translate([8, 0, 0]) {
		color("DarkOliveGreen", 0.5)
		clip(map);

		color(COLOR)
		rotate([0, 0, 90])
		cableHolders(map);
		
		color("red", 0.5)
		overhang(map);
	}
}

module usage() {
	snumber = is_undef(sn) ? 999 : sn;

	echo("usage:");
	echo("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=999 -o /media/owl/data/resource3d/stl/20991231235959.stl /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/desk-cable-clip.scad");
	echo(str("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=", snumber, " -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-", snumber, ".stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/general/desk-cable-clip.scad"));
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
		deskCableClip(DEFAULT);
	} else if (command == 2) {
		//	탁자에 끼우는 부분
		clip(DEFAULT);
		clipNote(DEFAULT);
	} else if (command == 3) {
		//	케이블을 걸치는 부분
		cableHolder(DEFAULT, -40);
	} else if (command == 4) {
		//	케이블을 걸이 여러개
		cableHolders(DEFAULT);
	} else {
		echo("NOT SUPPORTED");
	}

	echo(HR);
}

main(is_undef(command) ? 1 : command);
