<?php

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    
    if (isset ($_GET["dr"]) && !empty($_GET["dr"])){
        
        $dirimag = '/tmp/' . $_GET["dr"] . '/';
        
        //$dirimag = '/tmp/25167_2015_09_22_17_52_12_166256387/';

        $dirimagf = '/home/saeed' . $dirimag;

        $images = scandir($dirimagf);
    }
}

?>
<!DOCTYPE html>
<html>
<head>
</head>
<?php
//$images = scandir('/home/saeed/tmp/25167_2015_09_22_17_52_12_166256387/');

if ( is_array($images) ) 
{
    foreach ($images as $key => $value ){
        if ( preg_match("{jpg|png|tif}",strtolower($value))){
            //echo $value . '<br/>';
            $src = $dirimag . $value;
            
            echo "<div style='visibility:visible'><img class='fancybox' src=$src alt='Smiley face' width='50%' height='50%'></div>" . "<br/>";
            
        }
    }
}
?>
</body>
</html>
