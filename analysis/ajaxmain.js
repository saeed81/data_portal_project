//Browser Support Code
     function ajaxAnalysis()
     {
         

        // window.alert('your figure will be ready soon. Close this prompt box to get your figure in no time')

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
         
         
         var lform = valForm();

         if (lform) {


                         
         ajaxRequest.onreadystatechange=function() 
         {
        
                                                                                                                                                                      
             if (ajaxRequest.readyState < 4) {                        // while waiting response from server
                 



                 //document.getElementById("iddate").style.visibility = "hidden";
                 //document.getElementById("wraprog").style.display = "block";
                 //document.getElementById("wraprog").style.zIndex = "10";

                 /*document.getElementById("idajax").style.visibility = "visible";
                 document.getElementById("myImage").src = "analysis/ajax-loader_progress.gif";
                 document.getElementById("myImage").style.width = "100%";
                 document.getElementById("myImage").style.height = "100%";
                 */
                 Alert.showProgress();
                 
             }
             
             

  
             else if(ajaxRequest.readyState==4 && ajaxRequest.status==200) {

                 
                 document.getElementById("idajax").style.visibility = "hidden";
                              
                 Alert.hideProgress();
                 
                 
                 var str =ajaxRequest.responseText;
                 
                 var vaj = "ajaxs.php?fig="+str.trim();
                 
                 vaj = "analysis/ajaxs.php?"+str.trim();
                 
                 vaj = "analysis/?"+str.trim();
                 
                 window.location.href = vaj;
                 
                          
             }
             
             
             }
          
         var strsnd= "x=" + "";
         
             
         ajaxRequest.open("POST","analysis/show_post_matlab.php",true);
    
         ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                      
             ajaxRequest.send(strsnd);
    
             }

         else{

             return false;

             }
         

}



