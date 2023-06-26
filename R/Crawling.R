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

save(sanji, file = "Desktop/spyegg/Dataframe/sanji_dataframe.RData")
save(domae, file = "Desktop/spyegg/Dataframe/domae_dataframe.RData")

