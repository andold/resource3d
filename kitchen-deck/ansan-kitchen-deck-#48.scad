use <MCAD/boxes.scad>

include	<../common/constants.scad>
use <../common/library.scad>
use <../common/library_cube.scad>

// 상수
BAR = [45, 60];

module one(x, y, z) {
    cube_type_2([x, y, z], x);
}
module onev(v) {
    cube_type_2(v, v.x);
}
module deck1(y) {
    translate([0, y, 0])
    one(1550, 150, 15);
}
module deck2(y) {
    translate([0, y, 0])
    one(1360, 150, 15);
}

module bar(x, y) {
    width = BAR.x;
    height = BAR.y;
    one(x, width, height);
    translate([0, y - width, 0])    one(x, width, height);

    translate([0, width, 0])    one(width, y - 2 * width, height);
    translate([x - width, width, 0])    one(width, y - 2 * width, height);
    translate([x / 2 - width, width, 0])    one(width, y - 2 * width, height);
}

module build(target, step) {
    color1 = [0.5, 0.5, 1.0, 0.5];
    color2 = [0.8, 0.8, 1.0, 0.5];
    color3 = [0.5, 0.2, 0.5, 0.8];
    v1 = [1555, 950, 15];
    v2 = [1360, 2200 - v1.y, v1.z];
    v3 = [v1.x - v2.x + 1, 18, v1.z + 2];

    translate([0, 0, -15]) {
        translate([0, v2.y, 0])
        onev(v1);
        difference() {
            onev(v2);
            translate([v2.x - v3.x + 1, v2.y - v3.y, -1])
            onev(v3);
        }
    }
    color(color3) {
        translate([0, v2.y, 0]) {
            bar(1555, 950);
        }
        bar(1350, 1250 - 18);
    }
    translate([0, 0, BAR.y]) {
        y = 2200 - 150;
        color(color2)        deck1(y - 150 * 0);
        color(color1)        deck1(y - 150 * 1);
        color(color2)        deck1(y - 150 * 2);
        color(color1)        deck1(y - 150 * 3);
        color(color2)        deck1(y - 150 * 4);
        color(color1)        deck1(y - 150 * 5);
        color(color2)        deck1(y - 150 * 6);
        color(color1)        deck2(y - 150 * 7);
        color(color2)        deck2(y - 150 * 8);
        color(color1)        deck2(y - 150 * 9);
        color(color2)        deck2(y - 150 * 10);
        color(color1)        deck2(y - 150 * 11);
        color(color2)        deck2(y - 150 * 12);
        color(color1)        deck2(y - 150 * 13);
        color(color2)        deck2(y - 150 * 14);
    }
}

target = 7;
build(target, $t);
