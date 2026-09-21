# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 언어 규칙
- 사용자에게 응답할 때는 항상 한글(한국어)로 작성한다.
- 새로 생성하는 모든 문서(README, 커밋 메시지 본문, 설명 문서 등)도 항상 한글(한국어)로 작성한다.

## 이 프로젝트는 무엇인가

Ender-3로 3D 프린트하도록 설계된, 그릇건조대 형태의 칼꽂이(칼꽂이)를 위한 OpenSCAD 파라메트릭 모델이다. 더 큰 `resource3d` 저장소 안의 하위 프로젝트 중 하나이며(`openscad/src/knife`), 저장소 루트에는 이와 무관한 React/Three.js 뷰어 앱도 함께 있다 — 작업이 명시적으로 그쪽을 다루지 않는 한 무시한다.

`README.md`를 먼저 읽는다 — 물리적 요구사항(통풍이 잘 되어야 하고, 플라스틱 느낌이 아니어야 하며, 칼이 경사지게 꽂혀야 함)과 이 거치대가 수용해야 하는 모든 칼/가위의 실측 치수(날 두께/너비, 손잡이 두께)가 문서화되어 있다. 슬롯(거치 홈) 형상을 변경할 때는 반드시 이 수치들과 대조해서 확인해야 한다.

## 명령어

OpenSCAD를 직접 실행하는 것 외에 별도의 빌드 시스템은 없다(기존 스크립트에서는 `C:\apps\openscad-2021.01\openscad.exe`를 사용). 자동화된 테스트도 없다 — 정확성은 `.scad` 파일을 OpenSCAD GUI에서 열어(F5로 라이브 프리뷰) 렌더링 결과를 눈으로 확인하고, STL로 내보낸 뒤 육안 확인/슬라이싱으로 검증한다.

- **파일을 대화식으로 프리뷰/편집**: OpenSCAD GUI에서 연다. 최상위 아래에 있는 모든 `.scad` 파일은 각자 자기 자신의 `main()`/`build()`/`samples()` 호출로 끝나므로, 단독으로 열어서 렌더링할 수 있다.
- **STL 일괄 내보내기**: `build-knife.bat` (이 디렉터리에서 실행). `stl/*.stl`을 지운 뒤, `-D` 커맨드라인 인자로 `thick`, `margin`, `delta` 등을 지정해 `top/landscape.scad`와 `body/body.scad`의 여러 변형(front/side/joint half, 프로토타입 vs. 최종본)을 다시 내보낸다.
- **단일 변형을 CLI에서 내보내기** — `build-knife.bat` / `body/basis.scad` 맨 아래 주석 블록의 패턴을 따른다:
  ```
  openscad.exe --export-format asciistl -o out.stl -D command=<n> knife.scad
  ```
  각 `-D command=N` / `-D target=N` 값이 무엇을 렌더링하는지는 대상 파일의 `main()` 안에 있는 `usage()` 모듈을 확인한다 (예: `knife.scad`의 `command=1..4`는 상판/하판의 서로 다른 서브 어셈블리를 렌더링한다).
- `basis#37.scad`, `under#38.scad`, `foot#28.scad`처럼 이름에 번호가 붙은 파일들은 번호가 매겨진 스냅샷이다(`#NN`은 해당 리비전이 작업된 GitHub 이슈 번호). `knife.scad`에서 현재 `use`하고 있는 파일만 실제로 살아있는(live) 파일이며, 번호가 더 오래된 나머지 파일들은 삭제하지 않고 이력/참고용으로 남겨둔다.

## 아키텍처

**하드코딩이 아닌 데이터 기반 설계.** 거의 모든 모듈이 개별 인자 대신 하나의 `data`(또는 `param`) 맵을 인자로 받는다. 이 맵은 `object([[key, value], ...])`(`../common/library_function.scad`에 정의됨)로 만들어지고 `data["key"]`로 조회한다. 키는 물리량을 나타내는 한글 문구다(예: `"몸체.회전"` = 몸체 회전, `"기초.두께"` = 기초 두께, `"벽.위치.1"` = 벽 위치 1) — 점(`.`)으로 구분된 이름은 관련된 필드들을 느슨하게 그룹핑한다. `knife-data.scad`가 기준이 되는 `DEFAULT` 맵을 정의한다: `DEFAULT0`는 직접 작성한 기본값들을 담고, `DEFAULT`는 여기서 몇 가지 계산된 필드(예: 몸체 외경 크기)를 파생시킨다. 치수를 추가할 때는 `DEFAULT`가 아니라 `DEFAULT0`를 확장해야 한다.

**위치/회전 래퍼 모듈을 통한 조합.** 형상을 생성하는 모듈들은 `children()`을 `translate`/`rotate`만 해서 배치하는 작은 모듈들과 조합된다 — `under.scad`의 `basis0p`/`basis1p`/`basis2p`를 보라("전체 구조물을 상판위에 비스듬이 돌려서 얹는다" — 전체 어셈블리를 상판 위에 각도를 주어 배치; "벽 구조물을 세운다" — 벽을 세워 놓는다). `knife.scad`의 `main()`이 이 패턴을 보여준다: 이런 배치용 모듈들을 체이닝하고, 그 자식으로 실제 솔리드를 생성하는 모듈(`under20`, `basis01_type_4_assemble` 등)을 호출한다. 새 부품을 추가할 때는 절대 좌표 오프셋을 형상 모듈 안에 박아 넣기보다는, 부품 자체는 자신만의 로컬 좌표계에서 작성하고 별도의 배치용 래퍼를 붙이는 방식을 선호한다.

**파일 구조 / 의존 방향**:
- `knife-data.scad` — 공유 파라미터 맵(`DEFAULT0`/`DEFAULT`). 전역 변수가 보이도록 거의 모든 곳에서 `use`가 아니라 `include`된다.
- `knife.scad` — 최상위 어셈블리 진입점. 아래의 모듈들을 `use`하고 `main(command)`에서 이들을 구동한다.
- `under.scad`, `knife-before.scad` — 배치용 헬퍼 및 레거시/보조 형상.
- `body/` — 주요 구조 부품들 (`basis*.scad` = 경사진 몸체/칼거치 어셈블리, `wall.scad` = 몸체가 기대는 벽/받침, `under#38.scad` = 하단 가로 지지대, `body.scad`/`bodyOnePiece.scad`/`body_assemble.scad` = 몸체의 다른 구성 방식들, `common.scad` = 이 폴더에서 공유하는 board/window/bulge 헬퍼 모듈들).
- `top/` — 칼이 꽂히는 구멍 뚫린 상판 (`landscape.scad`/`portrait.scad` 방향; `common.scad`는 README의 실측 날 치수를 기준으로 크기가 정해지는, 칼/가위 슬롯 패턴을 잘라내는 `punch()` 모듈을 정의한다).
- `etc/` — 작은 독립 유틸리티 (`utils.scad`, `measure.scad`). 대부분 `../common/`으로 대체되었지만, 아직 이를 참조하는 파일들이 있어 남아 있다.
- `diag/` — 일회성 진단용 모델(프린터 각도/각도값 동작 확인용). 실제 어셈블리에는 포함되지 않는다.
- `stl/` — `build-knife.bat`의 빌드 산출물. 언제든 재생성 가능한 일회성 결과물로 취급한다.
- `../common/` (`knife/`보다 한 단계 위, `openscad/src/*`의 모든 프로젝트가 공유) — `constants.scad`(`EPSILON`, `FN`, `HR`, 너트/볼트 반지름 등 전역 상수 — `include`로 사용하며 이 상수들을 로컬에서 다시 정의하지 않는다), `library_function.scad`(`object`/`get` 맵 헬퍼, 벡터 회전 계산, 문자열 헬퍼 — `use`로 사용), `library.scad`, `library_text.scad`(곳곳에서 보이는 `note()` 주석 텍스트 헬퍼), `library_cube.scad`/`library_line.scad`/`library_trimmer.scad`.

**디버그용 주석은 부수적인 것이 아니라 모델링 관례의 일부다.** 모듈들은 진입 시 일관되게 자신의 이름과 파라미터를 `echo()`로 출력하고(흔히 `parent_module(0)` 문자열을 통해), `note()`/`%`(배경/투명 프리뷰 모디파이어)를 이용해 치수 라벨을 모델 안에 직접 렌더링해서, OpenSCAD 프리뷰만으로 치수를 읽을 수 있게 한다. 새 모듈을 작성할 때도 이 관례를 따른다 — 디버거 없이 치수를 검증하는 방법이 바로 이것이다.

**단위**: 모든 치수는 밀리미터이며, `README.md`에 기록된 실제 칼/판을 캘리퍼스로 측정한 값과 일치한다.
