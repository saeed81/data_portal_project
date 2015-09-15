#!/bin/bash

echo "I am just checking my web server on cgi functionality<br/>"

echo "<br/>" 

tim=`date`

echo "${tim}" 

echo "<br/>" 

echo "We are executing the fortran code for printing the numbers<br/>" 

echo "<br/>" 

DIRF='/home/saeed/fortran_code'

echo "Here comes the results<br/>" 

echo "<br/>" 

for ji in `seq 1 10`;do

    resl=`${DIRF}/calm.x ${ji}`

    echo "${resl}<br/>"

done

