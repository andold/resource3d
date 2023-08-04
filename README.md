# resource3d
- 3d 모델링 자료

## trouble shooting
- 3D 프린터 : 프린팅 불량유형 및 해결책
	- https://blog.naver.com/technics3d/220778796667

- [삼디불량사전] 3D 프린터 압출불량 (Under Extrusion)
	- https://youtu.be/TUpwlxeG4qU

### 후반부에 아예 프린팅되지 않는다
- 참고: [삼디불량사전] 3D 프린터 압출불량 (Under Extrusion)
	- 7번 아얘 안나오는 압출불량
	- https://youtu.be/TUpwlxeG4qU

- 실패: 노즐온도 190도, 3mm retraction distance로 해보았으나 동일 현상 발생
	- 원복한다

- 날씨가 더워서 냉각이 안되는게 아닐까?
	- 상당히 설득력 있다. 에어컨을 켜주어야 하나?

- 참고: [북리지의 삼디 Life] 압출불량 해결을 위한 16가지 가이드
	- https://bookledge.tistory.com/982
	- 날씨가 더워서 그럴수도 있다는 군
	- 정말 에어컨을 켜줘야 하나?

### PLA 특성
- 딱딱함의 정도가 낮다.
	- 두께를 3mm 정도는 해야할 듯하다. 1mm는 너무 많이 휘어진다.
	- 2mm로 타협을 봐 본다.
	- 2mm는 띠기 어렵다. 3mm로 다시 타협한다.

- 상품 설명에 프린터 설정값이 있다. 적용해 보자.

### Ender 3
- 레벨링(영점조절)의 중요성
	- 너무 높으면, 출력중에 출력물이 바닥에서 떨어져서 밀려다닌다.

- 팁
	- 바닥과 노즐사에 종이를 집어 넣고 흔들어 본다.

### 모델링
- 껍질/막: difference를 사용하기 보다는 2d line을 사용하는게 좋을 듯하다.
	- 현재는 구멍 뚫는 것이 대부분이라 아직 적용해보지는 못했지만,
	- 기회가 되면 해봐야 할것 같다. 난이도와 집중력은 필요해 보인다.
	
## firmware update
- 시작지점
	- 10 Ways How to Fix Ender 3/Pro/V2 Not Printing or Starting
	- https://3dprinterly.com/how-to-fix-ender-3-not-printing-or-starting/

- Ender-3(엔더3) 소프트웨어 업그레이드 #1 - 펌웨어(Marlin) 빌드 하기 by 아두이노 IDE
	- https://blog.naver.com/chandong83/221758014172

- Ender-3 순정 펌웨어 올리기
	- https://m.blog.naver.com/rtbo02/221827886562

- The Creality3D Ender-3, a fully Open Source 3D printer perfect for new users on a budget.
	- https://github.com/Creality3DPrinting/Ender-3/tree/master

- 아두이노 IDE 다운로드
	- https://www.arduino.cc/en/software

### 결론: Creality 사이트에 가면, 바이너리 다운로드 링크가 있다
	- 다운받아서 CF 카드에 복사하면 된다.

