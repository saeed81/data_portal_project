<?Php
require "config.php"; // Database connection details 
$count=$dbo->prepare("delete from progress");
$count->execute();

?>
<html>
<head>
<script type="text/javascript">
function ajaxFunction()
{
var httpxml;
try
  {
  // Firefox, Opera 8.0+, Safari
  httpxml=new XMLHttpRequest();
  }
catch (e)
  {
  // Internet Explorer
  try
    {
    httpxml=new ActiveXObject("Msxml2.XMLHTTP");
    }
  catch (e)
    {
    try
      {
      httpxml=new ActiveXObject("Microsoft.XMLHTTP");
      }
    catch (e)
      {
      alert("Your browser does not support AJAX!");
      return false;
      }
    }
  }
function stateChanged() 
    {
    if(httpxml.readyState==4)
      {
var width=httpxml.responseText;
//alert(width);
document.getElementById("p1").value= width;
document.getElementById("txtHint").innerHTML= width + '% Completed';
      }
    }

var url="progress-bar2.php";
httpxml.onreadystatechange=stateChanged;
httpxml.open("POST", url, true)
httpxml.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
httpxml.send()  
//document.getElementById("txtHint").innerHTML=' Please Wait';
///////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
}

/////////////////////////

function timer(){
ajaxFunction();
setTimeout('timer()',100);
}

</script>
</head>
<body onLoad=timer();>

<progress value="0" max="100" id=p1>0%</progress>

<div id="txtHint"></div>

<br><br>
<?Php
require "progress-bar2-1.php";
?>
<br><br>
<input type=button onClick= window.open("progress-bar2-1.php","Progress","width=550,height=170,left=250,top=200,toolbar=0,status=0,");  value="Start Updating Database">

</body>
</html>