// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
include	<../common/library_text.scad>

DIGIT = "①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳";
UPPER = "ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ";
LOWER = "ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ";

module texture1b(title, position, fontsize, finalFontSize) {
	linear_extrude(height = fontsize, center = false, scale = finalFontSize, $fn = 4) {
		translate(position)
		text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
	}
}
module texture1c(fontsize) {
	for (cx = [0:fontsize]) {
		translate([fontsize * (cx + 1), 0, 0])
		projection(cut = true)
		translate([0, 0, -cx])
		children();
	}
}
module texture1d(title, position, fontsize, finalFontSize) {
	texture1b(title, position, fontsize, finalFontSize);

	for (cx = [0:fontsize]) {
		translate([fontsize * (cx + 1), 0, 0])
		projection(cut = true)
		translate([0, 0, -cx])
		texture1b(title, position, fontsize, finalFontSize);
	}
}
module texture1a(title, position, fontsize, finalFontSize) {
	texture1b(title, position, fontsize, finalFontSize);

	texture1c(fontsize) {
		texture1b(title, [0, 0], fontsize, 1);
		texture1b(title, position, fontsize, finalFontSize);
	}
}
module texture1(fontsize = 10) {
	texture1a("ⓛ", [0, 0], fontsize, 0.01);
}

module texture2c(title, fontsize, height, distance) {
	linear_extrude(height = height, center = false, scale = 1) {
		text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
	}
}

module texture2b(title, fontsize, height, distance) {
	translate([distance, 0, 0])	texture2c(title, fontsize, height, distance);
	translate([-distance, 0, 0])	texture2c(title, fontsize, height, distance);
	translate([0, distance, 0])	texture2c(title, fontsize, height, distance);
	translate([0, -distance, 0])	texture2c(title, fontsize, height, distance);
}

module texture2a(title, fontsize) {
	sliceHight = $preview ? 0.4 : 0.1;
	intersection() {
		translate([0, 0, -fontsize / 2])
			cube([fontsize, fontsize, fontsize], true);
		union() {
			translate([0, 0, -fontsize])
			linear_extrude(height = fontsize, center = false, scale = 1) {
				text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
			}
			for (cx = [0:fontsize / sliceHight]) {
				translate([0, 0, -(cx + 1) * sliceHight])
				texture2b(title, fontsize, sliceHight, cx * sliceHight);
			}
		}
	}
}
module texture2(fontsize = 4) {
	texture2a("ⓛ", fontsize);

	for (cx = [0:fontsize]) {
		translate([fontsize * (cx + 1) * 3/2, 0, 0])
		projection(cut = true)
		translate([0, 0, cx])
		texture2a("ⓛ", fontsize);
	}
}

module texture3b(title, fontsize, delta) {
	difference() {
		offset(delta = delta)
		text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
	
		text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
	}
}

module texture3c(title, fontsize, delta) {
	translate([0, 0, -delta])
	linear_extrude(height = delta, center = false, scale = 1)
	offset(delta = delta)	
	text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
}
module texture3d(title, fontsize, delta) {
	slice = 0.1;

	for (cx = [0:delta / slice - 1]) {
		mm = cx * slice;
		echo("...", cx, mm);

		translate([0, 0, -slice - mm])
		linear_extrude(height = slice, center = false, scale = 1)
		offset(delta = mm)
		text(title, size = fontsize, valign = "center", halign = "center", font = "D2Coding");
	}
}

module texture3a(title, fontsize = 15, delta = 1) {
	assert(fontsize > 10);
	
	ftile = str(title, " ", fontsize, " ", delta);
	
	difference() {
		texture3c(ftile, fontsize, delta);
		translate([0, 0, EPSILON])
		texture3d(ftile, fontsize, delta);
	}
}

module texture3() {
	difference() {
		translate([0, 0, -6 / 2])
		cube([200, 40, 6], center = true);

		translate([0, 0, EPSILON])
		texture3a("⑳ andold ⓐ", 15, 4);
	}
}

module texture4b(mm) {
	slice = 0.1;

	difference() {
		translate([0, 0, -mm])
		linear_extrude(height = mm, center = false, scale = 1)
		offset(delta = mm)
		children([0:$children-1]);

		translate([0, 0, -slice - mm])
		linear_extrude(height = slice + EPSILON, center = false, scale = 1)
		children([0:$children-1]);
	}
}

module texture4a(thick) {
	slice = 0.1;
	difference() {
		children(0);
		for (cx = [0:(thick / slice) - 1]) {
			//	현재 처리해야할 위치 및 간격을 길이(mm) 단위로 환원
			mm = cx * slice;
			//	첫번째 위치, 즉 맨 위쪽의 표면에 해당하는 것은 좀더 깍아야 openscad의 프리뷰에 도움이 된다.
			extrudeHeight = (cx == 0) ? slice + EPSILON : slice;

			translate([0, 0, -slice - mm]) {
				difference() {
					linear_extrude(height = extrudeHeight, center = false, scale = 1)
					offset(delta = thick * 2 - mm)
					children([1:$children-1]);

					linear_extrude(height = extrudeHeight, center = false, scale = 1)
					offset(delta = mm)
					children([1:$children-1]);
				}
			}
		}
	}

	translate([0, 0, -thick]) {
		linear_extrude(height = thick, center = false, scale = 1)
		children([1:$children-1]);
	}
}

module brand(angles = [90, 0, 0], position = [0, 0, 0], depth = 1, restore = true) {
	rotate(restore ? angles * -1 : [0, 0, 0])
	carve([0, 0, 0], position, depth, restore) {
		rotate(angles)
		children(0);

		children([1:$children-1]);
	}
}

module texture4() {
//	texture3a("⑳ andold ⓐ", 15, 4);
//	title = "⑳_andold_ⓐ";
	title = "abc 1234";
	fontsize = 10;
	depth = 1;
	margin = fontsize / 3;
	
	sn = is_undef(sn) ? floor(rands(100, 999, 1)[0]) : sn;
	
	for (cx = title) assert(ord(cx) < 256);

	base = [len(title) * fontsize + margin * 2, fontsize * 2, depth + margin];
	color("DarkGreen", 0.7)
	carve([-90, 0, 0], [margin, (depth + margin) * 0.3, 0], (depth + margin) * 0.5 / 5, true) {
		carve([0, 0, 0], [margin, margin, base.z], depth) {
			cube(base);
			
			text(title, size = fontsize, valign = "bottom", halign = "left", font = "D2Coding");
		}

		text(str("sn: ", sn), size = (depth + margin) * 0.5, valign = "bottom", halign = "left", font = "D2Coding");
	}
}

module texture5() {
	title = "abc 1234";
	fontsize = 10;
	depth = 1;
	margin = fontsize / 3;
	
	sn = is_undef(sn) ? floor(rands(100, 999, 1)[0]) : sn;
	
	for (cx = title) assert(ord(cx) < 256);

	base = [len(title) * fontsize + margin * 2, fontsize * 2, depth + margin];
	color("DarkGreen", 0.7)
	carve([0, 0, 0], [margin, margin, base.z], depth, false) {
		cube(base);
		
		text(title, size = fontsize, valign = "bottom", halign = "left", font = "D2Coding");
	}
}

module build(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		texture1();
	} else if (command == 1) {
		texture2();
	} else if (command == 2) {
		texture3();
	} else if (command == 3) {
		texture4();
	} else if (command == 4) {
		texture5();
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 3 : command);
