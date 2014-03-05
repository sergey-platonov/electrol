#!/bin/bash

#usage=\
#"Usage: $(basename $0) [-d <working dir>] [-r <resolution>] [-m <monitor>]\n\
#\tscript updates XFCE wallpaper on specified monitro\n
#params:\n
#\tworking dir\t  - directory where images are downloaded (default value: ~)\n\
#\tresolution\t\t - resolution to which image is beeing resized (default value: 1920x1080)\n\
#\tmonitor\t\t    - number of monitor (default value: 0)\n"

resolution="1920x1080"
monitor=0
data_dir=~

usage=\
"Usage: $(basename $0) -v <version> [-r <buildroot>] [-b <branch>] [-s <serverip>] [-o <outdir>]\n\
\tscript to build given version of qml_app\n
params:\n
\tversion\t\t - software version\n\
\tbuildroot\t - buildroot dir\n
\tbranch\t\t - branch to  clone\n\
\tserver\t\t - ip address of mercurial server\n\
\toutdir\t\t - output directory\n"

while getopts "hr:m:d:" opt; do
  case $opt in
    h)
	  echo $usage
	  exit 1
	  ;;  
    r)
	  resolution=$OPTARG      
	  ;;
    m)
      monitor=$OPTARG     
      ;;
    d)
      data_dir=$OPTARG     
      ;;
    \?)
      echo $usage
      exit
      ;;
  esac
done

export LC_ALL=en_US.UTF-8 
# ELEKTRO-L server
ftp_site=ftp://electro:electro@ftp.ntsomz.ru/
# generating date information
year=`date +%Y`
year00=`date +%y`
month=`date +%B`
month00=`date +%m`
day=`date +%d`
hour=`date +%H -d "2 hour ago"`
minute=`date +%M`
# minutes can be only only 00 or 30
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
