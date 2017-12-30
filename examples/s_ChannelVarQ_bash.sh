
DAT="data"
EXP="ChannelVarQ"

octave s_ChannelVarQ_input

cd ./$DAT/$EXP

for i in $(ls); do
  cd ./$i
  nohup fullswof2d &

  if(( ($i % $(nproc)) == 0))
  then 
    wait; 
  fi
  cd ..
done

