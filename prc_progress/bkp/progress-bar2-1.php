<?Php
//***************************************
// This is downloaded from www.plus2net.com //
/// You can distribute this code with the link to www.plus2net.com ///
//  Please don't  remove the link to www.plus2net.com ///
// This is for your learning only not for commercial use. ///////
//The author is not responsible for any type of loss or problem or damage on using this script.//
/// You can use it at your own risk. /////
//*****************************************
error_reporting(E_ERROR | E_PARSE | E_CORE_ERROR);
set_time_limit ( 60 ) ;
require "config.php"; // Database connection details 
/////////////// Main Code starts ///////////////////
////////////// Delete all records //////
$delay=3;
$count=$dbo->prepare("delete from progress");
$count->execute();
echo "All records deleted<br>";
//flush();
//ob_implicit_flush(true);
ob_flush();
flush();
/////////////////
sleep($delay);
$sql=$dbo->prepare("insert into progress (stage) values(1)");
if($sql->execute()){
echo "Stage one over <br>";
}
else{
print_r($sql->errorInfo()); 
}
flush();
////////////////////
sleep($delay);
$sql=$dbo->prepare("insert into progress (stage) values(2)");
if($sql->execute()){
echo "Stage two over <br>";
}
else{
print_r($sql->errorInfo()); 
}
flush();
////////////////////
sleep($delay);
$sql=$dbo->prepare("insert into progress (stage) values(3)");
if($sql->execute()){
echo "Stage three over <br>";
}
else{
print_r($sql->errorInfo()); 
}
flush();
////////////////////
////////////////////
sleep($delay);
$sql=$dbo->prepare("insert into progress (stage) values(4)");
if($sql->execute()){
echo "Stage four over <br>";
}
else{
print_r($sql->errorInfo()); 
}
flush();
////////////////////
////////////////////
sleep($delay);
$sql=$dbo->prepare("insert into progress (stage) values(5)");
if($sql->execute()){
echo "Stage five over <br>";
}
else{
print_r($sql->errorInfo()); 
}
flush();
////////////////////
//echo "All updation Over";

?>