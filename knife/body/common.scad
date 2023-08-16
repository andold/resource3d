EPSILON = 0.01;

module bulge(x = 8, y = 8, z = 4) {
	r = x / 2;
	dx = r * 2 / 4 * 3;
	translate([r, r, 0])
		cylinder(z, r, r, $fn = 64);
	translate([x / 2 - dx / 2, 0, 0])
		cube([dx, dx, z]);
}

module bulges(x = 128, y = 8, z = 4, count = 5) {
	dx = (x - y) / (count - 1);
	for (cx = [0: dx: x]) {
		translate([cx, 0, 0])
		bulge(y, y, z);
	}
}

module windows(x, y, z, dx = 4, dy = 4, countx = 2, county = 2) {
	echo(x, y, z, dx, dy, countx, county);
	w = (x + dx) / countx;
	h = (y + dy) / county;
	for (cw = [0:w:x - dx]) {
		for (ch = [0:h:y - dy]) {
			translate([cw, ch, -1])
				cube([w - dx, h - z, z * 4], center = false);
		}
	}
}

module board(x = 160, y = 128, z = 8, female = false, marginy = 12, paddingx = 24, paddingy = 24, count = 5) {
	echo("board", x, y, z, female, marginy, paddingx, paddingy, count);
	union() {
		difference() {
			union() {
				cube([x, y, z]);
				if (!female) {
					translate([z, y - marginy, z])
						rotate([90, 0, -90])
						bulges(y - marginy * 2, z * 2, z / 2, count);
					translate([x - z, marginy, z])
						rotate([90, 0, 90])
						bulges(y - marginy * 2, z * 2, z / 2, count);
				}
			}
			
			// 면 조립부분 홈파기
			if (female) {
				translate([-x * 4 + z / 2, -1, z / 2])
					cube(x * 4);
				translate([x - z / 2, -1, z / 2])
					cube(x * 4);
			} else {
				translate([-x * 4 + z / 2, -1, z / 2])
					cube(x * 4);
				translate([x - z / 2, -1, z / 2])
					cube(x * 4);
			}
			translate([paddingx, paddingy, 0])
				windows(x - paddingx * 2, y - paddingy * 2, z, z, z, ceil(x / 48), floor(y / 64));

			if (female) {
				translate([z / 2, y - marginy, z / 2])
					rotate([0, 0, -90])
					bulges(y - marginy * 2, z * 2, z / 2 + EPSILON, count);
				translate([x - z / 2, marginy, z / 2])
					rotate([0, 0, 90])
					bulges(y - marginy * 2, z * 2, z / 2 + EPSILON, count);
			}
		}
	}
}

module build() {
	board(20, 64, 8, false, 2, 8, 8, 2);
	translate([20 + 4, 0, 0])
		board(44, 64, 8, true, 2, 24, 8, 2);
}

build();