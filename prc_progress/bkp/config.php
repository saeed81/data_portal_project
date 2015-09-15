<?Php
////// Your Database Details here /////////
$dbhost_name = "localhost";
$database = "sql_tutorial";  // Your database name
$username = "root";                  //  Login user id 
$password = "test";                  //   Login password

////////////////////////////////////////
////// DONOT EDIT BELOW  /////////
///////////////////////////////////////

//////// Do not Edit below /////////
try {
$dbo = new PDO('mysql:host=localhost;dbname='.$database, $username, $password);
} catch (PDOException $e) {
print "Error!: " . $e->getMessage() . "<br/>";
die();
}
?>