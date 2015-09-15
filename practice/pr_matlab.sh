#!/bin/bash

ulimit -s unlimited

export LD_LIBRARY_PATH=/usr/lib:/lib/x86_64-linux-gnu:/usr/lib/nvidia-331:/usr/lib32:/usr/lib/i386-linux-gnu:/opt/MATLAB/bin/glnxa64:/opt/MATLAB/runtime/glnxa64:${LD_LIBRARY_PATH}


#taskset -c 0 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 


fpath='./' 
fname='/mnt/ramdisk/Full_TEMP.dat' 
savename='fig01'

###this works awesome for matlab
#/usr/bin/mpirun -n 1 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 



/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot_1 './' '/mnt/ramdisk/Full_TEMP.dat' 'fig01' 'tif' 'prctile' '3';exit;" &>/dev/null

#/usr/bin/octave -q -f --no-gui --no-window-system --traditional test_octave.m &>/dev/null


#/usr/bin/octave -f --no-gui --no-window-system --traditional First_plot_octave.m 1>/dev/null 

###/usr/bin/ocatve --no-gui 

#taskset -c 0 ./test   
  
#./test   

#echo "fig01.svg"

#echo "fig01.svg"

convert fig01_1.tif fig01.jpg &>/dev/null


#echo "fig01.jpg"
echo "fig01.jpg"
