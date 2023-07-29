use <MCAD/boxes.scad>
$fa=1;
$fs=0.4;
height = 24;

echo(version=version());


// 칼

// 거푸집	size[길이, 너비, 두께] base[평면, 높이, 두께]
function moldInner(hilt, margin) = [
	hilt[2] + margin * 2,
	hilt[1] + margin * 2,
	hilt[0] + margin * 2
];
module mold(hilt, radius, margin, base, color) {
	object = [hilt[2], hilt[1], hilt[0]];
	cut = radius > base[2] ? radius : base[2];
	outter = object + [(margin + base[2]) * 2, (margin + base[2]) * 2, -object[2] + (base[1] + margin + base[2]) * 2];
	inner = outter - [base[2] * 2, base[2] * 2, base[2] * 2];
	cutter = outter + [4, 4, 0];

	color(color) difference() {
				roundedBox(size=outter, radius=radius, sidesonly=false);
				roundedBox(size=inner, radius=radius, sidesonly=false);
				translate([0, 0, cutter[2] / 2]) cube(cutter, center = true);
	}
	
	//  상판
	color(color) difference() {
		translate([0, 0, -base[2]]) cube([outter[0] + margin * 2, outter[1] + margin * 2, base[2] * 2], center = true);
		roundedBox(size=inner, radius=radius, sidesonly=false);
	}
}

// 손잡이	[길이, 너비, 두께]
module hilt(size, radius, margin, color) {
	object = [size[2], size[1], size[0]];

	color(c=color) roundedBox(size=object,radius=margin,sidesonly=false);
}

// 칼날  [길이, 너비, 두께]
module blade(size, color) {
	object = [size[2], size[1], size[0]];

    color(c=color) cube(object, center = true);
}

// chefs knife, 손잡이[길이, 너비, 두께] 칼날[길이, 너비, 두께]
module chef(hilt, blade) {
    translate([0, 0 , hilt[0] / 2]) hilt(hilt, 2, 1, [0.5, 0.5, 0, 0.5]);
	translate([0, (blade[1] - hilt[1]) / 2 , -blade[0] / 2]) blade(blade, [0.8, 0.8, 0.9, 0.5]);
}

// 빵칼 bread knife 손잡이[길이, 너비, 두께] 칼날[길이, 너비, 두께]
module bread(hilt, blade) {
    translate([0, 0 , hilt[0] / 2]) hilt(hilt, 2, 2, [0.5, 0, 0, 0.5]);
	translate([0, 0, -blade[0] / 2]) blade(blade, [0.8, 0.9, 0.8, 0.5]);
}

module scissor(
    z1, y1, x1, //  길이, 너비, 두께
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
module rsquare(x, y, m) {
	square([x - m * 2, y], center = true);
	square([x, y - m * 2], center = true);
	translate([x / 2 - m, y / 2 - m]) circle(m);
	translate([x / 2 - m, - y / 2 + m]) circle(m);
	translate([-x / 2 + m, y / 2 - m]) circle(m);
	translate([-x / 2 + m, -y / 2 + m]) circle(m);
}
module test(
   z1, y1, x1, //  길이, 너비, 너비 중앙, 두께
	y2, x2, z3  //  중앙 튀어 나온곳 높이 너비
) {
	linear_extrude(height = 50, center = true, convexity = 10) difference() {
		rsquare(x1, y1, 2);
		rsquare(x1 - 1, y1 - 1, 2);
	}
	difference() {
		square([x1 + 16, y1 + 16], center = true);
		rsquare(x1, y1, 2);
	}
}


module chefs(start, margin) {
    translate([start, 0, 0])   chef([140, 37, 20], [235, 46, 4]);
    translate([start + 20 + margin, 0, 0])   chef([140, 37, 20], [205, 52, 2]);
    translate([start + 20 + margin + (20 - 16) / 2, 52 + margin, 0])   chef([120, 30, 16], [162, 42, 2]);
	// 여유
    translate([start, 52 + margin, 0])   chef([140, 37, 20], [235, 46, 4]);
}
module breads(start, margin) {
    translate([start, 0, 0])   chef([112, 25, 20], [115, 27, 2]);
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
opacity = 1;
colorScissor = [0.2, 0.3, 0.4, opacity];
// 가위 거푸집 body[길이, 너비, 두께] center[거리, 두께]
module moldScissor(body, center, margin, thick, color) {
	outter = [center[1] + (margin + thick) * 2, center[0] + (margin + thick) * 2, height];
	inner = outter - [margin * 2, margin * 2, -margin];
	color(color) {
		difference() {
			resize(outter) cylinder(h = outter[2], r1 = outter[1], r2 = outter[1], center = true);
			resize(inner) cylinder(h = inner[2], r1 = inner[1], r2 = inner[1], center = true);
		}
	}
}
module moldScissorInner(body, center, margin, thick, color) {
	outter = [center[1] + (margin + thick) * 2, center[0] + (margin + thick) * 2, height];
	inner = outter - [margin * 2, margin * 2, -margin];
	resize(inner) cylinder(h = inner[2], r1 = inner[1], r2 = inner[1], center = true);
}
prototype();

