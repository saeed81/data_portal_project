#!/bin/bash

dfol=`ls -d */`

echo ${dfol}

for df in ${dfol};do

    echo ${df}
    
    cp -v -ru ${df} /home/saeed/Dropbox/data_portal/

done

cp -v -u index.php /home/saeed/Dropbox/data_portal
