<?php
// define variables and set to empty values
$x = $y = "2";


if ($_SERVER["REQUEST_METHOD"] == "GET") {
    
    if (empty($_GET["x"])) {
        
        $nameErr = "x is required";
    }
    else {
        $x = test_input($_GET["x"]);
    }
    
    if (empty($_GET["y"])) {
        
        $nameErr = "y is required";
    }
    else {
        $y = test_input($_GET["y"]);
    }
    
}

$cmd="./pr_sum1.sh" . " " . "$x" . " " . "$y";

#echo "$cmd<br/>";

$outcome = shell_exec("$cmd");

echo $outcome;


function test_input($data) 
{
    
    $data = trim($data);
    
    $data = stripslashes($data);
    
    $data = htmlspecialchars($data);
    
    return $data;
    
}

?>