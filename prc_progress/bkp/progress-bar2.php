<?Php
//***************************************
// This is downloaded from www.plus2net.com //
/// You can distribute this code with the link to www.plus2net.com ///
//  Please don't  remove the link to www.plus2net.com ///
// This is for your learning only not for commercial use. ///////
//The author is not responsible for any type of loss or problem or damage on using this script.//
/// You can use it at your own risk. /////
//*****************************************
//error_reporting(E_ERROR | E_PARSE | E_CORE_ERROR);
//set_time_limit ( 60 ) ;

require "config.php"; // Database connection details 
//////////////////////////////// Main Code starts /////////////////////////////////////////////

$count=$dbo->prepare("select max(stage) as stage from progress");
if($count->execute()){
$q = $count->fetch(PDO::FETCH_OBJ);
}
///////////////////////////////////////////////
//$width=$_POST['width'];
$width=$q->stage*20;
echo $width;
?>