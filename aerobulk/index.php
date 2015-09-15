<?php
Header("Cache-Control: no-cache, must-revalidate");
$offset = 60 * 60 * 24 * 1;
$ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";
Header($ExpStr);
?>
<!DOCTYPE HTML>
<html lang="en">
 <head>
     <title>aerobulk</title>

     <meta http-equiv="cache-control" content="no-cache" />
     <meta http-equiv="pragma" content="no-cache" />
     <script type="text/javascript" src="myfun.js?<?php echo time(); ?>"></script>
 </head>
 <body>




























 
 </body>
</html>
