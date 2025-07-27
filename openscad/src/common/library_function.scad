// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<constants.scad>


// A(x0, y0), B(x1, y1), C(x2, y2) 에서 A와 직선 BC 사이 거리 계산
function pointToLineDistance(x0, y0, x1, y1, x2, y2) =
    abs((x2 - x1)*(y1 - y0) - (x1 - x0)*(y2 - y1)) /
    sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));

// map에서 못찾으면 default에서 찾는다
function get(map, key, default) = let(
	result = search([key], map, 1, 0),
	spare = search([key], default, 1, 0)
)	is_num(result[0])
		? map[result[0]][1] 
		: is_num(spare[0]) ? default[spare[0]][1] : assert(false) "";

function linecount(string) = len(split(string, "\n")) + 1;

// 문자열 일부 추출: start부터 end까지의 문자 반환
function substring(string, start, end, index = 0, result = "") =
    index >= len(string) || index > end
        ? result
        : substring(string, start, end,
            index + 1,
            str(result, (index >= start ? string[index] : ""))
        );

// 문자열 일부 추출: start부터 end까지의 문자 반환
function split(string, delemeter) = let(parts = concat(-1, search(delemeter, string, 0)[0], len(string))) [
	for (cx = [0:len(parts) - 2])
		substring(string, parts[cx] + 1, parts[cx + 1] - 1)
];

// 적정한 fn 값
function fnRound(radious) = $preview ? FN : floor(2 * PI * radious / 0.4) - floor(2 * PI * radious / 0.4) % 4;
//function fnRound(radious) = 2 * PI * radious / 0.4;

// z축 0로로
function set_z(v, z) = [v.x, v.y, z];

// 벡터 회전 계산
function rotate_vector(angle, vector) = rotatez_vector(angle[2], rotatey_vector(angle[1], rotatex_vector(angle[0], vector)));
// x축 기준 회전 벡터 회전 계산
function rotatex_vector(anglex, vector) = [
	vector[0],
	-vector[2] * sin(anglex) + vector[1] * cos(anglex),
	vector[2] * cos(anglex) + vector[1] * sin(anglex)
];
// y축 기준 회전 벡터 회전 계산
function rotatey_vector(angley, vector) = [
	vector[0] * cos(angley) + vector[2] * sin(angley),
	vector[1],
	-vector[0] * sin(angley) + vector[2] * cos(angley)
];

// z축 기준 회전 벡터 회전 계산
function rotatez_vector(anglez, vector) = [
	-vector[1] * sin(anglez) + vector[0] * cos(anglez),
	vector[1] * cos(anglez) + vector[0] * sin(anglez),
	vector[2]
];

//	숫자, 소수점 이하 몇자리
function strfix(number, count) =
	chr([for (cx = [0:
		len(search(".", str(number))) == 0
			? len(str(number)) - 1
			: (search(".", str(number))[0] + count) >= len(str(number))
				? len(str(number)) - 1
				: (search(".", str(number))[0] + count)
	]) ord(str(number)[cx])])
;

//	육면체에서 꼭지점들을 벡터로
function	vectors_from_cube(size) = [
	[0,			0,		0],
	[size.x,	0,		0],
	[size.x,	size.y,	0],
	[0,			size.y,	0],

	[0,			0,		size.z],
	[size.x,	0,		size.z],
	[size.x,	size.y,	size.z],
	[0,			size.y,	size.z]
];
