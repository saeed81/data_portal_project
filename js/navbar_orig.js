function init() {
  var tablinks = document.getElementById('tabs').getElementsByTagName('a');
  for (var i = 0, j = tablinks.length; i < j; i++) {
    tablinks[i].onclick = doit;
  }
}
function doit() {
  alert(this.parentNode.className);
}
window.onload = init;


<!DOCTYPE html>
<html>
<head>
<link id="pagestyle" rel="stylesheet" type="text/css" href="large.css">
<script>
function layoutHandler(){
    var styleLink = document.getElementById("pagestyle");
    if(window.innerWidth < 900){
        styleLink.setAttribute("href", "mobile.css");
        } else if(window.innerWidth < 1200){
            styleLink.setAttribute("href", "medium.css");
            } else {
                    styleLink.setAttribute("href", "large.css");
                }
}
window.onresize = layoutHandler;
layoutHandler();
</script>
</head>
<body>
<div id="my_header"></div>
<div id="my_menu">
  <a href="#">Home</a>
  <a href="#">Services</a>
  <a href="#">Staff</a>
  <a href="#">Contact</a>
</div>
<div id="my_content">
Lorem ipsum goes here as dummy text, lots of it.
</div>
</body>
</html>
