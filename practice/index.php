<?php
Header("Cache-Control: no-cache, must-revalidate");
$offset = 60 * 60 * 24 * 1;
$ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";
Header($ExpStr);
?>

<!DOCTYPE HTML>
<html lang="en">
 <head>
  <title>PHP Test</title>
<!--
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
-->

<link type="text/css" rel="stylesheet" href="../css/layout_practice.css">
<!--<link type="text/css" rel="stylesheet" href="../css/template_files/bootstrap.css">-->


<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.5.0/pure-min.css">




<!--[if lt IE 9]>
<link href="http://wwwimages.adobe.com/www.adobe.com/downloadcenter/singlepage/live/css/ie_fix.css" rel="stylesheet">
<![endif]-->

  <!--<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
-->

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>


  
  
<!--
<link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
-->
<!--<style>
 .dp-highlight .ui-state-default 
{
    
    background: #484;
    color: #FFF;
}

</style>
-->


<style>

#iddate 
{

    width: 250px;
    height: 150px;
}



#iddate label 
{
    display: block;
    width: 100px;
    float: left;
    clear:both;
    text-align:right;
    height:15px;
    
    
        
}

#iddate input {
height:15px;
margin-left:5px;

}

#iddate #idbutn{
height:20px;
margin-left:5px;

}


</style>



<!--<script>
$(document).ready(function(){
    $("#datepicker1").datepicker({
            appendText:"(yy-mm-dd)",
                changeMonth:true,
                changeYear:true,
                yearRange:"-100:+0",
                dateFormat:"yy-mm-dd"});
        $("#datepicker2").datepicker({
                appendText:"(yy-mm-dd)",
                    changeMonth:true,
                    changeYear:true,
                    yearRange:"-100:+0",
                    dateFormat:"yy-mm-dd",
                    });
});
    </script>

-->

<script>
$(document).ready(function(){
    $("#datepicker1").datepicker({
                changeMonth:true,
                changeYear:true,
                yearRange:"-100:+0",
                dateFormat:"yy-mm-dd"});
        $("#datepicker2").datepicker({
                   changeMonth:true,
                    changeYear:true,
                    yearRange:"-100:+0",
                    dateFormat:"yy-mm-dd",
                    });
});
    </script>







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

                 //document.getElementById("shfig").alt=ajaxRequest.responseText;


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


//


<script language="javascript" type="text/javascript">

//Browser Support Code
     function ajaxMatlab()
     {
         

         window.alert('your figure will be ready soon. Close this prompt box to get your figure in no time')

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

                                

                  //document.getElementById("shsum").innerHTML=ajaxRequest.responseText;

                  document.getElementById("shfig").src=ajaxRequest.responseText;

                  
                  //document.getElementById("shfig").style.position='absolute';


                  document.getElementById("shfig").style.width='75%';



                  document.getElementById("shfig").style.height='75%';


             }
        
         }
        
             //     var vnum1 = document.getElementById('num1').value;
         
             //var vnum2 = document.getElementById('num2').value;
         
         //var sex = document.getElementById('sex').value;
         
         //var queryString = "?age=" + age + "&wpm=" + wpm + "&sex=" + sex;
         
         //ajaxRequest.open("GET", "ajax-example.php" + queryString, true);
         
         //ajaxRequest.send(null);
          
         var strsnd= "x=" + "";
         
         //var strsnd= "x=" + vnum1 + "&y=" + vnum2;
         
         //ajaxRequest.open("GET","./show_get.php" + strsnd,true);
    
         ajaxRequest.open("POST","./show_post_matlab.php",true);
    
         ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
         
         //ajaxRequest.send();
    
        ajaxRequest.send(strsnd);
    

     }
     
     
</script>


//





<script language="javascript" type="text/javascript">

//Browser Support Code
     function ajaxdatepicker()
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
                 
                 document.getElementById("jqdate").innerHTML=ajaxRequest.responseText;
            
             }
        
         }
        
             var vnum1 = document.getElementById('datepicker1').value;
         
         var vnum2 = document.getElementById('datepicker2').value;
         
         var sdate="";
         if (vnum1 == sdate) 
         {
            alert("please choose a start date");

            document.getElementById('datepicker1').focus() ;
            
           } 

        if (vnum2 == sdate)
        {
             alert("please choose a end date");
         }
 
          //var sex = document.getElementById('sex').value;
         
         //var queryString = "?age=" + age + "&wpm=" + wpm + "&sex=" + sex;
         
         //ajaxRequest.open("GET", "ajax-example.php" + queryString, true);
         
         //ajaxRequest.send(null);
          
         //var strsnd= "?x=" + vnum1 + "&y=" + vnum2;
         
         var strsnd= "x=" + vnum1 + "&y=" + vnum2;
         
         //ajaxRequest.open("GET","./show_get.php" + strsnd,true);
    
         ajaxRequest.open("POST","./show_post_date.php",true);
    
         ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
         
         //ajaxRequest.send();
    
        ajaxRequest.send(strsnd);
    

     }
     
     
</script>










 </head>
 <body>


     <div id="iddate">
  <label for="datepicker1"><b>Start date:</b></label>
      <input type="text" id="datepicker1" value="" autocomplete="off" size="12">
    <label for="datepicker2"><b>End  date:</b></label><input type="text" id="datepicker2" value=""  autocomplete="off" size="12">
      <label for="idstation"><b>Station: </b></label>
<select name="station" id="idstation">
   <option value="-1" selected>[Choose Station]</option>
   <option value="1">Pallas</option>
   <option value="2">Zepellin</option>
    </select>
    <input type="button" id="idbutn" value="Search" onclick="ajaxdatepicker()"/>
    </div>

    
    <!--<script>
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
    </script>-->
        





<?php 
echo '<p>Hello World</p>';
?> 

<?php 
echo '<p>Testing bash scripting</p>';
?> 

<!-- <form method="get" action="./test_get.php" target="_self">

X: <input type="text" name="x" value="" size="10"><br>
Y: <input type="text" name="y" value="" size="10"><br>
<input type="submit" value="Submit"/>
</form> -->

<br/>

<form id="clform">

<p class="xyinput">X:</p> <input type="text" name="x" id='num1' value="" autocomplete="off" size="10" required><br>
<p class="xyinput">Y:</p> <input type="text" name="y" id='num2' value="" autocomplete="off" size="10"><br>
<input class="butsum" type="button" value="Calculated sum" onclick="ajaxFunction()"/>
<input type="reset" value="Reset" onclick="myfunc();"/>

</form> 

<!--<script type="text/javascript">
    document.getElementById("clform").reset();
</script>-->

<script type="text/javascript">
    function myfunc()
    {

        document.getElementById("shsum").innerHTML = "";
   
    }

</script>



<p>"We used Ajax technology and the result is as follow"</p>

<div id="shsum" style="border-style:solid; border-width:4px;border-color:red; height:10%; width:10%;padding:1em;"> </div><br/><br/>


<input class="butsum" type="button" value="showmyfigure" onclick="ajaxMatlab()"/>



<?php

    require_once("./db_script/db.php");

?>
    

<div style="border-style:solid; border-width:4px;border-color:green height:50%; width:50%;padding:1em;display:block;float:center;margin-right:auto;margin-left:auto;text-align:center"><img id="shfig" src="smiley.gif" alt='nothing'>
</div>
<p>"We used Ajax technology and jquery datepicker"</p>

<div id="jqdate" style="border-style:solid; border-width:4px;border-color:red; height:10%; width:10%;padding:1em;"> </div>



</body>
</html>

