library(magrittr)
library(readxl)
library(dplyr)
library(extrafont)
font_import()
y
library(ggplot2)

size_egg <- read_xlsx("Desktop/spyegg/egg/data_raw.xlsx")

start_special <- "53:52.9"
end_special <- "54:00.0"

start_big <- "55:02.6"
end_big <- "55:09.7"

start_king <- "55:36.6"
end_king <- "55:42.7"

size_egg %>% 
  select(시간, impect) %>% 
  filter(시간 >= start_big, 시간 <= end_big) -> big_time_imp

size_egg %>% 
  select(시간, impect) %>% 
  filter(시간 >= start_king, 시간 <= end_king) -> king_time_imp

size_egg %>% 
  select(시간, impect) %>% 
  filter(시간 >= start_special, 시간 <= end_special) -> special_time_imp

View(special_time_imp)
big_time_imp$time_stack <- seq(0, by = 0.1, length.out = nrow(big_time_imp))
king_time_imp$time_stack <- seq(0, by = 0.1, length.out = nrow(king_time_imp))
special_time_imp$time_stack <- seq(0, by = 0.1, length.out = nrow(special_time_imp))

#install.packages("openxlsx")
library("openxlsx")

write.xlsx(big_time_imp, file="Desktop/spyegg/big_time_imp.xlsx")
write.xlsx(king_time_imp, file="Desktop/spyegg/king_time_imp.xlsx")
write.xlsx(special_time_imp, file="Desktop/spyegg/special_time_imp.xlsx")

ggplot(big_time_imp, aes(x= time_stack, y = impect)) +
  geom_line() +
  scale_y_continuous(limits = c(0,10), breaks = seq(0,10, by = 2.5)) +
  labs(x= "시간", y= "충격량", title = "대란 충격량") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5,size=17,face='bold',family = "NanumGothic"),
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")) -> p

ggplot(king_time_imp, aes(x= time_stack, y = impect)) +
  geom_line() +
  scale_y_continuous(limits = c(0,10), breaks = seq(0,10, by = 2.5)) +
  labs(x= "시간", y= "충격량", title = "왕란 충격량") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5,size=17,face='bold',family = "NanumGothic"),
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")) -> q

ggplot(special_time_imp, aes(x= time_stack, y = impect)) +
  geom_line() +
  scale_y_continuous(limits = c(0,10), breaks = seq(0,10, by = 2.5)) +
  labs(x= "시간", y= "충격량", title = "특란 충격량") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5,size=17,face='bold',family = "NanumGothic"),
    axis.text = element_text(family = "NanumGothic"),
    axis.title = element_text(family = "NanumGothic"),
    legend.title = element_text(family = "NanumGothic"),
    legend.text = element_text(family = "NanumGothic")) -> r


ggsave("Desktop/spyegg/Visualization/big_time_imp.png", plot=p, width=10, heigh=5)
ggsave("Desktop/spyegg/Visualization/king_time_imp.png", plot=q, width=10, heigh=5)
ggsave("Desktop/spyegg/Visualization/special_time_imp.png", plot=r, width=10, heigh=5)
