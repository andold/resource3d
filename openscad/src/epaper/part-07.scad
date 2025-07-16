include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-06.scad>

//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
//	연결 부속을 테스트해 보자, 수직 최대각도는 45도.
ID = "⑦";
COLOR = [0.8, 0.4, 0.3, 1];

module epaper_part_07(pv) {
	v = is_undef(pv) ? [0.4, 1.6, 4, 0.4, 0.4] : pv;

	fontSize = min(v) / 4;
	points = [
		[0,		0],
		[v[0],	0],
		[v[0], v[1]],
		[v[0] - v[4], v[1] + v[3]],
		[-v[4], v[1] + v[3]],

		[0 ,	v[1]],
	];

	translate([0, v[2], 0])
	rotate([90, 0, 0])
	{
		color(COLOR)
		linear_extrude(height = v[2])
		polygon(points = points);

		//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
		translate([0, 0, v[2]])
		notate([v[0], fontSize], prefix = "Ⓞ");
		translate([v[0], 0, v[2]])
		notate([fontSize, v[1]], prefix = "①");
		translate([-fontSize / 2, v[1], v[2]])
		notate([fontSize, v[3]], prefix = "③");
		translate([-v[4], v[1] - fontSize / 2, v[2]])
		notate([v[4], fontSize], prefix = "④");

		for (cx = [1:len(points)]) {
			w = points[cx - 1];
			echo(w);
			*translate([w.x - fontSize / 2, w.y - fontSize / 2, v[2]])
			linear_extrude(height = EPSILON)
			text(str(cx - 1), size = fontSize);
		}
	}
	translate([-fontSize * 3 / 2, 0, 0])
	notate([fontSize, v[2]], prefix = "②");
}

//	쌍으로 만들기
module epaper_part_07a(v) {
	epaper_part_07(v);
	
	translate([v[0] * 2 + v[4] * 2, 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);
	
	//	밑판
	size = [6, 6, 3];	//	dx, dy, z
	translate([-size.x, -size.y, -size.z])
	cube([(v[0] + v[4] + size.x) * 2, v[2] + size.y * 2, size.z]);
}
module printPrototype() {
	for (cx = [1:3]) {
		translate([0, 4 * (cx - 1), 0])
		epaper_part_07a([0.4 * cx, 1.6, 0.8, 0.4, 0.4]);
	}
}

module main() {
	epaper_part_07();
	//printPrototype();
}

main();
