#!/bin/bash
# Config
image_src=/path_to_image_to_be_centered
name_suffix=$(date +%H-%M-%s)
working_dir=/tmp/screenlock

if [[ ! -f $image_src ]]; then
	echo $image_scr does not exist. Exiting...
	exit 1;
fi

if [[ -e $working_dir ]]; then
	echo $working_dir already exist. Exiting...
	exit 2;
fi

# Beginning of script
mkdir $working_dir 2> /dev/null

# Screen capture
time=$(date +%H-%M-%S)
screen=$working_dir/screen-$name_suffix.png
import -window root $screen

# Final image creation
width_image=$(identify -format %h $image_src)
width_screen=$(identify -format %h $screen)
out_width=$(echo "$width_screen/$width_image*100" | bc -l)
convert \( $screen -blur 0x4 \) \( $image_src -thumbnail $out_width% \) -gravity center -composite $working_dir/final-$name_suffix.png

# Locking screen
physlock -l
i3lock -uni $working_dir/final-$name_suffix.png

# Cleaning
rm -R $working_dir
physlock -L
