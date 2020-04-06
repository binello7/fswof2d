#!/bin/bash
# Automatically generated on 2020-04-06 16:06:22

cd data
for i in {1..25}; do
  id=`printf _%02d $i`
  nohup fswof2d-1.07 -f parameters$id.txt &
  if(( ($i % $(nproc)) == 0)); then wait; fi
done
