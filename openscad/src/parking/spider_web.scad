HR = "-----------------------------------------------------------------------------";

// 굴렁쇠
module circleOutter(r, t, z) {
	linear_extrude(height = z, center = false, convexity = 8, twist = 0)
	difference() {
		circle(r = r, $fn = 512);
		circle(r = r - t, $fn = 512);
	}
}

//	기둥 줄
module rib(ribs, r1, r2, thick, z, v) {
	linear_extrude(height = z, center = false, convexity = 8, twist = 0)
	for (cx = ribs) {
		rotate([0, 0, cx])
		translate([r1 - thick / 2, -thick / 2])
		square([r2 - r1, thick]);
	}
}
module line0(start, end, thick = 0.4, height = 8) {
	hull() {
		translate([start[0], start.y, 0])	cylinder(height, thick / 2, thick / 2);
		translate([end[0], end.y, 0]) cylinder(height, thick / 2, thick / 2);
	}
}
module spider_web(radius, height, thick = 0.4, density = [1.0, 1.0], minRadius = 2, chaos = 1.0) {
	echo(HR);
	echo("spider_web: ", radius, height, thick, density, minRadius, chaos);

	// 최대 외곽
	circleOutter(radius, thick, height);
	
	// 최소 내부 원
	//color("blue", 0.1)
	circleOutter(minRadius, thick, height);

	//	기둥 줄::씨줄
	countRow = floor(radius / 2 * density[0]);
	variableRow = floor(360 / countRow / 3 * chaos);
	randomRow = rands(-variableRow, variableRow, countRow);
	ribs = [for (cx = [0:countRow - 1]) 360 / countRow * cx + randomRow[cx]];
	//color("blue", 0.1)
	rib(ribs, minRadius, radius, thick, height, 360 / countRow / 5);
	
	//	날줄
	countCell = floor(radius / 4 * density[1]);
	variableCell = 0.8;
	randowRowColumn = [ for (cx = [0:countRow - 1]) rands(variableCell, -variableCell, countCell) ];
	points = [ for (cx = [0:countRow - 1])
				[ for (cy = [0:countCell - 1])	[
					cos(ribs[cx]) * ((radius - minRadius) / countCell * cy + minRadius + randowRowColumn[cx][cy]),
					sin(ribs[cx]) * ((radius - minRadius) / countCell * cy + minRadius + randowRowColumn[cx][cy])
					]
				]
			];
	for (cx = [0:countRow - 1]) {
		for (cy = [1:countCell - 1]) {
			//color("green", 0.5)
			line0(points[cx][cy], points[(cx + 1) % countRow][cy], thick, height = height);
		}
	}

	echo("spider_web: ", radius, height, thick, density, minRadius, chaos);
	echo(HR);
}

//spider_web(40, 4);