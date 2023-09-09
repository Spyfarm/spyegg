# spyegg

#### 수상

#### [농림축산식품부 공공/빅데이터 창업경진대회 최우수상 수상](http://www.agrinet.co.kr/news/articleView.html?idxno=320467)

#### 제 11회 공공데이터활용창업경진대회 통합본선 진출

---

#### 스파이에그 
![image](https://github.com/Spyegg/spyegg/assets/86904141/4983b2df-b081-4022-8879-08667aba6f81)

#### 스파이에그 센서
![image](https://github.com/Spyegg/spyegg/assets/86904141/fa690f60-b000-4005-9506-bedbff3cc3db)
![image](https://github.com/Spyegg/spyegg/assets/86904141/9a8f2262-5aef-4058-af19-476b7115c347)
![image](https://github.com/Spyegg/spyegg/assets/86904141/20a75402-9253-47cc-a437-34b83a09f7f7)

#### 시제품 도면
![image](https://github.com/Spyegg/spyegg/assets/86904141/39441618-1d3f-41e7-a2ed-f055160fe467)


#### 계란 생산ㆍ유통과정에서 발생하는 충격량을 데이터화하는 센서(6축가속도 센서) 제작 및 환경 조성(농가 컨설팅)

---

#### [축산물품평가원-축산유통정보](https://www.ekapepia.com/priceStat/poultry/periodMarketEggPrice.do?menuId=menu100027&boardInfoNo=)의 공공데이터를 이용해 계란의 크기별(왕란,특란,대란,중란)의 산지가격과 도매가격을 크롤링 ( Python-Beautifulsoup4 )

#### 

#### 크롤링한 데이터를 전처리( R )

<img width="314" alt="스크린샷 2023-06-27 오전 12 08 28" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/c24f7121-80e9-4e5e-ae92-adf5f884bc59">

<img width="318" alt="스크린샷 2023-06-27 오전 12 08 05" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/e6c9da7c-7de6-41a5-8d42-f1e7f758db4a">

--- 

#### 데이터를 토대로 시각화(R)

![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/0e5f82d2-a71d-4b9c-b357-53c5da767230)
![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/04171f78-f194-410c-8173-06b4852f8f73)

---

#### IMU 센서(Inertial Measurement Unit)는 관성을 측정하여 최종적으로 구하고자 하는 값은 물체가 기울어진 각도를 정확하게 측정하는 관성 측정 장치, 6축 가속도 센서)
#### 3축 가속도 센서와 3축 자이로센서를 상호 보완하여 만든 센서로 충격량 계산과 위치 계산에 사용된다.

<img width="1487" alt="스크린샷 2023-06-27 오후 8 06 27" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/5454eafd-c891-46c5-a3a0-898475040fc3">

&uparrow; **충격량 raw data**


**Raw Data를 전처리 및 시각화(x축 시간 , y축 충격량)**

![no_buffer](https://github.com/seungwoolee-222/spyegg/assets/86904141/d5401bb8-6ca9-4eaa-9855-631e6fc3174a)


&uparrow; **충격완화가 없는 조건에서의 그래프**

![yes_buffer](https://github.com/seungwoolee-222/spyegg/assets/86904141/4d45d275-9a72-4b1f-9e3a-e65260867a2b)


&uparrow; **충격완화가 있는 조건에서의 그래프**



![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/5f07c940-bdc7-4bd9-abc8-e5815f92a9e7)

&uparrow; **대란 충격량 그래프**

![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/268289a8-c065-421e-a98e-fc52f4c8e249)

&uparrow; **특란 충격량 그래프**

![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/1201a8f4-a1dd-438b-b423-928eb1ebd833)
&uparrow; **왕란 충격량 그래프**

#### 무게별(왕,특,대 순서로 작아짐)로 충격량이 다른 것을 확인할 수 있다.





