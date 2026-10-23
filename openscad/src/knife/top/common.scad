use <MCAD/boxes.scad>

include	<../../common/constants.scad>
include	<../knife-data.scad>
use <../../common/library.scad>

// delta 인자가 없으면 data의 기본 간격을 쓴다
function punchDelta(delta, data) = is_undef(delta) ? data["칼구멍.간격"] : delta;

//	빵칼 영역: 시작 x, 길이
function breadLength(delta, data = DEFAULT) = let(
	d = punchDelta(delta, data),
	w = data["칼구멍.빵칼.두께"]
)	(w + d) * (len(data["칼구멍.빵칼.분할"]) - 1) + w;

//	가위 영역: 시작 x, 길이
function scissorStart(delta, data = DEFAULT) = data["칼구멍.빵칼.시작"] + breadLength(delta, data) + punchDelta(delta, data);
function scissorLength(delta, data = DEFAULT) = let(
	count = data["칼구멍.가위.개수"]
)	data["칼구멍.가위.크기"][0] * count + punchDelta(delta, data) * (count - 1);

//	식도 영역: 시작 x, 길이
function chefsStart(delta, data = DEFAULT) = scissorStart(delta, data) + scissorLength(delta, data) + punchDelta(delta, data);
function chefsLength(data = DEFAULT) = let(
	pos = data["칼구멍.식도.위치"],
	width = data["칼구멍.식도.두께"]
)	pos[len(pos) - 1] + width[len(width) - 1];

// export
function chefsInfo(delta = undef, data = DEFAULT)  = [chefsStart(delta, data), chefsLength(data)];	//	[x위치, 길이]
function coreWidth(delta = undef, data = DEFAULT)  = chefsStart(delta, data) + chefsLength(data);
function coreSize(delta = undef, thick = undef, data = DEFAULT)  = [
	coreWidth(delta, data),
	data["칼구멍.높이"],
	is_undef(thick) ? data["상판.크기"].z : thick
];

module	roundedBoxNotCenter(size = [32, 64, 8], radius = 8, sidesonly = true) {
	translate([size[0] / 2, size[1] / 2, size[2] / 2])		roundedBox(size, radius, sidesonly, $fn = FN);
}

// export
module punch(height = undef, thick = undef, delta = undef, data = DEFAULT) {
	h = is_undef(height) ? data["칼구멍.높이"] : height;
	t = is_undef(thick) ? data["칼구멍.두께"] : thick;
	d = punchDelta(delta, data);
	r = data["칼구멍.모서리반경"];
	echo("punch", height = h, thick = t, delta = d);

	// 과도, 빵칼: 열마다 높이를 n등분한 슬롯. 슬롯을 trim만큼 줄이고 남는 길이를 슬롯 사이 간격으로 나눈다
	breadStart = data["칼구멍.빵칼.시작"];
	breadWidth = data["칼구멍.빵칼.두께"];
	trim = data["칼구멍.빵칼.여유"];
	splits = data["칼구멍.빵칼.분할"];
	for (ci = [0 : len(splits) - 1]) {
		n = splits[ci];
		x = breadStart + (breadWidth + d) * ci;
		if (n <= 1) {
			translate([x, 0, 0])	roundedBoxNotCenter([breadWidth, h, t], r);
		} else {
			slotLength = h / n - trim;
			gap = trim * n / (n - 1);
			for (k = [0 : n - 1])
				translate([x, k * (slotLength + gap), 0])	roundedBoxNotCenter([breadWidth, slotLength, t], r);
		}
	}

	// 가위
	scissorX = scissorStart(delta, data);
	scissor = data["칼구멍.가위.크기"];
	for (k = [0 : data["칼구멍.가위.개수"] - 1])
		translate([scissorX + (scissor[0] + d) * k, (h - scissor[1]) / 2, 0])	ellipsis(scissor[0], scissor[1], t);

	//	식도
	chefsX = chefsStart(delta, data);
	chefsWidth = data["칼구멍.식도.두께"];
	chefsPos = data["칼구멍.식도.위치"];
	for (ci = [0 : len(chefsPos) - 1])
		translate([chefsX + chefsPos[ci], 0, 0])	roundedBoxNotCenter([chefsWidth[ci], h, t], r);
}
punch();
