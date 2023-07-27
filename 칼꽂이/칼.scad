// 칼
module chef(
    x1, y1, z1, //  손잡이
    x2, y2, z2  //  칼날
) {
    cube([x1, y1, z1]);
    translate([0, (y1 - y2) / 2, -z2]) {
        cube([x2, y2, z2]);
    }
}

module bread(
    x1, y1, z1, //  손잡이
    x2, y2, z2  //  칼날
) {
    cube([x1, y1, z1]);
    translate([(x1 - x2) / 2, (y1 - y2) / 2, -z2]) {
        cube([x2, y2, z2]);
    }
}

module scissor(
    x1, y1, z1, //  길이, 너비, 두께
    z2  //  중앙 튀어 나온곳 높이
) {
    translate([0, 0, -x1 / 2]) {
        cube([y1, z1, x1]);
    }
    translate([-(z2 - y1) / 2, (z1 - z2) / 2, -x1 / 2]) {
        cube([z2, z2, x1]);
    }
}


module chefs() {
    dy = 20;
    translate([0, dy * 0, 0])   chef(20, 10, 100, 40, 2, 200);
    translate([0, dy * 1, 0])   chef(25, 11, 80, 30, 2, 150);
    translate([0, dy * 2, 0])   chef(30, 13, 130, 47, 3, 230);
}
module breads() {
    dy = 20;
    translate([0, dy * 3, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, dy * 4, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, dy * 5, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, dy * 6, 0])   bread(25, 8, 96, 18, 1, 112);
    translate([0, dy * 7, 0])   bread(25, 8, 96, 18, 1, 112);
}
module knifes() {
    chefs();
    breads();

    dy = 20;

    translate([0, dy * 8, 0])   scissor(234, 85, 10, 20);
    translate([0, dy * 8 + 25, 0])   scissor(234, 85, 10, 20);
}

knifes();
