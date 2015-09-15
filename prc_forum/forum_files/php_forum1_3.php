<?php
ob_start();
$id = (int) $_GET['id'];
if ($id < 1)
{
	header('Location: forum.php');
	exit();
}
ob_end_clean();
?>
<html>
<head>
<title>Replies</title>
</head>
<body>
<table border="1" cellpadding="4" width="100%">
<?php
mysql_connect('localhost','username','password');
mysql_select_db('db');
$query1 = mysql_query("SELECT * FROM replies WHERE topicid = $id ORDER BY id ASC");
$query2 = mysql_num_rows($query1);
$output2 = mysql_fetch_assoc(mysql_query("SELECT * FROM topics WHERE id = $id"));
echo '<tr><td>'.$output2['subject'].' - Posted by <strong>'.$output2['poster'].'</strong></td>';
echo '<td>'.date('D-m-y G:i', $output2['date']).'</td></tr>';
echo '<tr><td colspan="2">'.$output2['message'].'</td></tr>';
echo '<tr><td colspan="2">&nbsp;</td></tr>';
if ($query2 == 0)
	echo '<td colspan="2">No Replies</td>';
else
{
	while ($output = mysql_fetch_assoc($query1))
	{
		echo '<tr><td>'.$output['subject'].'</td><td>'.date('d-m-y G:i', $output['date']).'</td></tr>';
		echo '<tr><td colspan="2">'.$output['message'].'<br /><strong>Posted by '.$output['poster'].'</strong></td></tr>';
	}
}
?>
</table>
<hr />
<form name="form1" id="form1" method="post" action="forumpost.php?type=replies&id=<? echo $id; ?>">
Add Reply<br />
<input name="subject" id="subject" type="text" value="Reply Subject" /><br />
<textarea name="message" id="message" cols="30" rows="5">Message</textarea><br />
<input name="poster" id="poster" type="text" value="Username" /><br />
<input type="submit" name="submit" id="submit" value="Submit" />
</form>
</body>
</html>