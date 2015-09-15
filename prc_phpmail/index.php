<?php
// the message
$msg = "First line of text\nSecond line of text";

echo "hej hej hej";

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);


// send email
mail("sd.falahat@gmail.com","My subject",$msg);

?>