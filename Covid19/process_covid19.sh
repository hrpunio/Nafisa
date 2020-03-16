#!/bin/bash
###  apt-get install default-jre libreoffice-java-common
#### 532549 - javaldx: Could not find a Java Runtime Environment!
#### install.packages("ggpubr")
TODAY=`date +"%Y%m%d"`

wget -N 'https://www.ecdc.europa.eu/sites/default/files/documents/COVID-19-geographic-disbtribution-worldwide-2020-03-15.xls' -O covid19.xls
mv covid19.csv covid19_${TODAY}.csv
soffice --convert-to csv:"Text - txt - csv (StarCalc)":59,,0,1,1 --outdir . *.xls
###
echo "Perling...(E)"
perl conv.pl covid19.csv > covid19_C.csv
echo "Ring...(E)"
R CMD BATCH covid19.R
##
echo "Twitting..."
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 Data from www.ecdc.europa.eu" -p Covid19_1.png
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 Data from www.ecdc.europa.eu" -p Covid19_2.png
####
####
wget -N https://covid.ourworldindata.org/data/full_data.csv
echo "Perling...(W)"
perl recode.pl full_data.csv > covid19_W.csv
##
echo "Ring...(W)"
R CMD BATCH covid19_W.R
echo "Twitting..."
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 Data from covid.ourworldindata.org" -p Covid19_1w.png
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 Data from covid.ourworldindata.org" -p Covid19_2w.png
##
##
echo "Ring...(CW)"
cat covid19_C.csv covid19_W.csv | awk 'NR >1 && $0 ~ /date;id;country/ { next} ; {print}' >  covid19_CW.csv
R CMD BATCH covid19_CW.R
echo "Twitting...(SW)"
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 covid.ourworldindata.org vs www.ecdc.europa.eu" -p Covid19_1cw.png
/home/pi/bin/twitter_post.py -t "#coronavirus #COVID19 covid.ourworldindata.org vs www.ecdc.europa.eu" -p Covid19_2cw.png
