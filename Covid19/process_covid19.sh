#!/bin/bash
###  apt-get install default-jre libreoffice-java-common
#### 532549 - javaldx: Could not find a Java Runtime Environment!
#### install.packages("ggpubr")
TODAY=`date +"%Y%m%d"`

wget -N 'https://www.ecdc.europa.eu/sites/default/files/documents/COVID-19-geographic-disbtribution-worldwide-2020-03-15.xls' -O covid19.xls
mv covid19.csv covid19_${TODAY}.csv
soffice --convert-to csv:"Text - txt - csv (StarCalc)":59,,0,1,1 --outdir . *.xls
###
echo "Perling..."
perl conv.pl covid19.csv > covid19_C.csv
echo "Ring..."
R CMD BATCH covid19.R
##
echo "Twitting..."
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19" -p Covid19_1.png
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19" -p Covid19_2.png
