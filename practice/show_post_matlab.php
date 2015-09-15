<?php
// define variables and set to empty values
$x = $y = "";

//if ($_SERVER["REQUEST_METHOD"] == "POST") {
    

//    if (empty($_POST["x"])) {
        

//        $nameErr = "x is required";
        
//    }
    
//    else {
        
//        $x = test_input($_POST["x"]);
        
//    }
    

    
//}









$cmd="./pr_matlab.sh";

$outcome = shell_exec("$cmd");

//echo "$outcome<br/>";

echo "$outcome";


function test_input($data) 
{
    
    $data = trim($data);
    
    $data = stripslashes($data);
    
    $data = htmlspecialchars($data);
    
    return $data;
    
}

?>