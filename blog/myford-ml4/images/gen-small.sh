#!/bin/bash

convert -resize ^750x750 compound-large.jpg compound.jpg 
convert -resize ^750x750 lathe-front-large.jpg lathe-front.jpg
convert -resize ^750x750 slideways-1-large.jpg slideways-1.jpg
convert -resize ^750x750 -rotate 270 slideways-pitting-large.jpg slideways-pitting.jpg
convert -resize ^750x750 headstock-large.jpg headstock.jpg
convert -resize ^750x750 lathe-left-large.jpg lathe-left.jpg
convert -resize ^750x750 slideways-2-large.jpg slideways-2.jpg
convert -resize ^750x750 -rotate 270 tailstock-large.jpg tailstock.jpg