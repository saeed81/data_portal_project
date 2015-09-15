<?php

set_time_limit(0);


$totalItems = 10;


for($i = 0; $i <= $totalItems; $i++){
    

    // some long running code
    
    // sleep 1 second
    usleep(1000*1000);
    

    // write our output file
    file_put_contents(
        'progress.json', 
        json_encode(array('percentComplete'=>$i/$totalItems))
    );
    
}


echo json_encode(array('message'=>"All done"));
                       
exit(0);

?>