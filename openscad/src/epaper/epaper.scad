// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-11.scad>	//	연결 부속이 장착된 위판
use <part-12.scad>	//	연결 부속이 파인 밑판

DEFAULT = default();
custome = [
	["under.panel.hill.size",	[3, 3, 1.6],				"언덕의 크기, sizeUnderPanelHill"],
	["joint.size",				[1.2, 12, 2.5, 0.8, 0.8],	"연결 부속 크기 정의, sizeJoint"],
	["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
	["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],
	["under.panel.hole.ratio",	0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"],

	"andold", ""
];
	custome74 = [
		["under.panel.height",		2 + 3,						"밑판의 높이, heightUnderPanel"],
		["under.panel.hill.size",	[3 + 2, 3 + 2, 1 + 0.6],	"언덕의 크기, sizeUnderPanelHill"],
		["under.panel.hole.ratio",	0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"],

		["upper.panel.hight",		1 + 4,		"높이 of 디스플레이 패널을 덮는 위판, hightUpperPanel"],

		["display.panel.margin",	[0.5 + 0.5, 0.5 + 0.5, 0.5 + 0.5],	"여백, 밑판과 화면 부품 사이의 여유 공간, marginDisplayPanel"],
		["joint.size",				[1.2, 12, 2.5, 0.8, 0.8],	"연결 부속 크기 정의, sizeJoint"],
		["joint.margin",			[3, 16, 0],	"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],
		["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],

		"andold", ""
	];

module epaper_display() {
}

//	/usr/bin/openscad --export-format asciistl -D command=0 -D sn=999 -o /media/owl/data/resource3d/stl/20991231235959.stl /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad
module usage() {
	echo("usage:");
	echo("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=999 -o /media/owl/data/resource3d/stl/20991231235959.stl /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad");
	echo(str("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=", sn, " -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-", sn, ".stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad"));
	echo();
	echo("	-D sn=nnn	 일련번호 마킹");
	echo("	-D command=1	 위판을 출력합니다");
	echo("	-D command=2	 밑판을 출력합니다");
	echo("	-D command=3	 좀더 튼튼한 위판을 출력합니다");
	echo("	-D command=4	 좀더 튼튼한 밑판을 출력합니다");
	echo();
	echo("	평범한");
	for (cx = custome)	echo(cx);
	echo();
	echo("	좀더 튼튼한");
	for (cx = custome74)	echo(cx);
}

module main(command = 0) {
	hr();
	echo(str("", parent_module(0), "(", command, ")"));
	usage();

	if (command == 0) {
	} else if (command == 1) {
		epaper_part11(custome);
	} else if (command == 2) {
		epaper_part12(custome);
		epaper_part04_note(custome);
	} else if (command == 3) {
		epaper_part11(custome74);
	} else if (command == 4) {
		epaper_part12(custome74);
		epaper_part04_note(custome74);
	} else {
		echo("NOT SUPPORTED");
	}

	hr();
}

main(is_undef(command) ? 0 : command);
