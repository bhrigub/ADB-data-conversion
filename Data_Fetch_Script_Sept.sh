#!/bin/bash

SOURCEDIR=B/ADS/
MONTHCOUNT=09
cd $SOURCEDIR
STARTDATE=1
ENDDATE=30
for var1 in `seq $STARTDATE $ENDDATE`
do
case $var1 in
1)
DATECOUNT=01
;;
2)
DATECOUNT=02
;;
3)
DATECOUNT=03
;;
4)
DATECOUNT=04
;;
5)
DATECOUNT=05
;;
6)
DATECOUNT=06
;;
7)
DATECOUNT=07
;;
8)
DATECOUNT=08
;;
9)
DATECOUNT=09
;;
*)
DATECOUNT=$var1
;;
esac

wget "http://history.adsbexchange.com/Aircraftlist.json/2016-$MONTHCOUNT-$DATECOUNT.zip"
mkdir 2016-$MONTHCOUNT-$DATECOUNT
mv 2016-$MONTHCOUNT-$DATECOUNT.zip 2016-$MONTHCOUNT-$DATECOUNT	
cd 2016-$MONTHCOUNT-$DATECOUNT
unzip 2016-$MONTHCOUNT-$DATECOUNT.zip
find . -name "*.json" -size -1M -delete
cp ../json_conv_2016.R json_conv_2016.R
Rscript json_conv_2016.R
mv uav_set2.txt ../../../Processed_Dataset/September/uav_$DATECOUNT$MONTHCOUNT16.txt
cd ..
rm -R 2016-$MONTHCOUNT-$DATECOUNT

done
