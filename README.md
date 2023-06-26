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
sanji <- sanji[,-sanji_delet ㅅe]

sanji <- data.frame(lapply(sanji, function(x) gsub("^(.*?)[[:space:]].*$", "\\1", x)))
domae <- data.frame(lapply(domae, function(x) gsub("^(.*?)[[:space:]].*$", "\\1", x)))

save(sanji, file = "Desktop/spyegg/Dataframe/sanji_dataframe.RData")
save(domae, file = "Desktop/spyegg/Dataframe/domae_dataframe.RData")
```
&uparrow; **전처리 소스코드**

<img width="314" alt="스크린샷 2023-06-27 오전 12 08 28" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/c24f7121-80e9-4e5e-ae92-adf5f884bc59">

<img width="318" alt="스크린샷 2023-06-27 오전 12 08 05" src="https://github.com/seungwoolee-222/spyegg/assets/86904141/e6c9da7c-7de6-41a5-8d42-f1e7f758db4a">

--- 

 
　




