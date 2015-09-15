<?php
Header("Cache-Control: no-cache, must-revalidate");
$offset = 60 * 60 * 24 * 1;
$ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";
Header($ExpStr);
?>

<!DOCTYPE HTML>
<html>
 <head>
  <title>PHP Test</title>
<!--
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
-->
<!--[if lt IE 9]>
<link href="http://wwwimages.adobe.com/www.adobe.com/downloadcenter/singlepage/live/css/ie_fix.css" rel="stylesheet">
<![endif]-->

<link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
<style>
 .dp-highlight .ui-state-default 
{
    
    background: #484;
    color: #FFF;
}

</style>




<script language="javascript" type="text/javascript">

//Browser Support Code
     function ajaxFunction()
     {
         
         var ajaxRequest;
         // The variable that makes Ajax possible!
         
         try{
             
             // Opera 8.0+, Firefox, Safari
             ajaxRequest = new XMLHttpRequest();
             
         }
         catch (e){
             
             // Internet Explorer Browsers
             try{
                 
                 ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
                 
             }
             catch (e) {
                 
                 try{
                     
                     ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                     
                 }
                 catch (e){
                     
                     // Something went wrong
                     alert("Your browser broke!");
                     
                     return false;
                     
                 }
                 
             }
             
         }
         
     
         ajaxRequest.onreadystatechange=function() 
         {
        
             if (ajaxRequest.readyState==4 && ajaxRequest.status==200) {
                 
                 document.getElementById("shsum").innerHTML=ajaxRequest.responseText;
            
             }
        
         }
        
             var vnum1 = document.getElementById('num1').value;
         
         var vnum2 = document.getElementById('num2').value;
         
         //var sex = document.getElementById('sex').value;
         
         //var queryString = "?age=" + age + "&wpm=" + wpm + "&sex=" + sex;
         
         //ajaxRequest.open("GET", "ajax-example.php" + queryString, true);
         
         //ajaxRequest.send(null);
          
         //var strsnd= "?x=" + vnum1 + "&y=" + vnum2;
         
         var strsnd= "x=" + vnum1 + "&y=" + vnum2;
         
         //ajaxRequest.open("GET","./show_get.php" + strsnd,true);
    
         ajaxRequest.open("POST","./show_post.php",true);
    
         ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
         
         //ajaxRequest.send();
    
        ajaxRequest.send(strsnd);
    

     }
     
     
</script>


 </head>
 <body>

<div id="datepicker"></div>
<p>
    Dates:
    <input type="text" id="input1" size="10">
    <input type="text" id="input2" size="10">
    </p>
    <script>
        /*
         * jQuery UI Datepicker: Using Datepicker to Select Date Range
         * http://salman-w.blogspot.com/2013/01/jquery-ui-datepicker-examples.html
         */
        $(function() {
        $("#datepicker").datepicker({
        beforeShowDay: function(date) {
        var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input1").val());
        var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input2").val());
        return [true, date1 && ((date.getTime() == date1.getTime()) || (date2 && date >= date1 && date <= date2)) ? "dp-highlight" : ""];
        },
        onSelect: function(dateText, inst) {
        var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input1").val());
        var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input2").val());
        if (!date1 || date2) {
        $("#input1").val(dateText);
        $("#input2").val("");
        $(this).datepicker("option", "minDate", dateText);
        } else {
        $("#input2").val(dateText);
        $(this).datepicker("option", "minDate", null);
        }
        }
        });
        });
    </script>
        





<?php 
echo '<p>Hello World</p>';
?> 

<?php 
echo '<p>Testing bash scripting</p>';
?> 

<?php
echo "Hostname: ". @php_uname(n) ."<br/>";

if (function_exists( 'shell_exec' )) {
    
    echo "Hostname: ". @gethostbyname(trim(`hostname`)) . "<br/>";
    
}
else {
    
    echo "Server IP: ". $_SERVER['SERVER_ADDR'] . "<br/>";
    
}

echo "Platform: ". @php_uname(s) ." ". @php_uname(r) ." ". @php_uname(v) ."<br/>";

echo "Architecture: ". @php_uname(m) ."<br/>";

echo "Username: ". get_current_user () ." ( UiD: ". getmyuid() .", GiD: ". getmygid() ." )<br/>";

echo "Curent Path: ". getcwd () ."<br/>";

echo "Server Type: ". $_SERVER['SERVER_SOFTWARE'] . "<br/>";

echo "Server Admin: ". $_SERVER['SERVER_ADMIN'] . "<br/>";

echo "Server Signature: ". $_SERVER['SERVER_SIGNATURE'] ."<br/>";

echo "Server Protocol: ". $_SERVER['SERVER_PROTOCOL'] ."<br/>";

echo "Server Mode: ". $_SERVER['GATEWAY_INTERFACE'] ."<br/>";

?>

<?php
// What headers are to be sent?
echo "These are the header information"."<br/>";

var_dump(headers_list());

echo "<br/>";

?>

<?php

$cmd="./test.sh";

$outcome=shell_exec("./test.sh");

echo $outcome;

?>

<!-- <form method="get" action="./test_get.php" target="_self">

X: <input type="text" name="x" value="" size="10"><br>
Y: <input type="text" name="y" value="" size="10"><br>
<input type="submit" value="Submit"/>
</form> -->

<br/>

<form id="clform">

X: <input type="text" name="x" id='num1' value="" autocomplete="off" size="10" required><br>
Y: <input type="text" name="y" id='num2' value="" autocomplete="off" size="10"><br>
<input type="button" value="Calculated sum" onclick="ajaxFunction()"/>
</form> 

<script type="text/javascript">
    document.getElementById("clform").reset();
</script>

<p>"We used Ajax technology and the result is as follow"</p><br/>

<div id="shsum" style="border-style:solid; border-width:2px;border-color:black; height:5em; padding:1em;"> </div>

</body>
</html>

