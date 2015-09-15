<!doctype html>
<html>
   <body>
   
      <h1> Server updates</h1>
      <div id="result"></div>
   
      <script>
     if(typeof(EventSource) !== "undefined") {
         
         var source = new EventSource("demo_sse.php");
         
         
         source.onmessage = function(event) 
         {
             
             document.getElementById("result").innerHTML += event.data + "<br>";
             
         }
         ;
         
     }
     
      
     else {
         
         document.getElementById("result").innerHTML = "Sorry, your browser does not support ";
         
     }

      </script>
   </body>
</html>