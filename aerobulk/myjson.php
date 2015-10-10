<?php
header("Content-Type: application/json");

//sleep(5);

if(isset($_POST["var1"]) && isset($_POST["var2"]) )
{
    
    $var1 = addslashes($_POST["var1"]);

    $var2 = addslashes($_POST["var2"]);

}

//$jsonData = '{ "obj1":{ "propertyA":"'.$var1.'", "propertyB":"'.$var2.'" } }';

$myvar["propertyA"]=$var1;
$myvar["propertyB"]=$var2;


//echo $jsonData;

//echo json_encode($myvar);


echo json_encode($myvar) . PHP_EOL;

     
//PUSH THE data out by all FORCE POSSIBLE
ob_flush();

flush();


?>