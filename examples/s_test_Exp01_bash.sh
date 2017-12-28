DAT="data"
EXP="test_Exp01"

octave s_test_Exp01_input.m
cp ./$DAT/exp01_huv.txt ./$DAT/$EXP/Inputs
cp ./$DAT/exp01_rain.txt ./$DAT/$EXP/Inputs
cp ./$DAT/exp01_topography.txt ./$DAT/$EXP/Inputs

cd ./$DAT/$EXP
fullswof2d
