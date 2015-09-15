<html>
<head>
<title>Forum</title>
</head>
<body>
<table border="1" cellpadding="4" width="100%">
<tr>
<td>Forum</td>
<td>Number of Topics</td>
<td>Number of Replies</td>
<td>Last Poster</td>
</tr>
<?php
mysql_connect('localhost','username','password');
mysql_select_db('db');
$query1 = mysql_query('SELECT * FROM main ORDER BY id DESC'); 
while ($output1 = mysql_fetch_assoc($query1))
{
	echo '<tr>';
	echo '<td><a href="topics.php?id='.$output1['id'].'">'.$output1['name'].'</a></td>';
	echo '<td>'.$output1['topics'].'</td>';
	echo '<td>'.$output1['replies'].'</td>';
	if (empty($output1['lastposter']))
		echo '<td>No Posts</td>';
	else
		echo '<td>'.$output1['lastposter'].' @ '.date('d-m-y G:i', $output1['lastpostdate']).'</td>';
	echo'</tr>';
}
?>
</table>
</body>
</html>