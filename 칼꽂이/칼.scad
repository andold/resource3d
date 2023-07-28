echo(version=version());

// 칼
module hilt(
	x1, y1, z1, //  손잡이
	margin,      //  여유, 유격
	color
) {
    color(c=color) //  노란색 계통
        cube([x1, y1, z1]);
}

module chef(
    z1, y1, x1, //  손잡이
    z2, y2, x2  //  칼날
) {
    hilt(x1, y1, z1, 2, [0.5, 0.5, 0, 0.5]);
    color(c=[0.8, 0.8, 0.9, 0.5])
        translate([(x1 - x2) / 2, 0 , -z2]) {
            cube([x2, y2, z2]);
        }
}

module bread(
    z1, y1, x1, //  손잡이
    z2, y2, x2  //  칼날
) {
    color(c=[0.5, 0.0, 0, 0.5]) //  붉은색 계통
        cube([x1, y1, z1]);
    color(c=[0.8, 0.9, 0.8, 0.5])
        translate([(x1 - x2) / 2, (y1 - y2) / 2, -z2]) {
            cube([x2, y2, z2]);
        }
}

module scissor(
    z1, y1, x1, //  길이, 너비, 너비 중앙, 두께
	y2, x2  //  중앙 튀어 나온곳 높이 너비
) {
	dz = -z1 / 3 + y2 / y1 * z1;
    color(c=[0.8, 0.8, 0.8, 0.5])   //검은색 계통
        translate([0, y1 / 2, dz])
            resize([x1, y1, z1])
            rotate([90, 90, 90])
                        cylinder(1, 1, 1, $fn = 3);
    color(c=[0.5, 0.5, 0.1, 0.5])
        translate([(x1 - x2) / 2, y1 / 2, 0])
            rotate([90, 90, 90]) {
				cylinder(x2, 10, 10);
            }
}
module test(
   z1, y1, x1, //  길이, 너비, 너비 중앙, 두께
	y2, x2  //  중앙 튀어 나온곳 높이 너비
) {
	dz = -z1 / 3 + y2 / y1 * z1;
    color(c=[0.8, 0.8, 0.8, 0.5])   //검은색 계통
        translate([0, y1 / 2, dz])
            resize([x1, y1, z1])
				rotate([90, 90, 90])
                        cylinder(1, 1, 1, $fn = 3);
    color(c=[0.5, 0.5, 0.1, 0.5])
        translate([(x1 - x2) / 2, y1 / 2, 0])
            rotate([90, 90, 90]) {
				cylinder(x2, 10, 10);
            }
}


module chefs(start, margin) {
    translate([start, 0, 0])   chef(140, 37, 20, 235, 46, 4);
    translate([start + 20 + margin, 0, 0])   chef(140, 37, 20, 205, 52, 2);
    translate([start + 20 + margin + (20 - 16) / 2, 52 + margin, 0])   chef(120, 30, 16, 162, 42, 2);
	// 여유
    translate([start, 52 + margin, 0])   chef(140, 37, 20, 235, 46, 4);
}
module breads(start, margin) {
    translate([start, 0, 0])   chef(112, 25, 20, 115, 27, 2);
    translate([start + 20 + margin, 0, 0])   bread(112, 25, 15, 105, 20, 2);
	translate([start + 20 + 15 + margin * 2, 0, 0])   bread(106, 22, 13, 127, 17, 1);

    translate([start, 27 + margin, 0])   bread(112, 25, 20, 127, 20, 2);// 여유
    translate([start + 20 + margin, 27 + margin, 0])   bread(112, 25, 20, 127, 20, 2);// 여유
	translate([start + 20 + 20 + margin * 2, 27 + margin, 0])   bread(112, 25, 20, 127, 20, 2);// 여유

    translate([start, 50 + margin * 2, 0])   bread(112, 25, 15, 105, 20, 2);// 여유
    translate([start + 20 + margin, 50 + margin * 2, 0])   bread(112, 25, 15, 105, 20, 2);// 여유
	translate([start + 20 + 20 + margin * 2, 50 + margin * 2, 0])   bread(112, 25, 15, 105, 20, 2);// 여유

}
module scissors(start, margin) {
    translate([start, 0, 0])   scissor(220, 82, 12, 40, 14);
    translate([start, 40 + margin, 0])   scissor(220, 82, 12, 40, 14);
}
module knifes() {
    chefs(0, 10);
    breads(60, 10);
    scissors(150, 10);
}

knifes();
// translate([0, 0, 0]) test(220, 82, 12, 40, 14);

