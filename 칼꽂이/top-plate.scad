use <MCAD/boxes.scad>
use <landscape.scad>
use <portrait.scad>

//function topPlateSize()  = portraitSize();
function topPlateSize()  = landscapeSize();
module topPlate() {
//	portrait();
	landscape();
}

topPlate();
