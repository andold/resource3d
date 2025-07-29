include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>

COLOR = [0.824, 0.412, 0.118, 0.9];
DEFAULT = [
	for (cx = default()) cx
];
 
module usage() {
	echo("usage: Raspberry Pi 4B 거치대 받침대");
	echo("/usr/bin/openscad --export-format asciistl -D sn=10 -o \"/media/owl/data/resource3d/stl/$(date +'%Y%m%d%H%M%S').stl\" /media/owl/src/eclipse-workspace/resource3d/openscad/src/epaper/epaper.scad");
	echo("	-D sn=nnn		 일련번호 마킹");
	echo("	-D command=nnn	 작업 번호");
}


module main(command = 0) {
	hr();
	echo(str("", parent_module(0), "(", "command = ", command, ")"));
	hr();

	map = [
		"andold", ""
	];
	
	if (command == 0) {
		//	usage only
	} else if (command == 1) {
	} else if (command == 2) {
	} else if (command == 3) {
	} else if (command == 4) {
	} else {
		echo("NOT SUPPORTED");
	}

	hr();
	echo("usage: ");
	hr();
}

main(is_undef(command) ? 2 : command);
