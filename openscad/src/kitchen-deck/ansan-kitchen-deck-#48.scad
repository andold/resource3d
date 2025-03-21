use <MCAD/boxes.scad>

include	<../common/constants.scad>
use <../common/library.scad>
use <../common/library_cube.scad>

// 상수
PANE_MINUS = [18, 0, 0];
DECK = [1800, 150, 15];
BAR = [3600, 60, 45];
PANE1 = [1555, 950, 15];
PANE2 = [1360, DECK.y * 15 - PANE1.y, PANE1.z];
COLOR_EVEN = [0.5, 0.5, 1.0, 0.5];
COLOR_ODD = [0.8, 0.8, 1.0, 0.5];
COLOR_ZERO = [0.5, 0.2, 0.5, 0.8];

module onev(v) {
    cube_type_2(v, v.x);
}
module one(x, y, z) {
    echo("one", x, y, z);
    onev([x, y, z]);
}
module deck1(y) {
    translate([0, y, 0])    one(PANE1.x, DECK.y, DECK.z);
}
module deck2(y) {
    translate([0, y, 0])    one(PANE2.x, DECK.y, DECK.z);
}

module bar(x, y) {
    width = BAR.z;
    height = BAR.y;
    one(x, width, height);
    translate([0, y - width, 0])    one(x, width, height);

    translate([0, width, 0])    one(width, y - 2 * width, height);
    translate([x - width, width, 0])    one(width, y - 2 * width, height);
    translate([x / 2 - width, width, 0])    one(width, y - 2 * width, height);
}

module build(target, step) {
    v3 = [PANE1.x - PANE2.x + 1, 18, PANE1.z + 2];

    translate([0, 0, -PANE1.z]) {
        translate([0, PANE2.y, 0])        onev(PANE1);
        difference() {
            onev(PANE2);
            translate([PANE2.x - v3.x + 1, PANE2.y - v3.y, -1])       onev(v3);
        }
    }
    color(COLOR_ZERO) {
        translate([0, PANE2.y, 0]) {
            bar(PANE1.x, PANE1.y);
        }
        bar(PANE2.x, PANE2.y - PANE_MINUS.x);
    }
    translate([0, 0, BAR.y + 100]) {
        y = PANE1.y + PANE2.y - DECK.y;
        color(COLOR_EVEN)        deck1(y - DECK.y * 0);
        color(COLOR_ODD)        deck1(y - DECK.y * 1);
        color(COLOR_EVEN)        deck1(y - DECK.y * 2);
        color(COLOR_ODD)        deck1(y - DECK.y * 3);
        color(COLOR_EVEN)        deck1(y - DECK.y * 4);
        color(COLOR_ODD)        deck1(y - DECK.y * 5);
        color(COLOR_EVEN)        deck1(y - DECK.y * 6);
        color(COLOR_ODD)        deck2(y - DECK.y * 7);
        color(COLOR_EVEN)        deck2(y - DECK.y * 8);
        color(COLOR_ODD)        deck2(y - DECK.y * 9);
        color(COLOR_EVEN)        deck2(y - DECK.y * 10);
        color(COLOR_ODD)        deck2(y - DECK.y * 11);
        color(COLOR_EVEN)        deck2(y - DECK.y * 12);
        color(COLOR_ODD)        deck2(y - DECK.y * 13);
        color(COLOR_EVEN)        deck2(y - DECK.y * 14);
    }
}

target = 7;
build(target, $t);
