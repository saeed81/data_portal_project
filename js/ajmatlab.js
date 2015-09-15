
//Browser Support Code
function valForm()
{
         var vnum1 = document.getElementById('datepicker1').value;
         
         var vnum2 = document.getElementById('datepicker2').value;
         
         var sdate="";

         var valid = true; 

         if (vnum1 == sdate) 
         {
             //alert("please choose a start date");
             Alert.render("please choose a start date",'datepicker1');
             
             //window.location.href="index.php?page=analysis";

             //window.document.getElementById('datepicker1').focus() ;

             valid = false;

             return valid;

            
            
           } 


        if (vnum2 == sdate)
        {
            //alert("please choose a end date");
            Alert.render("please choose a end date",'datepicker2')
             
            //document.getElementById('datepicker2').focus() ;

            valid = false;

            return valid;

         }
 

         var asdate = parseInt(vnum1.substring(0,4));
        
         var aedate = parseInt(vnum2.substring(0,4));
        

         if ( aedate < asdate )
         {
            //alert("the end year should be larger than the start year");
            Alert.render("the end year should be larger than the start year",'datepicker2')
            
             //document.getElementById('datepicker2').focus() ;

             valid = false;

             return valid;


         }
        

         if ( aedate == asdate ) {
            

             var amsdate = parseInt(vnum1.substring(5,7));
        
             var amedate = parseInt(vnum2.substring(5,7));

             if ( amedate < amsdate )
             {
                 //alert("the end month should be larger than the start month");
                 Alert.render("the end month should be larger than the start month",'datepicker2');
                 //document.getElementById('datepicker2').focus() ;

                 valid = false;

                 return valid;


            
             }
        
             if ( amedate == amsdate ){
            

                 var adsdate = parseInt(vnum1.substr(8,2));
        
                 var adedate = parseInt(vnum2.substr(8,2));

                 if ( adedate <= adsdate )
                 {
                     Alert.render("the end day should be larger than the start day",'datepicker2');
                     
                     //document.getElementById('datepicker2').focus() ;

            
                     valid = false;

                     return valid;


                 }
             }
        
         }

    var rmin = parseInt(document.getElementById('idmin').value) ;
    var rmax = parseInt(document.getElementById('idmax').value) ;
 
    if ( rmin >= rmax ){

        valid = false;
        Alert.render("the minimum size cannot be larger than or equal to maximum size",'idmin');
        //document.getElementById('idmin').focus();             
        
        return valid;
    }
        
         return valid;
}
function ajaxAnalysis_old()
     {
         

         //window.alert('your figure will be ready soon. Close this prompt box to get your figure in no time')

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

     
         var lform = true;

         lform = valForm();

 
         if ( lform )

         {    

         ajaxRequest.onreadystatechange=function() 
         {
        
                 
             if (ajaxRequest.readyState==4 && ajaxRequest.status==200) {

                                



             }
        
         }
        

     
                 
         



             //     var vnum1 = document.getElementById('num1').value;
         
             //var vnum2 = document.getElementById('num2').value;
         
         //var sex = document.getElementById('sex').value;
         
         //var queryString = "?age=" + age + "&wpm=" + wpm + "&sex=" + sex;
         
         //ajaxRequest.open("GET", "ajax-example.php" + queryString, true);
         
         //ajaxRequest.send(null);
          
         //var strsnd= "x=" + "";
         
         //var strsnd= "x=" + vnum1 + "&y=" + vnum2;
         
         //ajaxRequest.open("GET","./show_get.php" + strsnd,true);
    
        // ajaxRequest.open("POST","./show_post_matlab.php",true);
    
         //ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
         
         //ajaxRequest.send();
    
        //ajaxRequest.send(strsnd);
    

     }
     
     else {


         return false;


}

}

//


     
     





