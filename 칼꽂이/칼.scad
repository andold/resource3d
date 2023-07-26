// 칼
module chefs(x1, x2, y1, y2, z1, z2) {
    cube([x1, y1, z1]);
    translate([0, (y1 - y2) / 2, z1])        cube([x2, y2, z2]);
}
module knife1(x1, x2, y1, y2, z1, z2) {
    cube([x1, y1, z1]);
    translate([(x1 - x2) / 2, (y1 - y2) / 2, z1])        cube([x2, y2, z2]);
}

chefs(47, 30, 3, 13, 230, 130);
translate([100, 0, 0])  knife1(18, 25, 1, 8, 112, 96);
