// 벽
module wall(hilt, blade) {
	assume = [512, 2];
	data = [180, 14, 20, 70];
	colors = [[0.5, 0.5, 0, 0.1],
		[0, 0, 0, 0.8],
		[1, 0, 0, 1]
	];

	// 벽
	color(colors[0]) {
		cube([assume[1], assume[0], assume[0]], center = true);
		translate([assume[0] / 2, 0, 0]) cube([assume[0], assume[0], assume[1]], center = true);
	}
	
	color(colors[1]) translate([(data[0] - data[1]) / 2, 0, data[3] / 2]) cube([data[0] - data[1], assume[0], data[3]], center = true);
	color(colors[1]) translate([data[0] / 2, 0, data[3] - data[2] / 2]) cube([data[0], assume[0], data[2]], center = true);
}

wall();