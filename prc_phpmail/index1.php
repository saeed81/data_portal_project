 
<?php
$num_to_guess = 42;

$message = "";

if (! isset ( $_POST ['guess'] )) {
    
    $message = "Welcome!";
    
}
else if ($_POST ['guess'] > $num_to_guess) {
    
    $message = $_POST ['guess'] . " is too big!";
    
}
else if ($_POST ['guess'] < $num_to_guess) {
    
    $message = $_POST ['guess'] . " is too small!";
    
}
else {
    
    $message = "Well done!";
    
}

$guess = ( int ) $_POST ['guess'];

$num_tries = ( int ) $_POST ['num_tries'];

$num_tries ++;

  ?>
<html>
<head>
<title>A PHP Number Guessing Script</title>
</head>
<body>
 <?php print $message?>
Guess number: <?php print $num_tries?><br />
<form method="post" action="<?php
print $_SERVER ['PHP_SELF']?>">
<input type="hidden" name="num_tries"
  value="<?php
  print $num_tries?>" /> Type your guess here: <input type="text" name="guess" value="<?php
  print $guess?>" />
</form>
</body>
</html>
  