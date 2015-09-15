#!/bin/bash

export LD_LIBRARY_PATH=/usr/lib:/lib/x86_64-linux-gnu:/usr/lib/nvidia-331:/usr/lib32:/usr/lib/i386-linux-gnu:/opt/MATLAB/bin/glnxa64:/opt/MAT\
LAB/runtime/glnxa64:${LD_LIBRARY_PATH}

/opt/MATLAB/bin/mcc -R -nodisplay -R -nodesktop -R -nosplash -m 'test'
