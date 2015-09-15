<?php

$con = mysql_connect("localhost","saeed","greatfriendfancylife");

if (!$con) {
die('Could not connect: ' . mysql_error());
}

mysql_select_db("chart", $con);

$result = mysql_query("SELECT * FROM `months_days`") or die ("Dadasdad");

while($row = mysql_fetch_array($result)) {
echo $row['months'] . "/" . $row['days']. "/" ;
}

mysql_close($con);
?>