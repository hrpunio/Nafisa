library("dplyr")
library("ggplot2")
library("ggpubr")
##
surl <- "www.ecdc.europa.eu/ vs ourworldindata.org/coronavirus-source-data"
today <- Sys.Date()
tt<- format(today, "%d/%m/%Y")

d <- read.csv("covid19_CW.csv", sep = ';',  header=T, na.string="NA");

d <- d %>% filter(as.Date(date, format="%Y-%m-%d") > "2020-02-15") %>% as.data.frame

##
#c1 <- c('ITw', 'DEw', 'ESw', 'UKw', 'FRw', 'DKw', 'SEw', 'IT', 'DE', 'ES', 'UK', 'FR', 'DK', 'SE')
c1 <- c('ITw', 'DEw', 'IT', 'DE' )
# date;id;country;newc;newd;totalc;totald
d1 <- d %>% filter (id %in% c1) %>% as.data.frame
t1 <- d1 %>% group_by(id) %>%  summarise(cc = sum(newc, na.rm=T), dd=sum(newd, na.rm=T))
t1
lab1c <- toString(paste (sep=" = ", t1$id, t1$cc))
lab1d <- toString(paste (sep=" = ", t1$id, t1$dd))
#lab1
str(d1)
pc1 <- ggplot(d1, aes(x= as.Date(date, format="%Y-%m-%d"), y=newc)) + 
 geom_line(aes(group = id, color = id), size=.8, alpha=.5) +
 geom_point(aes(group = id, color = id), size=1.2, alpha=.5) +
 xlab(label="") +
 ##annotate("text", x=as.Date("2020-02-12", format="%Y-%m-%d")), y=-20, label=surl, size=3, color="black", hjust = 0) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 ggtitle(sprintf("COVID19: new confirmed cases (%s)", tt), subtitle=sprintf("Total: %s\n%s", lab1c, surl)) 

pd1 <- ggplot(d1, aes(x= as.Date(date, format="%Y-%m-%d"), y=newd)) + 
 geom_line(aes(group = id, color = id), size=.8, alpha=.5) +
 geom_point(aes(group = id, color = id), size=1.2, alpha=.5) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 ggtitle(sprintf ("COVID19: deaths (%s)", tt), subtitle=sprintf("Total: %s\n%s", lab1d, surl))

##
#c2 <- c('PLw', 'CZw', 'SKw', 'HUw', 'ROw', 'BGw', 'ELw', 'PL', 'CZ', 'SK', 'HU', 'RO', 'BG', 'EL')
c2 <- c('PLw', 'CZw', 'PL', 'CZ' )
d2 <- d %>% filter (id %in% c2) %>% as.data.frame
t2 <- d2 %>% group_by(id) %>%  summarise(cc = sum(newc, na.rm=T), dd=sum(newd, na.rm=T))
str(d2)
t2
lab2c <- toString(paste (sep=" = ", t2$id, t2$cc))
lab2d <- toString(paste (sep=" = ", t2$id, t2$dd))
##d2
##
pc2 <- ggplot(d2, aes(x= as.Date(date, format="%Y-%m-%d"), y=newc)) + 
 geom_line(aes(group = id, color = id), size=.8, alpha=.5) +
 geom_point(aes(group = id, color = id), size=1.2, alpha=.5) +
 ##annotate("text", x=as.Date("2020-02-12"), y=100, label=surl, size=3, color="black", hjust = 0) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 xlab(label="") +
 ggtitle(sprintf("COVID19: new confirmed cases (%s)", tt), subtitle=sprintf("Total: %s\n%s", lab2c, surl)) 

pd2 <- ggplot(d2, aes(x= as.Date(date, format="%Y-%m-%d"), y=newd)) + 
 geom_line(aes(group = id, color = id), size=.8, alpha=.5) +
 geom_point(aes(group = id, color = id), size=1.2, alpha=.5) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 xlab(label="") +
 scale_y_continuous(breaks=c(1,2,3,4,5,6,7,8,9)) +
 ggtitle(sprintf ("COVID19: deaths (%s)", tt), subtitle=sprintf("Total: %s\n%s", lab2d, surl))

p1 <- ggarrange(pc1,pd1, ncol=2, nrow=1)
p2 <- ggarrange(pc2,pd2, ncol=2, nrow=1)
ggsave(plot=p1, "Covid19_1cw.png", width=15)
ggsave(plot=p2, "Covid19_2cw.png", width=15)
