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

    <link type="text/css" rel="stylesheet" href="layout.css?<?php $str = 'Gffriend';echo sha1($str);?>">

    </head>
 <body>

<!-- analysis box -->
 <div id="iddate">
  <label for="idstation"><b>Station: </b></label>
  <select name="station" id="idstation" onchange="showMark();">
   <option value="1" selected="selected" >Hyytiala</option>
   <option value="2">Melpitz</option>
   <option value="3">Aspvreten</option>
   <option value="4">Pallas</option>
   <option value="5">Zeppelin</option>
  </select>
   <label for="datepicker1"><b>Start date:</b></label>
  <input type="text" id="datepicker1" value="" autocomplete="off" size="12" required>
  <label for="datepicker2"><b>End date:</b></label><input type="text" id="datepicker2" value=""  autocomplete="off" size="12" required>
  <label for="idsize"><b>Integrated or size resolved: </b></label>
  <select name="idsize" id="idsize" onchange="disminmax();">
   <option value="1" selected="selected">Integrated</option>
   <option value="2">size resolved</option>
  </select>
  <label for="idlog"><b>Size distribution moment: </b></label>
  <select name="idlog" id="idlog" >
   <option value="1" selected="selected">dNdlogDp</option>
   <!--<option value="2">dSdlogDp</option>-->
   <!--<option value="3">dVdlogDp</option>-->
   </select>
  <label for="idtime"><b>Time Resolution: </b></label>
  <select name="idtime" id="idtime" >
   <option value="1" selected>Hourly</option>
   <option value="2">Daily</option>
   <option value="3">Monthly</option>
   <option value="4">Diurnal</option>
  </select>
  <div id="minwrap" class="demo-wrapper">
  <label ><b>Min:</b></label>
  <input type="range" min="1" max="1000" id="idmin" value="500" onchange="rangemin(this.value)" oninput="rangemin(this.value);"><span id="spmin">500 nm</span> 
  </div>

  <div id="maxwrap" class="demo-wrapper">
  <label><b>Max:</b></label>
  <input type="range"  min="1" max="1000" id="idmax" value="500" onchange="rangemax();" oninput="rangemax();"/><span id="spmax">500 nm</span>
  </div>
<!--<div style="display:inline;border:1px red solid;width:15px;text-align:center;height:15px;line-height:15px;float:right;right:500px;">nm</div>-->
<input type="button" id="idbutn" value="Search" style="height:25px;width:125px;background-color:green;border:2px solid gray;border-radius:12px;margin-top:10px;background-color:-moz-linear-gradient(bottom, rgb(163,168,107) 36%, rgb(163,200,107) 73%);background:-webkit-linear-gradient(bottom, rgb(163,168,107) 36%, rgb(163,200,107) 73%);" onclick="ajaxAnalysis();"/>
 </div>
<!-- analysis box -->
 </body>
</html>
