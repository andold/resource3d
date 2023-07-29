use <MCAD/boxes.scad>
use <칼.scad>

// 상수
height = 24;
opacity = 1;
colorScissor = [0.2, 0.3, 0.4, opacity];

echo(version=version());

module prototype() {
	start = 0;

	gx0 = -20;
	gx1 = gx0 + 36;
	gx2 = gx1 + 32;
	
	gy0 = -28;
	gy1 = 0;
	gy2 = -gy0;
	rotate([180, 0, 0]) translate([0, 0, 0]) {
		difference() {
			union() {
				translate([gx0, gy0, 0]) mold([140, 37, 20], 2, 2, [37 + 8, height, 1], [0.0, 0.5, 0.0, opacity]);
				translate([gx0, gy2, 0]) mold([140, 37, 20], 2, 2, [37 + 8, height, 1], [0.0, 0.5, 0.0, opacity]);

				translate([gx1, gy0, 0]) mold([112, 25, 15], 2, 2, [37 + 8, height, 1], [0.2, 0.5, 0.0, opacity]);
				translate([gx1, gy2, 0]) mold([112, 25, 15], 2, 2, [37 + 8, height, 1], [0.2, 0.5, 0.0, opacity]);

				translate([gx2, gy1, -height / 2]) moldScissor([220, 82, 12], [40, 14], 2, 1, colorScissor);

				difference() {
					color(c=[0.8, 0.8, 0.8, 1]) roundedBox(size=[128, 128, 2],radius=1,sidesonly=true);

					translate([gx0, gy0, 0]) roundedBox(size=moldInner([140, 37, 20], 2), radius=2, sidesonly=false);
					translate([gx0, gy2, 0]) roundedBox(size=moldInner([140, 37, 20], 2), radius=2, sidesonly=false);

					translate([gx1, gy0, 0]) roundedBox(size=moldInner([112, 25, 15], 2), radius=2, sidesonly=false);
					translate([gx1, gy2, 0]) roundedBox(size=moldInner([112, 25, 15], 2), radius=2, sidesonly=false);

					translate([gx2, gy1, 0]) moldScissorInner([220, 82, 12], [40, 14], 2, 1, colorScissor);
				}
			}

			// 칼날을 위한 홈
			translate([gx0, 0, 0]) cube([5, 110, 128], center = true);
			translate([gx0 + 37, 0, 0]) cube([3, 110, 128], center = true);
			
			// 지지대를 위한 홈
			translate([-48, 48, 0]) cylinder(256, 8, 8, true);
			translate([48, 48, 0]) cylinder(256, 8, 8, true);
			translate([-48, -48, 0]) cylinder(256, 8, 8, true);
			translate([48, -48, 0]) cylinder(256, 8, 8, true);
		}
	}
}

prototype();