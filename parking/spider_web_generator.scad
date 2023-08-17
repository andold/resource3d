smallest_radius = 20;
strands = 6;
width = 0.8;
height = 2.5;
wedges = 8;
strand_fn = 64;
scale = 1;
twist = 0;

module star(radius, wedges, strand_fn) {
	angle = 360 / wedges;
	difference() {
		circle(radius, $fn = wedges);
		for(i = [0:wedges - 1]) {
			rotate(angle / 2 + angle * i) translate([radius, 0, 0]) 
			    scale([0.8, 1, 1]) 
				    circle(radius * sin(angle / 2), $fn = strand_fn);
		}
	}
}

module frame(width) {
    difference() {
        children();
        offset(r = -width) children();
    }
}

module spider_web(smallest_radius, strands, width, height, wedges, strand_fn) {
	for(i = [0:strands - 1]) {
		frame(width) star(smallest_radius * i, wedges, strand_fn);
	}

	angle = 360 / wedges;
	
	for(i = [0:wedges - 1]) {
		rotate(angle * i) translate([0, -width / 2, 0]) 
			square([smallest_radius * strands, width]);
	}
}

//linear_extrude(height, scale = scale, twist = twist)     spider_web(smallest_radius, strands, width, height, wedges, strand_fn);

module lines(lines, z) {
	for (cx = [1:len(lines) - 1]) {
		translate([0, 0, z / 2])
		hull() {
			translate([lines[cx - 1][0], lines[cx - 1][1], 0])	sphere(z / 2, $fn = 8);
			translate([lines[cx][0], lines[cx][1], 0])			sphere(z / 2, $fn = 8);
		}
	}
}
module generate_spider_web(x, y, z, wedges, circles) {
	margin = 0 / 2;
	lines([
		[margin,		margin],
		[x - margin,	margin],
		[x - margin,	y - margin],
		[margin,		y - margin],
		[margin,		margin]
	], z);
	radians = [for (cx = [0:wedges - 1]) 360 / wedges * cx];
	radiuses = [for (cx = [1:circles]) x / circles * cx];
	echo (radians, radiuses);
	for (cx = [0:len(radians) - 1]) {
		lines([
			[0,		0],
			[x * sin(radians[cx]) / 2,	y * cos(radians[cx]) / 2]
		], z);
	}
	for (cx = [0:len(radiuses) - 1]) {
		difference() {
			circle(radiuses[cx] / 2, $fn = 128);
			circle(radiuses[cx] / 2 - z, $fn = 128);
		}
	}
}
generate_spider_web(32, 16, 1, 23, 4);