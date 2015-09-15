#!/bin/bash

echo "We are doing summation using a fortran code <br/>" 

echo "<br/>" 

DIRF='/home/saeed/davamand/fortran_code'

echo "Here comes the results<br/>" 

echo "<br/>" 

resl=`${DIRF}/sum.x "${1}" "${2}"`

echo "${resl}<br/>"
