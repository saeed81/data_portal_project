#!/bin/bash

#echo "We are doing summation using a fortran code <br/>" 

#echo "<br/>" 

DIRF='../fortran_code'

#echo "Here comes the results<br/>" 

#echo "<br/>" 

#resl=`${DIRF}/sum.x "${1}" "${2}"`

resl=`/home/saeed/sum.x "${1}" "${2}"`

echo "${resl}"

#mkdir /home/saeed/tmp/outputfiles

#touch /home/saeed/tmp/outputfiles/somenotes

#touch /home/saeed/somenotes

#cd matlab_files

#nice -10 ionice -c3 /opt/MATLAB/bin/matlab -nodisplay -nodesktop -nosplash -r test 1>/dev/null 

#cp fig01.png ../

#echo "fig01.png"

