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
