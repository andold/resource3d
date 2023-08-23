// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
use <utils.scad>

// 사다리꼴, xz 평면에서 보았을 때
module cube_type_1(v, x) {
	rotate([0, -90, -90])
	linear_extrude(v.y)
	polygon([
		[0,		0],
		[0,		v.x],
		[v.z,	v.x - (v.x - x) / 2],
		[v.z,	(v.x - x) / 2],
		[0,		0]
	]);
}
