#!/bin/sh

param="-size 184x142 xc:white -strokewidth 2.5"
rings="translate 2 2 fill none stroke black circle 27.0,27.0 40.75,27.0 circle 27.0,69.0 40.75,69.0 circle 27.0,111.0 40.75,111.0 circle 69.0,27.0 82.75,27.0 circle 69.0,69.0 82.75,69.0 circle 69.0,111.0 82.75,111.0 circle 111.0,27.0 124.75,27.0 circle 111.0,69.0 124.75,69.0 circle 111.0,111.0 124.75,111.0 circle 153.0,27.0 166.75,27.0 circle 153.0,69.0 166.75,69.0 circle 153.0,111.0 166.75,111.0 "
round="5 5"
grp="fill none stroke grey35"
rows="roundrectangle 1.0,9.0 179.0,45.0 $round roundrectangle 1.0,51.0 179.0,87.0 $round roundrectangle 1.0,93.0 179.0,129.0 $round"
cols="roundrectangle 9.0,1.0 45.0,137.0 $round roundrectangle 51.0,1.0 87.0,137.0 $round roundrectangle 93.0,1.0 129.0,137.0 $round roundrectangle 135.0,1.0 171.0,137.0 $round"

convert $param -draw "$rings" 3x4-none-noframe.png
convert $param -draw "$rings $grp $cols" 3x4-col-noframe.png
convert $param -draw "$rings $grp $rows" 3x4-row-noframe.png
convert $param -draw "$rings $grp $cols $rows" 3x4-row+col-noframe.png

convert -size 192x150 xc:white -fill none -stroke '#966' -strokewidth 4 -draw 'rectangle 0 0 191 149' 3x4-none-frame.png
convert 3x4-none-frame.png 3x4-none-noframe.png -gravity center -composite 3x4-none.png
convert -size 192x150 xc:white -fill none -stroke '#336' -strokewidth 4 -draw 'rectangle 0 0 191 149' 3x4-col-frame.png
convert 3x4-col-frame.png 3x4-col-noframe.png -gravity center -composite 3x4-col.png
convert -size 192x150 xc:white -fill none -stroke '#366' -strokewidth 4 -draw 'rectangle 0 0 191 149' 3x4-row-frame.png
convert 3x4-row-frame.png 3x4-row-noframe.png -gravity center -composite 3x4-row.png
convert -size 192x150 xc:white -fill none -stroke '#993' -strokewidth 4 -draw 'rectangle 0 0 191 149' 3x4-row+col-frame.png
convert 3x4-row+col-frame.png 3x4-row+col-noframe.png -gravity center -composite 3x4-row+col.png

/bin/rm *frame.png
