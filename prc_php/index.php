<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="myfun.js?<?php echo time(); ?>"></script>
</head>
<body>
<div>
<input type="button" value="send data" id="results"/> 
</div>
<?php 
      for($i=0; $i<1;$i++)
      {
          echo "<br/>";
      }
?>      
<div id="final2"></div>
<?php 
      for($i=0; $i<10;$i++)
      {
          echo "<br/>";
      }
?>      
<div>
<input type="button" value="send data" id="results1"/> 
</div>
<?php 
      for($i=0; $i<1;$i++)
      {
          echo "<br/>";
      }
?>      
<div id="final1"></div>
</body>
</html>
