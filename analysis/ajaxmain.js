//Browser Support Code

var vnum1;

var vnum2;

var rmin;

var rmax;

function valForm()
{
         vnum1 = document.getElementById('datepicker1').value;
         
         vnum2 = document.getElementById('datepicker2').value;
         
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

    rmin = parseInt(document.getElementById('idmin').value) ;
    rmax = parseInt(document.getElementById('idmax').value) ;
 
    if ( rmin >= rmax ){

        valid = false;
        Alert.render("the minimum size cannot be larger than or equal to maximum size",'idmin');
        //document.getElementById('idmin').focus();             
        
        return valid;
    }
        
         return valid;
}




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


    var selstn = document.getElementById("idstation");

    var indexstn= selstn.selectedIndex;

    var vstn = selstn[indexstn].text;


    var selsize = document.getElementById("idsize");

    var indexsize= selsize.selectedIndex;

    var vsize = selsize[indexsize].text;


    var sellog = document.getElementById("idlog");

    var indexlog= sellog.selectedIndex;

    var vlog = sellog[indexlog].text;

    if (vlog == "dNdlogDp")
    {

        vlog = "Numb";
    }

    else if (vlog == "dSdlogDp")
    {
        vlog = "Surf";
    }
    else if ( vlog == "dVdlogDp")
    {
        vlog = "Volu";
    }
    
    var seltime = document.getElementById("idtime");

    var indextime= seltime.selectedIndex;

    var vtime = seltime[indextime].value;


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

        var strsnd= "vstn=" + vstn.trim() + "&fdate=" + vnum1.trim() + "&edate=" + vnum2.trim() + "&vsize=" + vsize.trim() + "&vlog=" + vlog.trim() + "&vtime=" + vtime.trim() + "&rmin=" + rmin.toString().trim() + "&rmax=" + rmax.toString().trim();
         
             
        ajaxRequest.open("POST","analysis/show_post_matlab.php",true);
        
        ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        
        ajaxRequest.send(strsnd);
    
    }
    
    else{
        
        return false;

    }
         
    
}



//Browser Support Code

//


     
     





