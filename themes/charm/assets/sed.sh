#!/bin/sh
sed -i \
         -e 's/#171717/rgb(0%,0%,0%)/g' \
         -e 's/#dddddd/rgb(100%,100%,100%)/g' \
    -e 's/#171717/rgb(50%,0%,0%)/g' \
     -e 's/#7571f9/rgb(0%,50%,0%)/g' \
     -e 's/#fffdf5/rgb(50%,0%,50%)/g' \
     -e 's/#000000/rgb(0%,0%,50%)/g' \
	"$@"
