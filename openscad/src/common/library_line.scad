// 라이브러리, 검증된 것만 이곳에
include	<constants.scad>

THICK_LINE_INDEX = 0.1;
//	수평선
module lineh(point, length) {
	assert(!is_undef(point));
	assert(!is_undef(point.x));
	assert(!is_undef(point.y));
	thick = THICK_LINE_INDEX;
	
	polygon([
		[point.x, point.y],
		[point.x + length, point.y],
		[point.x + length, point.y + thick],
		[point.x, point.y + thick]
	]);
}
//	수직선
module linev(point, length) {
	thick = THICK_LINE_INDEX;
	
	polygon([
		[point.x, point.y],
		[point.x, point.y + length],
		[point.x + thick, point.y + length],
		[point.x + thick, point.y]
	]);
}

//	직사각형(외경)의 지시선, 대칭, 축선에는 그리지 않는다.
module lineindex13(point, size, xsymmetry, ysymmetry) {
	padding = size / 10;
	
	if (point.x == 0 && point.y == 0) {
		linev([size.x, -padding.y], size.y + padding.y * 2);
		lineh([-padding.x, size.y], size.x + padding.x * 2);
	}
	if (point.x != 0) {
		linev([point.x, -padding.y], size.y + padding.y * 2);
		if (xsymmetry) {
			linev([size.x - point.x, -padding.y], size.y + padding.y * 2);
		}
	}

	if (point.y != 0) {
		lineh([-padding.x, point.y], size.x + padding.x * 2);
		if (ysymmetry) {
			lineh([-padding.x, size.y - (point.y)], size.x + padding.x * 2);
		}
	}
}

//	직사각형(외경)의 지시선, 대칭
module lineindex(point, size, xsymmetry = true, ysymmetry = true, xysymmetry = true, dimension = "xy") {
	echo(str(parent_module(0), ".", parent_module(1), "(", point, size, xsymmetry, ysymmetry, xysymmetry, dimension, ")"));
	assert(!is_undef(point) && !is_undef(point.x) && !is_undef(xsymmetry) && !is_undef(ysymmetry) && !is_undef(xysymmetry) && !is_undef(dimension));

	angle = (dimension == "yz") ? [0, -90, 0] : (dimension == "zx") ? [90, 0, 0] : [0, 0, 0];
	move = [0, 0, 0];
	translate(move)
	rotate(angle) {
		lineindex13(point, size, xsymmetry, ysymmetry);
		if (xysymmetry) {
			lineindex13([point.y, point.x], size, ysymmetry, xsymmetry);
		}
	}
}

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
module samples() {
	line_type_1([0, 0, 0], [16, 16, 16], 1);
	lineindex([2, 3, 0], [16, 16, 0], dimension = "zx");
}
samples();