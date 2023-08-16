
module diagnose_degree(w, upto) {
	difference() {
		cube([w * 2, w, w * 2]);
		translate([0, w + 1, w])	rotate([90, 0, 0])	cylinder(w  + 2, w, w);
		translate([-1 , -1, w + w * sin(upto)])	cube(1024);
	}
	//translate([0, 0, 0])	cube([w * 2, w, w]);
}
diagnose_degree(16, 75);
