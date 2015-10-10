<?php
ob_start();
$id = (int) $_GET['id'];
$type = $_GET['type'];
if ($id < 1 || ($type != 'replies' && $type != 'topics'))
{
	header('Location: forum.php');
	exit();
}
ob_end_clean();
?>
<html>
<head>
<title>Forum Post</title>
</head>
<body>
<?php
function clear($message)
{
	if(!get_magic_quotes_gpc())
		$message = addslashes($message);
	$message = strip_tags($message);
	$message = htmlentities($message);
	return trim($message);
}
if ($_POST['submit'])
{
	mysql_connect('localhost','username','password');
	mysql_select_db('db');
	$message = clear($_POST['message']);
	$subject = clear($_POST['subject']);
	$poster = clear($_POST['poster']);
	$date = mktime();
	if($type == 'topics')
	{
		$query = mysql_fetch_assoc(mysql_query("SELECT topics FROM main WHERE id = '$id'"));
		$topics = $query['topics'] + 1;
		mysql_query("UPDATE main SET topics = '$topics', lastposter = '$poster', lastpostdate = '$date' WHERE id = '$id'");
		mysql_query("INSERT INTO topics (id , forumid , message , subject, poster, date, lastposter, lastpostdate, replies) VALUES ('', '$id', '$message', '$subject','$poster', '$date', '', '', '0')");
		echo 'Topic Posted.<a href="topics.php?id='.$id.'">View Topic</a>';
	}
	else
	{
		$query = mysql_fetch_assoc(mysql_query("SELECT replies, forumid FROM topics WHERE id = '$id'"));
		$replies = $query['replies'] + 1;
		$id2 =  $query['forumid'];
		mysql_query("UPDATE topics SET replies = '$replies', lastposter = '$poster', lastpostdate = '$date' WHERE id = '$id'");
		$query = mysql_fetch_array(mysql_query("SELECT replies FROM main WHERE id = '$id2'"));
		$replies = $query['replies'] + 1;
		mysql_query("UPDATE main SET replies = '$replies', lastposter = '$poster', lastpostdate = '$date' WHERE id = '$id2'");
		mysql_query("INSERT INTO replies (id , topicid, message, subject, poster, date) VALUES ('', '$id', '$message', '$subject','$poster', '$date')");
		echo 'Reply Posted.<a href="replies.php?id='.$id.'">View Reply</a>';

	}
}
?>
</body>
</html>