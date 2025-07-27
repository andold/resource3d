// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
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

module epaper_display() {
}

module usage() {
	echo("usage:");
	echo("/usr/bin/openscad --export-format asciistl -D sn=10 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S').stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad");
	echo("	-D sn=nnn		 일련번호 마킹");
	echo("	-D command=1	 위판 프린트");
	//	/usr/bin/openscad --export-format asciistl -D command=1 -D sn=10 -o "/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-010.stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad
	echo("						/usr/bin/openscad --export-format asciistl -D command=1 -D sn=10 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-010.stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad");
	echo("	-D command=2	 밑판 프린트");
	//	/usr/bin/openscad --export-format asciistl -D command=2 -D sn=11 -o "/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-011.stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad
	echo("						/usr/bin/openscad --export-format asciistl -D command=2 -D sn=11 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-011.stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad");
	echo("	-D command=3	 프리뷰용. 위판 밑판이 결합한 형태로 프린트");
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
		epaper_part12(custome);

		hightUpperPanel = get(custome, "upper.panel.hight", DEFAULT);
		sizeOutterUnderPanel = calculateSizeOutterUnderPanel(custome, DEFAULT);

		translate([sizeOutterUnderPanel.x * 1, 0, sizeOutterUnderPanel.z + hightUpperPanel])
		rotate([0, 180, 0])
		epaper_part11(custome);
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}

	usage();
	hr();
}

main(is_undef(command) ? 0 : command);
