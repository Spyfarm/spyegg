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

