#!/bin/bash
#soffice --convert-to csv:"Text - txt - csv (StarCalc)":59,,0,1,1 RM_3_2018_2019L.xls
soffice --convert-to csv:"Text - txt - csv (StarCalc)":59,,0,1,1 --outdir . *.xls
