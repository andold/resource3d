include	<../knife-data.scad>

//	벽 모델링 자료
module wall(x, y, z) {
	echo(str("", parent_module(0), "(", x, y, z, ")"));

	translate([0, -y / 2, 0]) {
		cube([167, y, 57.7]);
		note(167, y, 57.7);
		
	}
	translate([0, -y / 2, 57.7]) {
		cube([180, y, 13]);
		note(180, y, 13);
	}
	translate([-EPSILON, -y / 2, 0])	cube([EPSILON, y, z]);
}

//	벽표면에 따른, 여유공간을 띄운 도형
module foot0a(data) {
	echo(str("벽단면:여유공간::", parent_module(0), ".", parent_module(1), "(", data, ")"));
	
	nozzleRadius = data["노즐.지름"] / 2;
	thick = data["다리.두께"];
	points = [
		[data["벽.위치.1"].x + nozzleRadius,							nozzleRadius],
		[data["벽.위치.1"].x + nozzleRadius,							data["벽.위치.1"].y - nozzleRadius],
		[data["벽.위치.1"].x + nozzleRadius + data["벽.위치.2"].x,	data["벽.위치.1"].y - nozzleRadius],
		[data["벽.위치.1"].x + nozzleRadius + data["벽.위치.2"].x,	data["벽.위치.1"].y + data["벽.위치.2"].y + nozzleRadius],
		[data["벽.위치.1"].x + nozzleRadius - data["벽.위치.1"].x,	data["벽.위치.1"].y + data["벽.위치.2"].y + nozzleRadius],

		[data["벽.위치.1"].x + nozzleRadius - data["벽.위치.1"].x,			data["벽.위치.1"].y + data["벽.위치.2"].y + thick - nozzleRadius],
		[data["벽.위치.1"].x + thick + data["벽.위치.2"].x - nozzleRadius,	data["벽.위치.1"].y + data["벽.위치.2"].y + thick - nozzleRadius],
		[data["벽.위치.1"].x + thick + data["벽.위치.2"].x - nozzleRadius,	data["벽.위치.1"].y - thick + nozzleRadius],
		[data["벽.위치.1"].x + thick - nozzleRadius,							data["벽.위치.1"].y - thick + nozzleRadius],
		[data["벽.위치.1"].x + thick - nozzleRadius,							nozzleRadius],

		[data["벽.위치.1"].x + nozzleRadius,									nozzleRadius]
	];
	polygon(points = points);
}

//	벽단면
module	wall_2d(data) {
	echo(str("벽단면::", parent_module(0), ".", parent_module(1), "(", data, ")"));
	
	points = [
		[0,											0],
		[data["벽.위치.1"].x,						0],
		[data["벽.위치.1"].x,						data["벽.위치.1"].y],
		[data["벽.위치.1"].x + data["벽.위치.2"].x,	data["벽.위치.1"].y],
		[data["벽.위치.1"].x + data["벽.위치.2"].x,	data["벽.위치.1"].y + data["벽.위치.2"].y],
		[0,											data["벽.위치.1"].y + data["벽.위치.2"].y],

		[0, 0]
	];
	polygon(points = points);
}

//	벽 위치 자세::	xy평면에 있는 도형을 늘리고, 회전 이전 시켜 자세를 잡는다
module wall0(data) {
	echo(str("벽 위치 자세::", parent_module(0), ".", parent_module(1), "(", data, ")"));
	
	translate([0, data["벽.크기"].y, 0])
	rotate([90, 0, 0])
	translate([0, 0, 0])
	children();
}

//	벽
module wall00(data) {
	echo(str("벽::", parent_module(0), ".", parent_module(1), "(", data, ")"));
	
	fontsize1 = 4;
	fontsize2 = 2;

	%
	wall0(data) {
		linear_extrude(height  = data["벽.크기"].y, v = [0, 0, 1], center = false) {
			 wall_2d(data);
		}
		color("yellow") {
			translate([(data["벽.위치.1"].x + data["벽.위치.2"].x) / 2, data["벽.위치.1"].y + data["벽.위치.2"].y, data["벽.크기"].y])
			note(str(data["벽.위치.1"].x + data["벽.위치.2"].x, "mm"), size = fontsize1, valign = "top", halign = "center");

			translate([(data["벽.위치.1"].x) / 2, 0, data["벽.크기"].y])
			note(str(data["벽.위치.1"].x, "mm"), size = fontsize1, valign = "bottom", halign = "center");

			translate([0, (data["벽.위치.1"].y + data["벽.위치.2"].y) / 2, data["벽.크기"].y])
			rotate([0, 0, 90])
			note(str(data["벽.위치.1"].y + data["벽.위치.2"].y, "mm"), size = fontsize1, valign = "top", halign = "center");

			translate([(data["벽.위치.1"].x) / 1, (data["벽.위치.1"].y) / 2, data["벽.크기"].y])
			rotate([0, 0, -90])
			note(str(data["벽.위치.1"].y, "mm"), size = fontsize1, valign = "top", halign = "center");

			translate([data["벽.위치.1"].x + data["벽.위치.2"].x / 2, (data["벽.위치.1"].y), data["벽.크기"].y])
			rotate([0, 0, 0])
			note(str(data["벽.위치.2"].x, "mm"), size = fontsize2, valign = "bottom", halign = "center");

			translate([data["벽.위치.1"].x + data["벽.위치.2"].x, (data["벽.위치.1"].y) + data["벽.위치.2"].y / 2, data["벽.크기"].y])
			rotate([0, 0, -90])
			note(str(data["벽.위치.2"].y, "mm"), size = fontsize2, valign = "top", halign = "center");
		}
	}
	
	for (name = data) {
		echo(name, data[name]);
	}
}

//	다리
module foot0(data) {
	echo(str("다리::벽 경계를 따라서::", parent_module(0), ".", parent_module(1), "(", data, ")"));
	assert(data, "파라미터 undefined");

	nozzleRadius = data["노즐.지름"] / 2 * 10;

	color("blue")
	wall0(data)
	linear_extrude(height  = data["벽.크기"].y, v = [0, 0, 1], center = false) {
		foot0a(data);
	}
}

module samples() {
//	wall(128, 128, 128);
	wall00(DEFAULT);
	foot0(DEFAULT);
}

samples();