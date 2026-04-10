// 라이브러리, 검증된 것만 이곳에
include	<knife-data.scad>
use	<./body/wall.scad>
use	<./body/basis#37.scad>

module usage() {
	sn = 1;
	echo("usage:");
	echo(str("		/usr/bin/openscad --export-format asciistl -D command=0 -D sn=", sn, " -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S')-", sn, ".stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad"));
	echo();
	echo("	-D sn=nnn	 일련번호 마킹");
	echo("	-D command=1	 위판을 출력합니다");
	echo("	-D command=2	 밑판을 출력합니다");
	echo("	-D command=3	 좀더 튼튼한 위판을 출력합니다");
	echo("	-D command=4	 좀더 튼튼한 밑판을 출력합니다");
	echo();
}

module main(command = 0) {
	echo(HR);
	echo(str("", parent_module(0), "(", command, ")"));
	usage();

	if (command == 0) {
	} else if (command == 1) {
		wall(1024, 1024, 1024);
	} else if (command == 2) {
		wall00(DEFAULT);
		basis01_type_4_right00(DEFAULT);
	} else if (command == 3) {
		wall00(DEFAULT);
		basis01_type_4_assemble0(DEFAULT);
		foot0(DEFAULT);
	} else if (command == 4) {
		wall00(DEFAULT);
		foot0(DEFAULT);
	} else {
		echo("NOT SUPPORTED");
	}

	echo(HR);
}

main(is_undef(command) ? 4 : command);
