# spyegg

![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/f9812652-8236-4ce2-95b1-70335e9ae4fc)



#### 계란 생산ㆍ유통과정에서 발생하는 충격량을 데이터화하는 센서(6축가속도 센서) 제작 및 환경 조성(농가 컨설팅)

---

#### [축산물품평가원-축산유통정보](https://www.ekapepia.com/priceStat/poultry/periodMarketEggPrice.do?menuId=menu100027&boardInfoNo=)의 공공데이터를 이용해 계란의 크기별(왕란,특란,대란,중란)의 산지가격과 도매가격을 크롤링 ( Python-Beautifulsoup4 )

```python
import requests
from bs4 import BeautifulSoup
import pandas as pd
from html_table_parser import parser_functions as parser

# 웹 페이지의 URL 설정
sanji_url = 'https://www.ekapepia.com/priceStat/distrSanjiPriceEgg.do?menuId=menu100156&boardInfoNo='

# 웹 페이지 요청
response = requests.get(sanji_url)

# BeautifulSoup을 사용하여 HTML 파싱
soup = BeautifulSoup(response.text, 'html.parser')

# 데이터 추출
data = soup.find('table')

table = parser.make2d(data)
df = pd.DataFrame(data=table[1:],columns=table[0])
df.to_csv('sanji.csv')
```
&uparrow; **산지가격 크롤링**
  
#### 크롤링한 데이터를 전처리( R )

```R
#rm(list=ls())

#install.packages("readr")
#install.packages("tidyverse")
library(tidyverse)
library(readr)

sanji <- read_csv('Desktop/spyegg/crawling/sanji.csv', col_names = FALSE)

domae <- read_csv('Desktop/spyegg/crawling/domae.csv', col_names = TRUE, trim_ws =TRUE) 
domae_delete <- c(1,4,6,8,10,11,12)
domae <- domae[-1, -domae_delete]
colnames(domae) <- gsub("\\.\\.\\.*[0-9]","",colnames(domae))
sanji <- sanji[-1,]
colnames(sanji) <- as.character(sanji[1,])
sanji_delete <- c(1,7)
sanji <- sanji[-1,]
sanji <- sanji[,-sanji_delete]

sanji <- data.frame(lapply(sanji, function(x) gsub("^(.*?)[[:space:]].*$", "\\1", x)))
domae <- data.frame(lapply(domae, function(x) gsub("^(.*?)[[:space:]].*$", "\\1", x)))

# 날짜를 날짜 형식으로 변환
sanji$날짜 <- as.Date(sanji$날짜)
domae$구분 <- as.Date(domae$구분)

# 첫 번째 열 제외한 나머지 열의 문자열에서 쉼표 제거 후 numeric 형식으로 변환
sanji[, -1] <- lapply(sanji[, -1], function(x) as.numeric(gsub(",", "", x)))
domae[, -1] <- lapply(domae[, -1], function(x) as.numeric(gsub(",", "", x)))


save(sanji, file = "Desktop/spyegg/Dataframe/sanji_dataframe.rda")
save(domae, file = "Desktop/spyegg/Dataframe/domae_dataframe.rda")
```

&uparrow; **전처리 소스코드**

<img width="314" alt="스크린샷 2023-06-27 오전 12 08 28" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/c24f7121-80e9-4e5e-ae92-adf5f884bc59">

<img width="318" alt="스크린샷 2023-06-27 오전 12 08 05" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/e6c9da7c-7de6-41a5-8d42-f1e7f758db4a">

--- 

#### 데이터를 토대로 시각화(R)

![image](https://github.com/seungwoolee-222/spyegg/assets/86904141/bd2c39d3-bbea-4b04-8b17-8ef1ef8142b7)

```R
#install.packages("extrafont")
#install.packages("scales")
library(scales)
library(extrafont)
font_import()
y
library(ggplot2)

load("Desktop/spyegg/Dataframe/sanji_dataframe.rda")
load("Desktop/spyegg/Dataframe/domae_dataframe.rda")


# 그래프 그리기

ggplot(sanji, aes(x = 날짜)) +
  geom_line(aes(y = 왕란, color = "왕란"), size= 1.5) +
  geom_line(aes(y = 특란, color = "특란"), size= 1.5) +
  geom_line(aes(y = 대란, color = "대란"), size= 1.5) +
  geom_line(aes(y = 중란, color = "중란"), size= 1.5) +
  labs(x = "날짜", y = "계란가격", color="구분") +
  scale_color_manual(
    values = c("왕란" = "#FFB6C1", "특란" = "#B2EC5D", "대란" = "#CDB4DB", "중란" = "#AED6F1"),
    breaks = c("왕란", "특란", "대란", "중란"),
    labels = c("왕란", "특란", "대란", "중란")
  ) +
  scale_x_date(
    labels = date_format("%m-%d"),
    date_breaks = "5 day"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")
) -> p

ggsave(file="Desktop/spyegg/Visualization/sanji.png", plot=p, width=10, heigh=5)
```

&uparrow; **시각화 소스코드**

---

#### IMU 센서(Inertial Measurement Unit)는 관성을 측정하여 최종적으로 구하고자 하는 값은 물체가 기울어진 각도를 정확하게 측정하는 관성 측정 장치, 6축 가속도 센서)
#### 3축 가속도 센서와 3축 자이로센서를 상호 보완하여 만든 센서로 충격량 계산과 위치 계산에 사용된다.

```ino
#include <ArduinoBLE.h>
#include <Wire.h>
#include "LSM6DS3.h"

// Create a instance of class LSM6DS3
LSM6DS3 myIMU(I2C_MODE, 0x6A);    // I2C device address 0x6A
BLEService imuService("180F"); // Create BLE Service with a custom UUID

BLEStringCharacteristic sensorCharacteristic("2A19", BLERead | BLENotify, 99); // Create BLE Characteristic for Sensor data

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Call .begin() to configure the IMUs
  if (myIMU.begin() != 0) {
    Serial.println("Device error");
  } else {
    Serial.println("Device OK!");
  }

  // Begin BLE
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setLocalName("IMU");
  BLE.setAdvertisedService(imuService);
  imuService.addCharacteristic(sensorCharacteristic);
  BLE.addService(imuService);
  BLE.advertise();
}

void loop() {
  BLEDevice central = BLE.central();
  
  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());

    while (central.connected()) {
      String sensorData = "";

      sensorData += "Accelerometer: ";
      sensorData += "X=" + String(myIMU.readFloatAccelX(), 4);
      sensorData += " Y=" + String(myIMU.readFloatAccelY(), 4);
      sensorData += " Z=" + String(myIMU.readFloatAccelZ(), 4);

      sensorData += "\nGyroscope: ";
      sensorData += "X=" + String(myIMU.readFloatGyroX(), 4);
      sensorData += " Y=" + String(myIMU.readFloatGyroY(), 4);
      sensorData += " Z=" + String(myIMU.readFloatGyroZ(), 4);

      sensorData += "\nThermometer: ";
      sensorData += "Degrees C=" + String(myIMU.readTempC(), 4);

      Serial.println(sensorData);

      if (sensorData.length() > sensorCharacteristic.valueSize()) {
        sensorData = sensorData.substring(0, sensorCharacteristic.valueSize());
      }

      sensorCharacteristic.setValue(sensorData);
      delay(1000);
    }
  }
}

```

<img width="1487" alt="스크린샷 2023-06-27 오후 8 06 27" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/5454eafd-c891-46c5-a3a0-898475040fc3">

&uparrow; **충격량 raw data**

```R
library(magrittr)
library(readxl)
library(dplyr)
library(extrafont)
font_import()
y
library(ggplot2)


no_buffer <- read_excel("Desktop/spyegg/egg/no_buffer.xlsx")
View(no_buffer)
yes_buffer <- read_excel("Desktop/spyegg/egg/yes_buffer.xlsx")
View(yes_buffer)

# 시간 형식 변경 함수 정의
convert_time_format <- function(time_string) {
  time <- strptime(time_string, format = "%Y-%m-%d %H:%M:%S")
  formatted_time <- format(time, format = "%Hh %Mm %Ss")
  return(formatted_time)
}

# "time" 열 변환
no_buffer$time <- sapply(no_buffer$time, convert_time_format)

yes_buffer$time <- sapply(yes_buffer$time, convert_time_format)

start_nobuffer <- "17h 38m 23s"
end_nobuffer <- "17h 38m 29s"

start_yesbuffer <- "17h 37m 59s"
end_yesbuffer <- "17h 38m 06s"

# no_buffer dataframe 생성
no_buffer %>%
  select(time, imu) %>% 
  filter(time >= start_nobuffer, time<= end_nobuffer) -> no_buffer_time_imu

# yes_buffer dataframe 생성
yes_buffer %>%
  select(time, imu) %>% 
  filter(time >= start_yesbuffer, time<= end_yesbuffer) -> yes_buffer_time_imu

# no_buffer dataframe time_stack 생성
no_buffer_time_imu$time_stack <- seq(0, by = 0.1, length.out = nrow(no_buffer_time_imu))

# yes_buffer dataframe time_stack 생성
yes_buffer_time_imu$time_stack <- seq(0, by = 0.1, length.out = nrow(yes_buffer_time_imu))

# no_buffer graph 생성
ggplot(no_buffer_time_imu, aes(x= time_stack, y = imu)) +
  geom_line() +
  scale_y_continuous(limits = c(0,10), breaks = seq(0,10, by = 2.5)) +
  labs(x= "시간", y= "충격량", title = "Nature Impact") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5,size=17,face='bold',family = "NanumGothic"),
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")) -> p

# no_buffer graph 생성
ggplot(yes_buffer_time_imu, aes(x= time_stack, y = imu)) +
  geom_line() +
  scale_y_continuous(limits = c(0,10), breaks = seq(0,10, by = 2.5)) +
  labs(x= "시간", y= "충격량", title = "Impact with Buffer") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5,size=17,face='bold',family = "NanumGothic"),
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")) -> q

ggsave("Desktop/spyegg/Visualization/no_buffer.png", plot=p, width=10, heigh=5)
ggsave("Desktop/spyegg/Visualization/yes_buffer.png", plot=q, width=10, heigh=5)
```
**Raw Data를 전처리 및 시각화(x축 시간 , y축 충격량)**

![no_buffer](https://github.com/seungwoolee-222/spyegg/assets/86904141/d5401bb8-6ca9-4eaa-9855-631e6fc3174a)


&uparrow; **충격완화가 없는 조건에서의 그래프**

![yes_buffer](https://github.com/seungwoolee-222/spyegg/assets/86904141/4d45d275-9a72-4b1f-9e3a-e65260867a2b)


&uparrow; **충격완화가 있는 조건에서의 그래프**



