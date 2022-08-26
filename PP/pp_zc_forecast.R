#! --- R ---
library("tidyverse")
library("ggplot2")
library("lubridate")
#
# Wykres skumulowanej dziennej liczby zabitych w wypadkach
# drogowych + prognoza na koniec ostatniego roku
#
dd <- read.csv("pp.csv", sep = ';',  header=T, na.string="NA") %>%
  select(data, zabici) %>%
  arrange(data) %>%
  mutate(rok = substr(data, 1, 4),
         dzienrok = yday(as.Date(data))
         ) %>%
  ## rok 2008 jest niepełny
  filter (rok > 2008) 

## dla roku 2017 i następnych
d.cum <- dd %>%
  filter (rok > 2016) %>%
  group_by(rok) %>%
  mutate( zc =cumsum(zabici), lzc = last(zc) ) %>%
  ungroup() %>%
  mutate (lday=last(dzienrok))
 ## %>%
 ## filter (dzienrok <= lday)

max.y <- max(d.cum$zc, na.rm = T)
last.y.day <- d.cum$lday

wd.y <- floor(max.y /10)

## ostatnia obserwacja
## w ostatnim roku wyznacza koniec szeregu dla każdego
## poprzedniego roku
d_last <- d.cum %>% 
  filter (dzienrok <= lday) %>%
  group_by(rok) %>% slice(which.max(dzienrok))

## Dla wszystkich lat wykres do dnia lday
p2c <- d.cum %>% filter (dzienrok <= lday) %>% 
  ggplot(aes(x= dzienrok, y=zc, color=as.factor(rok))) + 
  geom_point(size=.5) +
  #geom_smooth(method="loess", size=1, se=F, span=.5) +
  ##geom_line(size=.5, alpha=.4) +
  geom_text(data = d_last, 
     aes(x = dzienrok, y = zc, label = sprintf("%0.0f", zc)),  
     size = 2.5, vjust = 0.1, hjust=-.4, color='black') +
  xlab(label="dzień roku") +
  ylab(label='liczba zabitych') +
  scale_y_continuous(breaks=seq(0, wd.y * 10 + wd.y, by=wd.y)) +
  scale_color_hue(name="rok") +
  ggtitle(sprintf("Wypadki/zabici (skumulowana suma | ostatni dzień roku: %i)", last.y.day), 
          subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

ggsave(plot=p2c, "PPW_Zabici_Cum.png", width=12, height = 9)
p2c
##
## Prognoza (metodą Holta)

library("forecast")

## ostatni rok
last_date <- d.cum %>% tail(n=1)
last_yr <- as.numeric( last_date$rok )
## ostatni dzień (ostatniego roku)
last_day <- as.numeric( last_date$dzienrok )

## szereg kumulowany dla ostatniego roku
last_yr_cum <- d.cum %>% filter (rok >= last_yr )

## zamień na szereg-czasowy
tzc <- ts(last_yr_cum$zc, start = c(last_yr, last_yr_cum$dzienrok), 
          frequency = 365)

## ile okresów dla prognozy?
forecast_h <- 365 - last_day

## wyznacz prognozy
fit_u  <- holt(tzc, h= forecast_h )

true_values <- rep(NA, last_day)

## cały rok, wartości empiryczne zamień na NA
xx <- c(true_values, fit_u$mean)
##length(xx)

## utwórz ramkę z ts
yy <- as.data.frame(xx)
yy <- tibble::rowid_to_column(yy, "dzienrok")

##nrow(last_yr_cum)

## wybierz tylko relewantne kolumny
d.cum.xx <- d.cum %>% select (rok, dzienrok, zc)

yy_label_f <- paste( as.character(last_yr), "p", sep='')

yy1 <- yy %>% mutate (rok = yy_label_f ) %>%
  rename (zc = xx)

## dodaj do d.cum
## szereg `last_year`p ma NA zamiast wartości empirycznych
d.cum.zz <- bind_rows(d.cum.xx, yy1)

## usuń ostatni element bo już raz jest drukowany
d_last <- head(d_last, -1)
##
d_last_last <- d.cum.zz %>% group_by(rok) %>% slice(which.max(dzienrok))

p3c <- ggplot(d.cum.zz, aes(x= dzienrok, y=zc, color=as.factor(rok))) + 
  geom_point(size=.5) +
  #geom_smooth(method="loess", size=1, se=F, span=.5) +
  ##geom_line(size=.5, alpha=.4) +
  geom_text(data = d_last, 
            aes(x = dzienrok, y = zc, label = sprintf("%0.0f", zc)),  
            size = 2.5, vjust = 0.1, hjust=-.2, color='black') +
  geom_text(data = d_last_last, 
            aes(x = dzienrok, y = zc, label = sprintf("%0.0f", zc)),  
            size = 2.5, vjust = 0.1, hjust=-.2, color='black') +
  xlab(label="dzień roku") +
  ylab(label='liczba zabitych') +
  scale_y_continuous(breaks=seq(0, wd.y * 10 + wd.y, by=wd.y)) +
  scale_color_hue(name="rok") +
  labs(caption="Źródło: policja.pl/pol/form/1,Informacja-dzienna.html") +
  ggtitle(sprintf("Wypadki/zabici (skumulowana suma | ostatni dzień roku %i: %i)", 
                  last_yr,
                  last.y.day), 
          subtitle=sprintf("%s: prognoza metodą Holta wygładzania wykładniczego", yy_label_f)) 
## 
p3c
##
ggsave(plot=p3c, "PPW_Zabici_Cum_F.png", width=12, height = 9)
##