<!DOCTYPE HTML>
<html>
 <head>
  <title>PHP Test</title>

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
         
     
     }
     

     function showsum(str) 
     {
    
         if (str=="") {
        
             document.getElementById("shsum").innerHTML="";
        
             return;
        
         }
    
         if (window.XMLHttpRequest) {
        
             // code for IE7+, Firefox, Chrome, Opera, Safari
             xmlhttp=new XMLHttpRequest();
        
         }
         else {
             // code for IE6, IE5
             xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        
         }
    
         xmlhttp.onreadystatechange=function() 
         {
        
             if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                 
                 document.getElementById("shsum").innerHTML=xmlhttp.responseText;
            
             }
        
         }
        
             xmlhttp.open("POST","./show_post.php",true);
    
         xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
         
         xmlhttp.send();
    
     }
     




</script>


 </head>
 <body>
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

<form>

X: <input type="text" name="x" value="" size="10"><br>
Y: <input type="text" name="y" value="" size="10"><br>
<input type="submit" value="Submit" onsubmit="showsum()"/>
</form> 

<p>"We used Ajax technology and the result is as follow"</p><br/>

<div id="shsum" style="border-style:solid; border-width:2px;border-color:black; height:5em; padding:1em;"> </div>

</body>
</html>

