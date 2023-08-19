use <MCAD/boxes.scad>

EPSILON = 0.001;

module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly);
}

module bulge(x = 8, y = 8, z = 4) {
//	echo("bulge start: ", x, y, z);

	r1 = x / 2;
	r2 = r1 / 4 * 3;
	dx = r2 * 2 / 4 * 3;
	translate([r1, r1, 0])
		cylinder(z, r1, r2, $fn = 64);
	translate([x / 2 - dx / 2, 0, 0])
		cube([dx, dx, z]);

//	echo("bulge done: ", x, y, z);
}
//bulge();
module bulges(x = 128, y = 8, z = 4, count = 5) {
//	echo("bulges start: ", x, y, z, count);

	dx = (x - y) / (count - 1);
	for (cx = [0: dx: x]) {
		translate([cx, 0, 0])
		bulge(y, y, z);
	}

//	echo("bulges done: ", x, y, z, count);
}
//bulges();

module windows(x, y, z, dx = 4, dy = 4, countx = 2, county = 2) {
//	echo(x, y, z, dx, dy, countx, county);
	w = (x + dx) / countx;
	h = (y + dy) / county;
	for (cw = [0:w:x - dx]) {
		for (ch = [0:h:y - dy]) {
			translate([cw, ch, -1])
				roundedBoxNotCenter([w - dx, h - z, z * 4], z / 2, true);
		}
	}
}

module board(x = 160, y = 128, z = 8, female = false, marginy = 12, paddingx = 24, paddingy = 24) {
//	echo("board start: ", x, y, z, female, marginy, paddingx, paddingy);

	joint = z * 2;
	count = floor((y - marginy * 2 - joint) / (joint / 2 * 3) + 1);
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
					translate([z, marginy, z])
						intersection() {
							sphere(z);
							cube(z);
						}
					translate([z, y - marginy, z])
						intersection() {
							sphere(z);
							translate([0, -z, 0])	cube(z);
						}
					translate([x - z, marginy, z])
						intersection() {
							sphere(z);
							translate([-z, 0, 0])	cube(z);
						}
					translate([x - z, y - marginy, z])
						intersection() {
							sphere(z);
							translate([-z, -z, 0])	cube(z);
						}
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
				translate([z / 2, marginy, z])
					rotate([0, 180, -90])
					bulges(y - marginy * 2, z * 2, z / 2, count);
				translate([x - z / 2, y - marginy, z])
					rotate([0, 180, 90])
					bulges(y - marginy * 2, z * 2, z / 2, count);
			}
		}
	}

//	echo("board done: ", x, y, z, female, marginy, paddingx, paddingy);
}

module build() {
	x = 160;
	y = 128;
	z = 8;
	female = false;
	marginy = 12;
	paddingx = 24;
	paddingy = 8;
	count = 4;
	board(x, y, z, false, marginy, paddingx, paddingy);
	//translate([x + 4, 0, 0])	board(x, y, z, true, marginy, paddingx, paddingy);
	//translate([z, y - marginy, z])	rotate([90, 0, -90])	bulges(y - marginy * 2, z * 2, z / 2, count);
	//translate([z / 2, marginy, z])	rotate([0, 180, -90])	bulges(y - marginy * 2, z * 2, z / 2, count);
}

build();