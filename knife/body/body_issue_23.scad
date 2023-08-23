// 조립 추가 부품 - 모서리에서 씌우는 것 #23
use <../../common/utils.scad>

// 모서리 ㄴ자, todo: 자체 모서리 처리
module joint_type_krs(v = [8, 8, 8], inner = 4, outter = 2) {
	// 아래판
	cube([inner + outter * 2,	v.y,				outter]);
	cube([v.x,					inner + outter * 2,	outter]);

	// 외곽 판
	cube([outter,	v.y,	v.z]);
	cube([v.x,		outter,	v.z]);

	// 내부 판
	translate([inner + outter, inner + outter, 0])	cube([outter, v.y - (inner + outter), v.z]);
	translate([inner + outter, inner + outter, 0])	cube([v.x - (inner + outter), outter, v.z]);
}

module samples() {
	joint_type_krs([16, 16, 4], 4, 2);
	note(16, 16, 4);
	translate([20, 0, 0])	joint_type_krs([16, 16, 4], 4, 2);
	translate([20, 20, 0])	joint_type_krs([16, 16, 4], 4, 2);
	translate([0, 20, 0])	joint_type_krs([16, 16, 4], 4, 2);
}
samples();