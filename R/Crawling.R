rm(list=ls())

#install.packages("readr")
#install.packages("tidyverse")
library(tidyverse)
library(readr)

sanji <- read_csv('Desktop/spyegg/crawling/sanji.csv', col_names = TRUE)
sanji$날짜 <- as.Date(sanji$날짜)
sanji <- data.frame(lapply(sanji,function(x) gsub("[^0-9].*", "", x)))
domae <- read_csv('Desktop/spyegg/crawling/domae.csv', col_names = TRUE, trim_ws =TRUE) <- domae[-1, ]



View(sanji)
View(domae)

