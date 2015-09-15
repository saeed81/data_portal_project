<!DOCTYPE html">
<head>
<meta charset=utf-8" />
<title>PHP and MySql</title>
</head>

<body>
<h2>My First Forum</h2>

<?
    $sql = "SELECT * FROM forum";

$result = $mysqli->query($sql);


while($row = $result->fetch_assoc()) {
    
    echo $row['user'].',  '.$row['date'].' <br />';
    
    echo $row['message'].'<br />';
    
    echo '------------------------ <br />';
    
}

?>

<form method="get" action="forum.php">
<p>User:
<label for="user"></label>
  <input type="text" name="user" id="user" />
  <br />
</p>
<p>Message: <br />
  <label for="message"></label>
  <textarea name="message" id="message" cols="45" rows="5"></textarea>
</p>
<p>
  <input type="submit" name="submit" id="submit" value="Post message" />
</p>
</form>

</body>
</html>
