<?php
require_once('configmsgbrd.php');

$u = escape_data($_POST["user_id"]);
$tid = escape_data($_POST["topic_id"]);
$mt = escape_data($_POST["comment"]);
$pid = escape_data($_POST["parent_id"]);
$mb = escape_data($_POST["mess_block"]);
$token = escape_data($_POST["token_id"]);

$query1 = "SELECT user_id, tokenid FROM users WHERE (user_id='$u') AND (tokenid='$token')";

$result2 = mysql_query ($query1) or trigger_error("An Error Occurred");

if (mysql_affected_rows() == 1) {

	$query2 = "INSERT INTO message (user_id, topic_id, message_txt, date, parent_id, mess_block) VALUES ('$u', '$tid', '$mt', NOW(), '$pid', '$mb')";			

	$result2 = mysql_query ($query2) or trigger_error("An Error Occurred");
	
	echo "Comment Has Been Submitted";
	exit();
	mysql_close();

} else {
	echo "Comment Has Been Declined";
	exit();
	mysql_close();
}
?>