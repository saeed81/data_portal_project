<?php
// define variables and set to empty values
$x = $y = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    

    if (empty($_POST["x"])) {
        

       $nameErr = "x is required";
        
    }
    
   else {
        
       $x = test_input($_POST["x"]);
        
    }
    

    
}







$arg1="pallas_20090101_201201_integrated_hourly_300nm_800nm";


$cmd="./pr_matlab.sh " . trim("$arg1");

$outcome = shell_exec("$cmd");

//echo "$outcome<br/>";

echo urlencode(trim("$outcome"));


function test_input($data) 
{
    
    $data = trim($data);
    
    $data = stripslashes($data);
    
    $data = htmlspecialchars($data);
    
    return $data;
    
}

?>