DAT="data"
EXP="ChannelVarQ"

octave s_ChannelVarQ_input

cd ./$DAT/$EXP

for i in $(ls); do
  cd ./$i
  fullswof2d
done



cd ../..
octave s_test_Exp01_output.m
