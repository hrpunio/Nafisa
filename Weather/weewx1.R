library(reshape)
require(ggplot2)

d <- read.csv("DP1500_00.csv", sep = ';',  header=T, na.string="NA");

## convert temp
d$tempf <- ((d$tempf - 32) * 5/9)
d$tempinf <- ((d$tempinf - 32) * 5/9)
## convert inches to hPa/mm
d$baromrelin <- d$baromrelin * 33.86
d$hourlyrainin <- d$hourlyrainin * 25.4
## convert miles/ph to kmh/ph
d$windspeedmph <- d$windspeedmph * 1.6

## 2020-02-06+16:30:11
p1 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = tempf, colour = 'temp', group = 1), size=.5) +
  geom_line(aes(y = tempinf, colour = 'temp (in)', group = 1), size=0.8) +
  ylab(label="T") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p1
ggsave(file="temp.png")

p2 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = baromrelin, colour = 'pressure', group = 1), size=0.8) +
  ylab(label="P") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p2
ggsave(file="pressure.png", width=10)

p3 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = humidity, colour = 'humidity', group = 1), size=0.8) +
  geom_line(aes(y = humidityin, colour = 'humidity (in)', group = 1), size=.5) +
  ylab(label="H") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p3
ggsave(file="humidity.png", width=10)

p4 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = windspeedmph, colour = 'wind (ave)', group = 1), size=0.8) +
  ylab(label="W") +
  xlab(label="") +
  ##scale_y_continuous( sec.axis = sec_axis(name="Prędkość [kmh]",  ~./ coeff)) +
  ##labs(colour = paste( what )) +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p4
ggsave(file="wind.png", width=10)

p5 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = solarradiation, colour = 'solarradiation', group = 1), size=0.8) +
  ylab(label="S") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p5
ggsave(file="solarrad.png", width=10)

p6 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = hourlyrainin, colour = 'rain (hr)', group = 1), size=0.8) +
  ylab(label="R") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p6
ggsave(file="rain.png", width=10)

p7 <- ggplot(d, aes(x = as.POSIXct(dateutc, format="%Y-%m-%d+%H:%M:%S"))) +
  geom_line(aes(y = pm25_ch1, colour = 'PM25', group = 1), size=0.8) +
  ylab(label="PM") +
  xlab(label="") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p7
ggsave(file="pm25.png", width=10)
##
#
