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
<title>Topics</title>
</head>
<body>
<?php
mysql_connect('localhost','username','password');
mysql_select_db('db');
$output1 = mysql_fetch_assoc(mysql_query("SELECT name FROM main WHERE id = $id"));
echo $output1['name'];
?>
<table border="1" cellpadding="4" width="100%">
<tr>
<td>Topic</td>
<td>Made by</td>
<td>Date</td>
<td>Last poster</td>
<td>Replies</td>
</tr>
<?php
$query2 = mysql_query("SELECT * FROM topics WHERE forumid = '$id' ORDER BY id DESC");
$query3 = mysql_num_rows($query2);
if ($query3 == 0)
	echo '<td colspan="5">No Topics</td>';
else
{
	while ($output2 = mysql_fetch_assoc($query2))
	{
		echo '<tr>';
		echo '<td><a href="replies.php?id='.$output2['id'].'">'.$output2['subject'].'</a></td>';
		echo '<td>'.$output2['poster'].'</td>';
		echo '<td>'.date('D-m-y G:i', $output2['date']).'</td>';
		if(empty($output2['lastposter']))
			echo '<td colspan="2">No replies</td>';
		else
		{
			echo '<td>'.$output2['lastposter'].' @ '.date('d-m-y G:i', $output2['lastpostdate']).'</td>';
			echo '<td>'.$output2['replies'].'</td>';
		}
		echo '</tr>';
	}
}
?>
</table>
<hr />
<form name="form1" id="form1" method="post" action="forumpost.php?type=topics&id=<? echo $id; ?>">
Add Topic<br />
<input name="subject" id="subject" type="text" value="Topic name" /><br />
<textarea name="message" id="message" cols="30" rows="5">Message</textarea><br />
<input name="poster" id="poster" type="text" value="Username" /><br />
<input type="submit" name="submit" id="submit" value="Submit" />
</form>
</body>
</html>