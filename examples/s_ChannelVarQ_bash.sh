
DAT="data"
EXP="ChannelVarQ"

octave s_ChannelVarQ_input.m

cd ./$DAT/$EXP

for i in $(ls); do
  cd ./$i
  nohup fswof2d &

  if(( ($i % $(nproc)) == 0))
  then 
    wait; 
  fi
  cd ..
done

