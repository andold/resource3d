// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>

module line_type_1(start, end, r1, r2) {
	r22 = is_undef(r2) ? r1 : r2;
    hull() {
        translate(start) sphere(r1, $fn = FN);
        translate(end) sphere(r22, $fn = FN);
    }

	dx = end.x - start.x;
	dy = end.y - start.y;
	dz = end.z - start.z;
	rx = dy == 0 ? 0 : atan(dz / dy);
	ry = dz == 0 ? 0 : 90 + atan(dx / dz);
	rz = dx == 0 ? 0 : atan(dy / dx);
	d = sqrt(dx * dx + dy * dy + dz * dz);
	fs = max(0.5, min(d / 32, 20));
	translate([(start.x + end.x) / 2 + max(r1, r22), (start.y + end.y) / 2 + max(r1, r22), (start.z + end.z) / 2 + max(r1, r22)])
		rotate([rx, ry, rz])
		linear_extrude(EPSILON, center = true)	text(str(d, " mm"), size = fs, halign = "center", language = "kr", font = "NanumGothic");
}
