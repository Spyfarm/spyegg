rm(list=ls())

#install.packages("readr")
#install.packages("tidyverse")
library(tidyverse)
library(readr)

sanji <- read_csv('Desktop/spyegg/crawling/sanji.csv', col_names = TRUE)

domae <- read_csv('Desktop/spyegg/crawling/domae.csv', col_names = TRUE, trim_ws =TRUE) 
cols_to_delete <- c(1,4,6,8,10,11,12)
domae <- domae[-1, -cols_to_delete]
colnames(domae) <- gsub("\\.\\.\\.*[0-9]","",colnames(domae))

View(sanji)
View(domae)

