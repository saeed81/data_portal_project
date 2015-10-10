# redirectingSites.php
<?php 
if(isset($_POST['submit_button'])) {
    
    $site_to_visit = $_POST['site'];
    
    $self = $_SERVER['PHP_SELF'];
    

    if( $site_to_visit != null )
    {
        
        header( "Location:$site_to_visit") ;
        
        exit();
        
    }
    
}

?>

<html>
 <head><title>Redirect</title></head>

 <body>
Choose a site to visit:
  <form action = "<?php $self ?>" method = "post">
   <select name = "site">
   <option value = "http://www.bogotobogo.com">Web Animation</option>
    <option value = "http://en.wikipedia.org/wiki/PHP">PHP - Wikipedia, the free encyclopedia</option>
   <option value = "http://www.apache.org">The Apache Software Foundation</option>
   <option value = "http://www.mysql.com">MySQL</option>
   <option value = "http://www.linux.org">The Linux Home Page</option>
   <option value = "http://www.pbase.com/dbh/soraksan">Mt.Sorak National Park </option>
   <input type = "submit" name = "submit_button" value = "Go">
  </form>

 </body>
</html>