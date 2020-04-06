#!/bin/bash

echo "Setting up files for simulation..."
octave s_setsim_ChannelConstQ.m

cd data
echo "Starting simulation..."
fswof2d-1.07

cd ..
echo "Reading outputs and generating frames..."
octave s_genframes_ChannelConstQ.m

echo "Creating animation..."
convert -delay 100 -loop 0 frames/*.png animation-constQ.gif
rm -r frames

echo "All done!"
