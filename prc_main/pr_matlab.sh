#!/bin/bash

ulimit -s unlimited

export LD_LIBRARY_PATH=/usr/lib:/lib/x86_64-linux-gnu:/usr/lib/nvidia-331:/usr/lib32:/usr/lib/i386-linux-gnu:/opt/MATLAB/bin/glnxa64:/opt/MATLAB/runtime/glnxa64:${LD_LIBRARY_PATH}


ioctave=0
imatlab=1

#taskset -c 0 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 

#rm -f fig01* 

fpath='./' 
fname='/mnt/ramdisk/Full_TEMP.dat' 
fname='Full_TEMP.dat' 
savename="fig01""$$"

###this works awesome for matlab
#/usr/bin/mpirun -n 1 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 


##the following works#
#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot_1 './' './Full_TEMP.dat' 'fig01' 'tif' 'prctile' '3';exit;" &>/dev/null

###the follwing is used for matlab so far 

if [ $imatlab -eq 1 ];then
    /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot_1 "$fpath./" "$fname" "$savename" "tif" "prctile" "3";exit;" &>/dev/null
else
    #/usr/bin/octave -f --no-gui --silent --no-window-system --traditional --eval "graphics_toolkit gnuplot;First_plot_1_octave('$fpath','$fname','$savename');exit;" &>error.dat
    /usr/bin/octave -f -q --no-gui --silent --no-window-system --traditional --eval "graphics_toolkit gnuplot;First_plot_1_octave('./','./Full_TEMP.dat','$savename','png','prctile','3');exit;" &>/dev/null
fi
####

#$octave -qf --no-window-system main.m

#/usr/bin/octave -q -f --no-gui --no-window-system --traditional test_octave.m &>/dev/null


#/usr/bin/octave -f --no-gui --no-window-system --traditional First_plot_octave.m 1>/dev/null 

###/usr/bin/ocatve --no-gui 

#taskset -c 0 ./test   
  
#./test   

#echo "fig01.svg"

#echo "fig01.svg"

#convert fig01.tif fig01.jpg &>/dev/null

convert ${savename}_1.png ${savename}.jpg &>/dev/null

rm -f ${savename}_1.png
 
cp ${savename}.jpg ${savename}_01.jpg
cp ${savename}.jpg ${savename}_02.jpg
cp ${savename}.jpg ${savename}_03.jpg
 
rm ${savename}.jpg  
mv ${savename}_*.jpg /home/saeed/tmp

#echo "fig01.jpg"
#echo "fig01.jpg"
echo "fig=${savename}_01.jpg&fig=${savename}_02.jpg&fig=${savename}_03.jpg"
#echo ${savename}.tif
