#!/bin/bash

data_dir=/data/img/wallpapers/electrol/
resolution="1920x1080"
monitor=0

export LC_ALL=en_US.UTF-8 
# ELEKTRO-L server
ftp_site=ftp://electro:electro@ftp.ntsomz.ru/
# generating date information
year=`date +%Y`
year00=`date +%y`
month=`date +%B`
month00=`date +%m`
day=`date +%d`
hour=`date +%H`
# shots late for 2 hours, usually
let hour=(hour+22)%24
# 
if [ $hour -lt 10 ]; then
	hour="0"$hour
fi
minute=`date +%M`
# add prefix zero if needed
if [ $minute -ge 30 ]; then
   minute="30"
else
   minute="00"
fi
# generate file name
file_name=$year00$month00$day"_"$hour$minute"_original_RGB.jpg"
# generate url of image
image_url=$ftp_site/$year/$month/$day/$hour$minute/$file_name
cd $data_dir
# download image
wget $image_url
background=$year00$month00$day"_"$hour$minute".jpg"
# add time and resize
convert -font Courier $file_name -pointsize 200 -draw "gravity SouthWest fill grey text 0,0 '$hour:$minute $day.$month00.$year' " -resize $resolution $background
# update backgorund
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$monitor/image-path -s $data_dir/$background
# remove original image (~5M)
rm -f $file_name
