#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#ee6ff8/g' \
         -e 's/rgb(100%,100%,100%)/#171717/g' \
    -e 's/rgb(50%,0%,0%)/#171717/g' \
     -e 's/rgb(0%,50%,0%)/#7571f9/g' \
 -e 's/rgb(0%,50.196078%,0%)/#7571f9/g' \
     -e 's/rgb(50%,0%,50%)/#dddddd/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#dddddd/g' \
     -e 's/rgb(0%,0%,50%)/#171717/g' \
	"$@"
