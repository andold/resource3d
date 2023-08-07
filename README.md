# resource3d
- 3d 모델링 자료
- Ender-3 프린터 사용
	- Modeling Dimensions: 220*220*250mm
	- Printing Material: PLA/ABS/PETG
	- 사용 필라멘트: PLA 투명 1.75mm

## trouble shooting
### 참고
- 3D 프린터 : 프린팅 불량유형 및 해결책
	- https://blog.naver.com/technics3d/220778796667

- [삼디불량사전] 3D 프린터 압출불량 (Under Extrusion)
	- https://youtu.be/TUpwlxeG4qU

- Ender3 압출불량 없는 노즐목 조립 2 (Ender 3 clog Zero making)
	- https://youtu.be/6MH1XWbQdtw

### 모서리 부분의 까끔하지 못하다
- 현상: 결합부위를 격자 형태로 하였는데, 모서리 부분이 뭉개진다.
- [ ] 외벽/내벽 설정과 관련되어 있는 것 같다, 공부해 보자

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

- 실패: 에어컨을 켜주어도 해결이 안된다.
	- 노즐쪽 냉각팬이 약해서 그런것 같다. 또는 이상 동작하든지. 분해해 보아야겠다.
	- 모터 부분을 분해해 보았으나, 육안으로 보기엔 이상이 없다. 노즐 분해는 해보지 않았다.

- 해결을 위한 TODO
	- [ ] 노즐목에 부품 추가: 위의 노즐목 조립 유튜브 영상 참조
	- [ ] 필라멘트 교체: 현재 PLA에서 열에 잘 변형되지 않는 것으로, 뭔지는 찾아 보아야 한다
	- [x] retraction distance를 줄여본다
		- 1mm ~ 1.5mm가 적당하다는 의견이 있다. 디폴트값은 5mm 이다
		- 1.5mm에서 거미줄이 나타난다. 3mm로 타협해 본다
		- retraction을 줄이는 형태로 모델링해 본다. 원형은 리트랙션이 많이 발생하는 모델이다
		- 리트랙션 빈도를 최대한 줄여서 프린트했더니, 호전되는 듯 하다. 1mm로 해보아야 겠다. 거미줄은 예상한다, 정료한 레벨링으로 거미줄은 해소해 본다.
		- 호전되는 듯 하였으나, 역시 리트랙션이 많아 발생하고 나면, 압출불량이 발생한다. 거미줄도 발생했다.
		- 리트랙션 원인은 아닌듯하다, 노즐목을 건드려 봐야 겠다.

#### 결론 1) 리트랙션 거리 원인은 아닌 듯하다

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

