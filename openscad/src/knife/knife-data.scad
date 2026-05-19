include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>

// DEFAULT 데이타 정의
DEFAULT0 = object([
	["노즐.지름",		0.4					],

	["상판.크기",		[152, 84, 8]		],

	["벽.위치.1",		[167, 57.7]			],
	["벽.위치.2",		[13, 13]			],
	["벽.크기",			[18, 512, 512]		],

//	["몸체.크기.외경",	[undef, undef, 200]	],
	["몸체.회전",		-30					],
	["몸체.이동",		[40, 200, 0]		],

	["기초.두께",		4					],
	["기초.여유",		1					],
	["기초.중복",		200					],
	["기초.높이",		128					],
	["기초.각도.앞",	45					],
	["기초.각도.옆",	-30					],

	["다리.두께",		8					],

	["andold",			""					]
]);

DEFAULT = object([
	for (cx = DEFAULT0)		[cx, DEFAULT0[cx]],

	["몸체.크기.외경",		[DEFAULT0["상판.크기"].x + DEFAULT0["기초.두께"] * 2 * 2, DEFAULT0["상판.크기"].y, DEFAULT0["기초.중복"]]],
	
	["andold",				""				]
]);
