// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>
use <library_function.scad>
use <library_text.scad>
use <library_cube.scad>

/*
	홈파기, 트리머
*/
//	외경계산결과, r: 반지름, delta: 한쪽 여유
function trimmer_type_1_height(r, delta, y, z) =
	z	+ sqrt((r + delta) * (r + delta) - (r - delta) * (r - delta))
		+ sqrt((r + delta) * (r + delta) - ((r + delta) * sin(OVERHANG_THRESHOLD)) * ((r + delta) * sin(OVERHANG_THRESHOLD)))
		+ ((r + delta) * sin(OVERHANG_THRESHOLD)) * sin(OVERHANG_THRESHOLD)
;
module trimmer_type_1(r, delta, y, z) {
	r2 = r * 2;			//	지름
	delta2 = delta * 2;	//	양쪽 여유 합
	rplus = r + delta;
	rminus = r - delta;

	// 진입로
	cube_type_1([rplus * 2, y, z], rminus * 2);
	// 정착
	translate([rplus, 0, z + sqrt(rplus * rplus - rminus * rminus)])
		rotate([-90, 0, 0])
		cylinder(y, rplus, rplus, $fn = fnRound(rplus));
	// 오버행 제거
	let (
		x = rplus * sin(OVERHANG_THRESHOLD),
		z_start = z + sqrt(rplus * rplus - rminus * rminus) + sqrt(rplus * rplus - x * x),
	
		reserved = 0
	) {
		translate([rplus - x, 0, z_start])
			cube_type_1([x * 2, y, x * sin(OVERHANG_THRESHOLD)], 0);

		note_type_1([rplus * 2, y, z_start + x * sin(OVERHANG_THRESHOLD)]);
	}
}

module samples() {
	translate([0, 0, 0])
	{
		trimmer_type_1(4, MINIMUM, 32, 4);
		translate([-8, -4, -4])	rotate([90, 0, 0])	text("trimmer_type_1(4, MINIMUM, 32, 4)", size = 1);
	}
}
samples();