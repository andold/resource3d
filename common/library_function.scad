// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<constants.scad>

// 적정한 fn 값
function fnRound(radious) = $preview ? FN : 2 * PI * radious / 0.4;
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
