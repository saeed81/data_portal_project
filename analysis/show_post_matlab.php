<?php
// define variables and set to empty values
$vstn = $fdate = $edate = $vsize = $vlog = $vtime = $rmin = $rmax = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    if (empty($_POST["vstn"])) {

       $vstn = "station is required";

       echo $vstn;
        
    }
    
   else {
        
       $vstn = test_input($_POST["vstn"]);
        
    }
    
    if (empty($_POST["fdate"])) {
        

       $fdate = "first date is required";

       echo $fdate;
       
        
    }
    
   else {
        
       $fdate = test_input($_POST["fdate"]);
        
    }
    
if (empty($_POST["edate"])) {
        

       $edate = "end date is required";

       echo $edate;
       
        
    }
    
   else {
        
       $edate = test_input($_POST["edate"]);
        
    }
    
if (empty($_POST["vsize"])) {
        

       $vsize = "size resolved is required";

       echo $vsize;
       
        
    }
    
   else {
        
       $vsize = test_input($_POST["vsize"]);
        
    }
    
    if (empty($_POST["vlog"])) {
        

       $vlog = "moment  is required";

       echo $vlog;
       
        
    }
    
   else {
        
       $vlog = test_input($_POST["vlog"]);
        
    }
    if (empty($_POST["vlog"])) {
        

       $vlog = "moment is required";

       echo $vlog;
       
        
    }
    
   else {
        
       $vlog = test_input($_POST["vlog"]);
        
    }
    if (empty($_POST["vtime"])) {
        

       $vtime = "time resolution is required";

       echo $vtime;
       
        
    }
    
   else {
        
       $vtime = test_input($_POST["vtime"]);
        
    }
    if (empty($_POST["rmin"])) {
        

       $rmin = "min value is required";

       echo $rmin;
       
        
    }
    
   else {
        
       $rmin = test_input($_POST["rmin"]);
        
    }
    
    if (empty($_POST["rmax"])) {
        

       $rmax = "max value is required";

       echo $rmax;
       
        
    }
    
   else {
        
       $rmax = test_input($_POST["rmax"]);
        
    }
    
}


//$vstn = $fdate = $edate = $vsize = $vlog = $vtime = $rmin = $rmax = "";


//$arg1="pallas_20090101_201201_integrated_hourly_300nm_800nm";

$arg1= $vstn . " " . $fdate . " " . $edate . " " . $vsize . " " . $vlog . " " . $vtime . " " . $rmin . " " . $rmax;

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