#!/bin/bash

echo "Setting up files for simulation..."
octave s_setsim_ChannelFlat.m

cd data
echo "Starting simulation..."
fswof2d-1.07

cd ..
echo "Reading outputs and generating frames..."
octave s_genframes_ChannelFlat.m

echo "Creating animation..."
convert -delay 100 -loop 0 frames/*.png animation-channelflat.gif
rm -r frames

echo "All done!"
