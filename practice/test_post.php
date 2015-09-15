<?php
// define variables and set to empty values
$x = $y = "2";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    if (empty($_POST["x"])) {
        
        $nameErr = "x is required";
    }
    else {
        $x = test_input($_POST["x"]);
    }
    
    if (empty($_POST["y"])) {
        
        $nameErr = "y is required";
    }
    else {
        $y = test_input($_POST["y"]);
    }
    
}

$cmd="./pr_sum.sh" . " " . "$x" . " " . "$y";

echo "$cmd";

$outcome = shell_exec("$cmd");

echo $outcome . "<br/>";


function test_input($data) 
{
    
    $data = trim($data);
    
    $data = stripslashes($data);
    
    $data = htmlspecialchars($data);
    
    return $data;
    
}

?>