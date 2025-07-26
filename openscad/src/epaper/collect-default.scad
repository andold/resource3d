//use <part-01.scad>	// 화소가 있는 영역, activeArea
//use <part-02.scad>	//	주요 화면 부품. Display Panel, displayPanel
//use <part-03.scad>	//	디스플레이 패널에 붙어있는 커넥터, displayConnector
//use <part-04.scad>	//	패널 밑에 받치는 밑판
//use <part-05.scad>	//	디스플레이 패널을 덮는 위판, upperPanel
//use <part-06.scad>	//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
//use <part-10.scad>	//	연결 부속들만 네 귀퉁이에 위치시킨 것
//use <part-13.scad>

//	DEFAULT값을 모아, 모아서
DEFAULT_COLLECTED = [
	// part01, 화소가 있는 영역, activeArea
	["active.area",								"화소가 있는 영역, activeArea"],
	["active.area.size",	[160.00, 96.00],	"크기, 화소가 있는 영역, sizeActiveArea"],

	//	part02, 주요 화면 부품. Display Panel, displayPanel
	["display.panel",								"주요 화면 부품. Display Panel, displayPanel"],
	["display.panel.size",	[170.20, 111.20, 0.91],	"크기, 화면 부품의 크기, sizeDisplayPanel"],
	["active.area.margin",	[5.10, 4.70],			"여백, 화소가 있는 영역, marginActiveArea"],

	//	디스플레이 패널에 붙어있는 커넥터, displayConnector, part03
	["display.connector",			"디스플레이 패널에 붙어있는 커넥터, displayConnector, part03"],
	["display.connector.size",		[25.50, 24.00, 0.1],			"크기, sizeDisplayConnector"],
	["display.connector.margin",	[72.35, 0, 0],					"디스플레이 패널로부터의 상대적인 위치,여백, marginDisplayConnector"],

	//	패널 밑에 받치는 밑판, underPanel
	["under.panel",									"패널 밑에 받치는 밑판, underPanel"],
	["under.panel.height",				2,			"밑판의 높이, heightUnderPanel"],
	["under.panel.hill.size",			[3, 3, 1],	"언덕의 크기, sizeUnderPanelHill"],
	["under.panel.corner.plane.radius",	3 / 4,		"모서리 대패의 반경, radiusUnderPanelCornerPlane"],
	["under.panel.rail",				[16, 16, 0],"밑판 최외곽 최소 너비 railUnderPanel"],
	["under.panel.hole",							"밑판 구멍"],
	["under.panel.hole.ratio",			0.5,		"밑판 구멍내는 비율, ratioUnderPanelHole"],
	["under.panel.hole.radius",			8,			"밑판 구멍내는 원의 크기, radiusUnderPanelHole"],
	["under.panel.size",							"계산된 크기. 다른 부품(패널)의 크기에 종속된다"],
	["under.panel.size.outter",			undef,		"계산된 전체 외경, sizeOutterUnderPanel"],
	["under.panel.size.inner",			undef,		"계산된 내경, sizeInnerUnderPanel"],

	["display.panel.margin",			[0.5, 0.5,  0.5],	"여백, 밑판과 화면 부품 사이의 여유 공간, marginDisplayPanel"],

	//	part05, 디스플레이 패널을 덮는 위판, upperPanel
	["upper.panel",					"디스플레이 패널을 덮는 위판, upperPanel"],
	["upper.panel.hight",	1,		"높이 of 디스플레이 패널을 덮는 위판, hightUpperPanel"],
	["upper.panel.radius",	1 / 4,	"모서리 굴곡의 반지름, radiusUpperPanel"],

	//	연결 부속들만 네 귀퉁이에 위치시킨 것
	["joint",													"연결 부속, joint"],
	["joint.size",		[0.8, 12, 3 - 0.4 - 0.1, 0.4, 0.4],		"연결 부속 크기 정의, sizeJoint"],
	["joint.margin",	[3, 8, 0],								"여백, 연결 부속의 모서리로부터의 위치, marginJoint"],

	//	프로토타입: 밑판 위판 귀퉁이 일부만 출력, prototype
	["prototype",							"프로토타입: 밑판 위판 귀퉁이 일부만 출력, prototype"],
	["prototype.joint.margin",	[32, 32],	"연결 부속을 들어내는 크기, marginPrototypeJoint"],

//	for (cx = default01()) cx,
//	for (cx = default02()) cx,
//	for (cx = default03()) cx,
//	for (cx = default04()) cx,
//	for (cx = default05()) cx,
//	for (cx = default06()) cx,
//	for (cx = default10()) cx,
//	for (cx = default13()) cx,

	["end", "끝"]
];
function default() = DEFAULT_COLLECTED;

module usage() {
	echo(str(parent_module(0), ".", parent_module(1), "(", DEFAULT_COLLECTED, ")"));
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));

	if (command == 0) {
		usage();
	} else {
		echo("NOT SUPPORTED");
	}
}

main(is_undef(command) ? 0 : command);
