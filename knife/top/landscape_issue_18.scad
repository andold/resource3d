//	손잡이 등받이 #18
use <common.scad>
use <landscape.scad>

module punches() {
	height = 4;
	thick = 60;
	chefsStart = 0;
	translate([chefsStart, 0, 0])						roundedBoxNotCenter([3, height, thick], 1);
	translate([chefsStart + 3 + 15, 0, 0])				roundedBoxNotCenter([4, height, thick], 1);
	translate([chefsStart + (3 + 4) + (15 + 20), 0, 0])	roundedBoxNotCenter([5, height, thick], 1);
}
module back_of_knife() {
	height = 32;

	%translate([-80, 96, 0])	landscape(8, 8, 12);
	translate([50, 60 + height, 4])	rotate([90, 180, 0]) punches();
	cube([64, height, 4]);
	
	translate([0, height - 2, 4])	cube([64, 2, 8]);

	translate([0, height, 0])	cube([2, 8, 12]);
	translate([64 - 2, height, 0])	cube([2, 8, 12]);

}

module samples() {
	back_of_knife();
}
samples();
