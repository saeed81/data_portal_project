#!/bin/bash

ulimit -s unlimited

export LD_LIBRARY_PATH=/usr/lib:/lib/x86_64-linux-gnu:/usr/lib/nvidia-331:/usr/lib32:/usr/lib/i386-linux-gnu:/opt/MATLAB/bin/glnxa64:/opt/MATLAB/runtime/glnxa64:${LD_LIBRARY_PATH}


ioctave=0
imatlab=1

#taskset -c 0 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r test 1>/dev/null 

#rm -f fig01* 
srandom=`date +%s | sha256sum | base64 | head -c 32`

spath=$$"_""`date +%Y_%m_%d_%H_%M_%S_%N`"

mkdir /home/saeed/tmp/${spath}

touch /home/saeed/tmp/${spath}/note

touch /home/saeed/tmp/${spath}/inputinfo

srcimg="/tmp/${spath}/"

#/home/saeed/DB_ITM/EBAS_routine/matlab_web/DMPS_AUTO_CRUNCH.exe "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}"  

#echo "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" >> /home/saeed/tmp/${spath}/note

echo "${#}" >> /home/saeed/tmp/${spath}/note

for var in ${*};do
    echo $var >> /home/saeed/tmp/${spath}/note
    echo $var >> /home/saeed/tmp/${spath}/inputinfo
done

echo "${#}" >> /home/saeed/tmp/${spath}/note

cp -a DMPS_AUTO_CRUNCH.exe /home/saeed/tmp/${spath}

cp -a analysis.m /home/saeed/tmp/${spath}

cp -a pgrep /home/saeed/tmp/${spath}

cd /home/saeed/tmp/${spath}

./DMPS_AUTO_CRUNCH.exe

#cd -

fpath='./'
fpath="/home/saeed/tmp/${spath}" 
fname='/mnt/ramdisk/Full_TEMP.dat' 
fname='Full_TEMP.dat' 
savename="fig01""$$"
savename="fig""${1}"

###this works awesome for matlab
#/usr/bin/mpirun -n 1 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -singleCompThread -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 

#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot ${fpath} ${fname} ${savename};exit;" 1>/dev/null 


##the following works#
#/opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "First_plot_1 './' './Full_TEMP.dat' 'fig01' 'tif' 'prctile' '3';exit;" &>/dev/null

###the follwing is used for matlab so far 

#nrun=`ps aux | grep MATLAB | grep -v grep | wc -l`;

#nrun=`ps -ef | grep -v grep | grep -c MATLAB`

#nrun=`./pgrep -c MATLAB`

#npr=`ps aux | grep MATLAB | grep -v grep`

#nrun=`echo $npr | wc -l`;

#nrun=`pgrep -c fc.exe`

nrun=`pgrep -c pr_matlab.sh`;

#if [ $nrun -gt 6 ];then
#    exit;
#fi

#nrun=(`pgrep pr_matlab.sh`);

#for i in ${!nrun[*]};do

#    for (( j = $i; j < ${#nrun[*]}; j++ ));do

#        if [ ${nrun[$i]} -lt ${nrun[$j]}  ]; then
#            t=${nrun[$i]}
#            nrun[$i]=${nrun[$j]}
#            nrun[$j]=$t
#        fi
#    done
#done

#echo ${nrun[*]}

#while [ ${#nrun[*]} -gt 5 ];do

#    nrun=(`pgrep pr_matlab.sh`);

#    for i in ${!nrun[*]};do

#        for (( j = $i; j < ${#nrun[*]}; j++ ));do

#            if [ ${nrun[$i]} -lt ${nrun[$j]}  ]; then
#                t=${nrun[$i]}
#                nrun[$i]=${nrun[$j]}
#                nrun[$j]=$t
#            fi
#        done
#    done
#done

if [ $nrun -gt 5 ];then

    nrun1=`pgrep -c pr_matlab.sh`;
    
    while [ $nrun1 -gt 5 ];do
        nrun1=`pgrep -c pr_matlab.sh`;
    done

fi

    ##nrun=`ps aux | grep MATLAB | grep -v grep | wc -l 2>/dev/null`;
    #nrun=`ps -ef | grep -v grep | grep -c MATLAB`
    #npr=`ps aux | grep MATLAB | grep -v grep`

    #nrun=`echo $npr | wc -l`;

    #nrun=`./pgrep -c MATLAB`
    #nrun=`pgrep -c fc.exe`
    #nrun=`pgrep -c pr_matlab.sh`
#    sleep 60;

#fi










#if [ $nrun -gt 5 ];then

    ##nrun=`ps aux | grep MATLAB | grep -v grep | wc -l 2>/dev/null`;
    #nrun=`ps -ef | grep -v grep | grep -c MATLAB`
    #npr=`ps aux | grep MATLAB | grep -v grep`

    #nrun=`echo $npr | wc -l`;

    #nrun=`./pgrep -c MATLAB`
    #nrun=`pgrep -c fc.exe`
    #nrun=`pgrep -c pr_matlab.sh`
#    sleep 60;

#fi


#while [ $nrun -gt 5 ];do

    ##nrun=`ps aux | grep MATLAB | grep -v grep | wc -l 2>/dev/null`;
    #nrun=`ps -ef | grep -v grep | grep -c MATLAB`
    #npr=`ps aux | grep MATLAB | grep -v grep`

    #nrun=`echo $npr | wc -l`;

    #nrun=`./pgrep -c MATLAB`

    
#done



if [ $imatlab -eq 1 ];then
    /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -nosoftwareopengl -r "analysis "$fpath" "$fname" "$savename" "jpg" "prctile" "3";exit;" 1>/dev/null
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

#convert ${savename}_1.png ${savename}.jpg &>/dev/null

#rm -f ${savename}_1.png
 
#cp ${savename}.jpg ${savename}_01.jpg
#cp ${savename}.jpg ${savename}_02.jpg
#cp ${savename}.jpg ${savename}_03.jpg
 
#rm ${savename}.jpg  


#cp ${savename}_*.jpg /home/saeed/tmp !commented

#echo "fig01.jpg"
#echo "fig01.jpg"
echo "srcimg=${srcimg}&fig=${savename}_01.jpg&fig=${savename}_02.jpg&fig=${savename}_03.jpg"
#echo ${savename}.tif
