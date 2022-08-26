#!/bin/bash
##/home/pi/bin/ppstatsup.sh
SUNDAY="7"
DIR=/home/pi/Nafisa/PP
WWW=/var/www/html/pp
PP=pp.csv

cd $DIR
git pull origin master

## Kopia na githubie (też)
NR=`date --date="yesterday" '+%u'`
cp $PP ${PP}.${NR}
/usr/bin/perl $DIR/update_pp.pl

###############################
#### W niedzielę wyślij na TT
#### ##########################
if [ "$NR" = "$SUNDAY" ] ; then
  R CMD BATCH pp.R 
  cp *.png $WWW

  ## weekly
  /usr/bin/perl $DIR/aggregate_pp.pl > ppw.csv
  R CMD BATCH ppw_v2.R 
  cp PPW_*_w.png $WWW

  ## Interwencje / wypadki dzienne
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków" -p PP_1.png
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków" -p PP_2.png
  ## tygodniowo ##
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków (tygodniowo)" -p PPW_wypadki_w.png
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków (tygodniowo)" -p PPW_zabici_w.png
  ##
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków (tygodniowo)" -p PPW_wypadki_wA.png
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków (tygodniowo)" -p PPW_zabici_wB.png
  ##
  ## cumulative
  R CMD BATCH pp_zc_forecast.R
  cp PPW_Zabici_Cum.png $WWW
  cp PPW_Zabici_Cum_F.png $WWW

  /home/pi/bin/twitter_post.py -t "Statystyka wypadków: zabici (cf @_zboral)" -p PPW_Zabici_Cum.png
  /home/pi/bin/twitter_post.py -t "Statystyka wypadków: zabici (cf @_zboral)" -p PPW_Zabici_Cum_F.png

fi


