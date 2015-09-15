#!/bin/bash

files=`ls  *sx`

for ff in ${files};do
    
    fnew=`echo ${ff} | sed s/?[^?]*$//`

    mv ${ff} ${fnew}

done