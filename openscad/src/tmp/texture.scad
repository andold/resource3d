// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
include	<../common/library_text.scad>

module texture4() {
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

/*
// 문자열 일부 추출: start부터 end까지의 문자 반환
function substring(string, start, end, index = 0, result = "") =
    index >= len(string) || index > end
        ? result
        : substring(string, start, end,
            index + 1,
            str(result, (index >= start ? string[index] : ""))
        );

// 문자열 일부 추출: start부터 end까지의 문자 반환
function split(string, delemeter) = let(parts = concat(-1, search(delemeter, string, 0)[0], len(string))) [
	for (cx = [0:len(parts) - 2])
		substring(string, parts[cx] + 1, parts[cx + 1] - 1)
];

module text0(t, size = 10, font = "D2Coding", halign = "left", valign = "baseline", spacing = 1, hspacing = 1.5, direction = "ltr", language = "en", script = "latin") {

	lines = split(t, "\n");
	for (cx = [0:len(lines) - 1]) {
		translate([0, -cx * (size * hspacing)])
		text(lines[cx], size = size, font = font, halign = halign, valign = valign, spacing = spacing, direction = direction, language = language, script = script);
	}
}
module texture5a(title, fontsize) {
	lines = split(title, "\n");
	for (cx = [0:len(lines) - 1]) {
		translate([0, -cx * (fontsize / 10 * 15)])
		text(lines[cx], size = fontsize, valign = "top", halign = "left", font = "D2Coding");
	}
}
*/ 

module texture5() {
	title = "1: description\n2: 나랏말싸미 뒹귁에 달아\n3: 나랏말싸미 서르 사맛디 아니할쎄";
	carve([180, 0, 0], [1, -2, 0], 0.1, true) {
		texture4();

		text0(title, 1);
	}
}

module build(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		title = "1: description\n 2: 나랏말싸미 뒹귁에 달아\n3: 나랏말싸미 서르 사맛디 아니할쎄";
		echo(split(title, "\n"));
	} else if (command == 1) {
	} else if (command == 2) {
	} else if (command == 3) {
		texture4();
	} else if (command == 4) {
		texture5();
	} else {
		echo("NOT SUPPORTED");
	}
}

build(is_undef(command) ? 4 : command);
