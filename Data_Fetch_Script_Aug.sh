#!/bin/bash

SOURCEDIR=B/ADS/
MONTHCOUNT=08
cd $SOURCEDIR
STARTDATE=1
ENDDATE=30
for var1 in `seq $STARTDATE $ENDDATE`
do
#if [$var1 -eq 1]
#then
case $var1 in
1)
DATECOUNT=01
echo 'hi-------------------------------------------------------------'
echo '$DATECOUNT'
#elif [$var1==2]
#then
;;
2)
DATECOUNT=02
echo 'hi-------2---------2-------------------------------------'
#elif [$var1==3]
#then
;;
3)
DATECOUNT=03
;;
#elif [$var1==4]
#then
4)
DATECOUNT=04
;;
#elif [$var1==5]
#then
5)
DATECOUNT=05
;;
#elif [$var1==6]
#then
6)
DATECOUNT=06
;;
#elif [$var1==7]
#then
7)
DATECOUNT=07
;;
#elif [$var1==8]
#then
8)
DATECOUNT=08
;;
#elif [$var1==9]
#then
9)
DATECOUNT=09
;;
#else
*)
DATECOUNT=$var1
;;
esac
#fi

wget "http://history.adsbexchange.com/Aircraftlist.json/2016-$MONTHCOUNT-$DATECOUNT.zip"
mkdir 2016-$MONTHCOUNT-$DATECOUNT
mv 2016-$MONTHCOUNT-$DATECOUNT.zip 2016-$MONTHCOUNT-$DATECOUNT	
cd 2016-$MONTHCOUNT-$DATECOUNT
unzip 2016-$MONTHCOUNT-$DATECOUNT.zip
find . -name "*.json" -size -1M -delete
cp ../json_conv_2016.R json_conv_2016.R
Rscript json_conv_2016.R
mv uav_set2.txt ../../../Processed_Dataset/August/uav_$DATECOUNT$MONTHCOUNT16.txt
cd ..
rm -R 2016-$MONTHCOUNT-$DATECOUNT

done
