<?php
$mysqli = new mysqli("localhost", "saeed", "greatfriendfancylife", "my_db");


if ($mysqli->connect_errno) {
    

    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    

}



if (isset($_GET['message'])) {
    


    $user=$mysqli->real_escape_string($_GET['user']);
    

    $message=$mysqli->real_escape_string($_GET['message']);
    

    $date=date('Y-m-d H:i:s');
    


    $sql="INSERT INTO forum(id, user, message, date) VALUES(0,'$user','$message','$date')";
    

    $mysqli->query($sql);
    

}



?>
<?php
$host="davamand.aces.su.se";
$user="saeed";
$password="greatfriendfancylife";

$con = mysqli_connect($host,$user,$password,"","3306");



if (mysqli_connect_errno()) {
    
    printf("Connect failed: %s\n", mysqli_connect_error());
    
    exit();
    
}




if (!$con)
{
    
    die('Could not connect: ' . mysql_error());
    
}

else
{
    
    echo "<br/>Congrats! connection established successfully <br/>";
    
}


if (mysqli_ping($con))
{
    
    echo "Connection is ok! <br/>";
    
}

else
{
    
    echo "Error: ". mysqli_error($con);
    
}


$sdb = mysqli_select_db($con,"itmad");




if (!$sdb) {
    die('Could not connect: ' . mysqli_error());
}

else
{
    
    echo "<br/>Congrats! connection established successfully to database ITMAD <br/>";
    
}

printf("MySQL host info: %s\n", mysqli_get_host_info($con)); 

echo "<br/>";

printf("MySQL host info: %s\n", mysqli_get_client_info($con));

echo "<br/>";

printf("MySQL host info: %s\n", mysqli_get_server_info($con));

echo "<br/>";


//$firstname = 'fred';

//$lastname  = 'fox';


// Formulate Query
// This is the best way to perform an SQL query
// For more examples, see mysql_real_escape_string()
//$query = sprintf("SELECT firstname, lastname, address, age FROM friends 
//    WHERE firstname='%s' AND lastname='%s'",
//                 mysql_real_escape_string($firstname),
//                 mysql_real_escape_string($lastname));


// Perform Query



$result = mysqli_query($con,"SHOW TABLES FROM itmad");


if (!$result) {
    
    echo "DB Error, could not list tables\n";
    
    echo 'MySQL Error: ' . mysqli_error();
    
    exit;
    
}


if ($result)
{
    
    // Return the number of rows in result set
    $rowcount=mysqli_num_rows($result);
    
    printf("Result set has %d rows.\n",$rowcount);
    
}

while ($row = mysqli_fetch_row($result)) {
    
    echo "Table        " . $row[0] . "<br/>";
    
}



mysqli_free_result($result);


$result = mysqli_query($con,"SELECT * FROM users");

$num_rows = mysqli_num_rows($result);


echo $num_rows . "Rows" . "<br/>";


mysqli_free_result($result);


$quer = "Select * FROM " . "users";


echo $quer . "<br/>";


$result = mysqli_query($con,$quer);

while ($row = mysqli_fetch_row($result)) {
    
    echo "user        " . $row[0] . "<br/>";
    
}


//while ($row = mysql_fetch_array($result, MYSQL_NUM)) {
    
//    printf("ID: %s  Name: %s", $row[0], $row[1]);
      
//}


mysqli_close($con);
?>