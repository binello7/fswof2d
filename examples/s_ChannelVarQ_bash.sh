
DAT="data"
EXP="ChannelVarQ"

octave s_ChannelVarQ_input.m

cd ./$DAT/$EXP

for i in $(ls); do
  cd ./$i
  fswof2d
  cd .. 

  if(( ($i % $(nproc)) == 0));
  then wait; fi
done
