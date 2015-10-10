<script language="javascript" type="text/javascript">

//Browser Support Code
     function ajaxMatlab1()
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
         
         //var x = document.createElement("METER");
         
         //x.setAttribute("min", "0");
         
         //x.setAttribute("max", "100");
         
         //x.setAttribute("value", "0");
         
         //document.body.appendChild(x);
         
         //var x = document.getElementById("myMeter");
         
                  
         //x.value = "0";
         
         //document.getElementById("wrapprog").style.visibility = "visible";
                 
         //stopprogressBarSim();
                 
         if(typeof(EventSource) !== "undefined") {
                     

             var source = new EventSource("demo_sse.php");
         }
         
                 
         ajaxRequest.onreadystatechange=function() 
         {
        
             //var t1 = setTimeout(function()                                                                                                                                                           
             //    {
                     //                                                                                                                                                                                                         
             //      x.value = "10"}, 100);
                                                                                                                                                              
             if (ajaxRequest.readyState < 4) {                        // while waiting response from server
                 



                 //if(typeof(EventSource) !== "undefined") {
                     

                 //   var source = new EventSource("demo_sse.php");
                     


                     source.onmessage = function(event)
                     {
                         

                         document.getElementById("result").innerHTML += event.data + "<br>";
                         

                     }
                     
                     ;
                     

                     //}
                 
                 
                 
                 


                     //else {
                     

                     //document.getElementById("result").innerHTML = "Sorry, your browser does not support ";
                     

                     //}
                 


             





























                 document.getElementById("div1").style.visibility = "visible";
                 document.getElementById("div1").style.zIndex = "100";
                 document.getElementById("myImage").src = "ajax-loader_progress.gif";
                 document.getElementById("myImage").style.width = "10%";
                 document.getElementById("myImage").style.height = "5%";
                 
                  //document.getElementById("myImage").style.zIndex = "100";
                 //    var amountLoaded = 0;
                     //  
                 //progressBarSim(amountLoaded);
                 
                 //var myWindow = window.open("", "myWindow", "width=500, height=500");
                 // Opens a new window
                 //myWindow.document.write("<div id='div1'><img id='myImage' src='ajax-loader.gif' alt='Smiley face' width='42' height='42></div>");
                 // Text in the new window
                 //myWindow.opener.document.write("<p>This is the source window!</p>");
                 // Text in 


                              
             }
             
             

  
             else if(ajaxRequest.readyState==4 && ajaxRequest.status==200) {

                 source.close();
                 
                                  
                 //stopprogressBarSim();
                 

                 document.getElementById("div1").style.visibility = "hidden";
                 //document.getElementById("wrapprog").style.visibility = "hidden";
                   
                
             //   if(ajaxRequest.readyState == 3 ) {

                  //document.getElementById("shsum").innerHTML=ajaxRequest.responseText;

                  
                 //    var t2 = setTimeout(function()                                                                                                                                                           
                 //{
                 //            x.value = "50"}, 5000);
             
                

                 //var t3 = setTimeout(function()                                                                                                                                                           
                 // {
                 //           x.value = "100"}, 5000);
             
                     
             
             document.getElementById("shfig").src=ajaxRequest.responseText;

                  
                  //document.getElementById("shfig").style.position='absolute';


             document.getElementById("shfig").style.width='75%';



             document.getElementById("shfig").style.height='75%';


             }
             
             
             

                 /*else if(ajaxRequest.readyState > 2 || ajaxRequest.readyState == 3 ) {

                 var t1 = setTimeout(function()                                                                                                                                                           
                 {
                                                                                                                                                                                                                        
                     x.value = "10"}, 100);
                                                                                                                                                                                           
                                                                                                                                                                                                                     
                 var t2 = setTimeout(function()                                                                                                                                                                              
                 {
                                                                                                                                                                                                                                
                     x.value = "20"}, 200);
                                                                                                                                                                                                   
                                                                                                                                                                                                                     
                 var t3 = setTimeout(function()                                                                                                                                                                              
                 {
                                                                                                                                                                                                                                
                     x.value = "30"}, 300);
                                                                                                                                                                                                   
                                                                                                                                                                                                                     
                 var t2 = setTimeout(function()                                                                                                                                                                              
                 {
                                                                                                                                                                                                                                
                     x.value = "40"}, 400);
                                                                                                                                                                                                   
                                                                                                                                                                                                                     
                                                                                                                                                                                                                     
                 var t2 = setTimeout(function()                                                                                                                                                                              
                 {
                                                                                                                                                                                                                                
                     x.value = "50"}, 500);
                                                                                                                                                                                                   
                                                                                                                                                                                                                     
                                                                                                                                                                                                                     
                 var t2 = setTimeout(function()                                                                                                                                                                              
                 {
                                                                                                                                                                                                                                
                     x.value = "60"}, 600);
                                                                                                                                                                                                   
                                      

             
        
             }
                 */ 
             
             
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
