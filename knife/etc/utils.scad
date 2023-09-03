// deprecated, use $HOME%/common/utils.scad
use <MCAD/boxes.scad>

BIG = [1024, 1024, 1024];
EPSILON = 0.01;

module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly);
}
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

