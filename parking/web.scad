module web(x, y, z, thick, radiusMin, radiusMax, radianMin, radianMax) {
}
module line(start, end, thickness = 1) {
    hull() {
        translate(start) sphere(thickness);
        translate(end) sphere(thickness);
    }
}

line([0,0,0], [5,23,42]);
line([0,0,0], [5,-23,42]);
