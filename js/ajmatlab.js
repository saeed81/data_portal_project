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

//


     
     





