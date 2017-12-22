function c = terrain (N=64)
[~, txt] = system (sprintf ("python3 -c \"import matplotlib.pyplot as plt;import numpy as np;x = np.linspace(0,1,%d);print (plt.get_cmap(\'terrain\')(x))\"",N));
eval(sprintf ('c = %s(:,1:3);', txt(1:end-1)));
endfunction