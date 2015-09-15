<?php
// define variables and set to empty values
$x = $y = "";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    if (empty($_POST["x"])) {
        
        $nameErr = "x is required";
        echo $nameErr . "<br/>";
        
    }
    else {
        $x = test_input($_POST["x"]);
    }
    
    if (empty($_POST["y"])) {
        
        $nameErr = "y is required";
        echo $nameErr . "<br/>";
        
    }
    else {
        $y = test_input($_POST["y"]);
    }
    
}

#$cmd="./pr_sum1.sh" . " " . "$x" . " " . "$y";

#echo "$cmd<br/>";

#$outcome = shell_exec("$cmd");

#echo $outcome;

echo " " . "$x" . " " . "$y";

function test_input($data) 
{
    
    $data = trim($data);
    
    $data = stripslashes($data);
    
    $data = htmlspecialchars($data);
    
    return $data;
    
}

?>