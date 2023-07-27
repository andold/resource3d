// 칼
module chef(
    x1, y1, z1, //  손잡이
    x2, y2, z2  //  칼날
) {
    color(c=[0.5, 0.5, 0, 0.5]) //  노란색 계통
        cube([x1, y1, z1]);
    color(c=[0.8, 0.8, 0.9, 0.5])
        translate([0, (y1 - y2) / 2, -z2]) {
            cube([x2, y2, z2]);
        }
}

module bread(
    x1, y1, z1, //  손잡이
    x2, y2, z2  //  칼날
) {
    color(c=[0.5, 0.0, 0, 0.5]) //  붉은색 계통
        cube([x1, y1, z1]);
    color(c=[0.8, 0.9, 0.8, 0.5])
        translate([(x1 - x2) / 2, (y1 - y2) / 2, -z2]) {
            cube([x2, y2, z2]);
        }
}

module scissor(
    x1, y1, z1, //  길이, 너비, 두께
    z2  //  중앙 튀어 나온곳 높이
) {
    color(c=[0.2, 0.2, 0.2, 0.5])   //검은색 계통통
        translate([y1 / 2, z1/2, 0])
            rotate([90, 90, 0]) {
                resize([x1, y1, z1]) {
                        cylinder(1, 1, 1, $fn = 3);
                }
            }
    color(c=[0.5, 0.5, 0.5, 0.5])
        translate([y1 / 2, z2/2, 0])
            rotate([90, 90, 0]) {
                cylinder(z2, z2, z2, $fn = 3);
            }
}
module test(
    x1, y1, z1, //  길이, 너비, 두께
    z2  //  중앙 튀어 나온곳 높이
) {
    translate([0, z1/2, 0])
        rotate([90, 90, 0]) {
            resize([x1, y1, z1]) {
                cylinder(1, 1, 1, $fn = 3);
            }
        }
    translate([0, z2/2, 0])
        rotate([90, 90, 0]) {
            cylinder(z2, z2, z2, $fn = 3);
        }
}


module chefs(start, dy) {
    translate([0, dy * 0, 0])   chef(30, 13, 130, 47, 3, 230);
    translate([0, dy * 1, 0])   chef(25, 11, 100, 40, 2, 200);
    translate([50, dy * 1, 0])   chef(25, 11, 80, 30, 2, 150);
}
module breads(start, dy) {
    translate([0, start + dy * 0, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, start + dy * 1, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, start + dy * 2, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([40, start + dy * 0, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([40, start + dy * 1, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([40, start + dy * 2, 0])   bread(25, 8, 96, 18, 1, 112);
}
module scissors(start, dy) {
    translate([0, start + dy * 0, 0])   scissor(234, 64, 8, 15);
    translate([0, start + dy * 1, 0])   scissor(234, 64, 8, 15);
}
module knifes() {
    chefs(0, 20);
    breads(40, 12);
    scissors(85, 20);
}

knifes();
//test(234, 85, 10, 20);

