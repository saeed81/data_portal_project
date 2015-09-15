<?php
// define variables and set to empty values                                                                                                            
$x = "";

$fig="";

$myfig = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    


    //$x = $_GET["fig"];
    //    $x = "/tmp/" . $x;
      
    //$message = isset($_GET['message']) ? $_GET['message'] : '';
    
  
        $fig=urldecode($_SERVER['QUERY_STRING']);
        
        $lfig=explode('&',$fig);
        
        //print_r($lfig);
        echo "<br>";
        $nf = 0;
        
        foreach ($lfig as $elm)
        {
            $nfig=explode('=',$elm);
            $myfig[] = "/tmp/" . $nfig[1];
            //echo $myfig[$nf] . "<br>";
            $nf++;
            
        }
        
            
}

/*$arr = array();

$pairs = explode('&', $raw);

         
foreach ($pairs as $i) {
    
    if (!empty($i)) {
        
        list($name, $value) = explode('=', $i, 2);
        
                 
        if (isset($arr[$name]) ) {
            
            if (is_array($arr[$name]) ) {
                
                $arr[$name][] = $value;
                
            }
            else {
                
                $arr[$name] = array($arr[$name], $value);
                
            }
            
        }
        else {
            
            $arr[$name] = $value;
            
        }
        
    }
    
}
*/





?>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" media="screen" href="http://cdnjs.cloudflare.com/ajax/libs/fancybox/1.3.4/jquery.fancybox-1.3.4.css" />
<style type="text/css">
    a.fancybox img {
        border: none;
        
        box-shadow: 0 1px 7px rgba(0,0,0,0.6);
        
        -o-transform: scale(1,1);
        -ms-transform: scale(1,1);
        -moz-transform: scale(1,1);
        -webkit-transform: scale(1,1);
        transform: scale(1,1);
        -o-transition: all 0.2s ease-in-out;
        -ms-transition: all 0.2s ease-in-out;
        -moz-transition: all 0.2s ease-in-out;
        -webkit-transition: all 0.2s ease-in-out;
        transition: all 0.2s ease-in-out;
        
    }
 
a.fancybox:hover img 
{
    
    position: relative;
    z-index: 999;
    -o-transform: scale(1.03,1.03);
    -ms-transform: scale(1.03,1.03);
    -moz-transform: scale(1.03,1.03);
    -webkit-transform: scale(1.03,1.03);
    transform: scale(1.03,1.03);
    
}

</style>
</head>

<body>

<!--<p id="pajax"><?php echo $x?></p>-->


<!--<div id="div1" style="visibility:visible"><img id="myImage" src=<?php echo $x?> alt="Smiley face" width="50%" height="50%"></div>-->

<div ><?php echo $fig ?></div>

<?php 

    foreach ($myfig as $value)
    {
        
        //http://localhost/prc_main/download.php?file
        echo "<div style='visibility:visible'><img class='fancybox' src=$value alt='Smiley face' width='50%' height='50%'></div>" . "<br/>";
        echo "<a href=$value>Click here to zoom figure</a>" . "<br/>";

        echo "<a href=" . "http://localhost/prc_main/download.php?file=" . "/home/saeed" . $value . ">Click here to download your figure</a>";
        
        //echo "<button " . "type=submit " . "formaction=\"http://localhost/prc_main/download.php?file=" . "/home/saeed" . trim("$value") . "\"" . " >Download your figure</button>";
        
        echo "<div style=" . "\"width:300px;height:50px;background-color:gray\"". ">" . "<a href=" . "\"http://localhost/prc_main/download.php?file=" . "/home/saeed" . trim($value) . "\"" . ">Click here to download your figure</a>" . "</div>";
        
    }



?>

<a href="http://localhost/" title="Main page"> Go back to the main page </a>

<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/fancybox/1.3.4/jquery.fancybox-1.3.4.pack.min.js"></script>
<script type="text/javascript">
        $(function($)
        {
            
            var addToAll = false;
            
            var gallery = true;
            
            var titlePosition = 'inside';
            
            $(addToAll ? 'img' : 'img.fancybox').each(function()
            {
                
                var $this = $(this);
                
                var title = $this.attr('title');
                
                var src = $this.attr('data-big') || $this.attr('src');
                
                var a = $('<a href="#" class="fancybox"></a>').attr('href', src).attr('title', title);
                
                $this.wrap(a);
                
            }
            );
            
            if (gallery)
                $('a.fancybox').attr('rel', 'fancyboxgallery');
            
            $('a.fancybox').fancybox(
                {
                    
                    titlePosition: titlePosition
                        });
            
        }
        );

$.noConflict();

</script>


</body>
</html>


