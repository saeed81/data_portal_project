function init()
{

    var results = document.getElementById("results");
        
    if (results.addEventListener) {
        // For all major browsers, except IE 8 and earlier
        results.addEventListener("click", ajax_get_json);
        
    }
    else if (results.attachEvent) {
        // For IE 8 and earlier versions
        results.attachEvent("onclick",ajax_get_json);
        
    }
    var results1 = document.getElementById("results1");
        
    if (results1.addEventListener) {
        // For all major browsers, except IE 8 and earlier
        results1.addEventListener("click", ajax_get_json1);
        
    }
    else if (results1.attachEvent) {
        // For IE 8 and earlier versions
        results1.attachEvent("onclick",ajax_get_json1);
        
    }
       
}

function ajax_get_json()
{
    
    var final2 = document.getElementById("final2");
    
    var hr = new XMLHttpRequest();
    
    hr.onreadystatechange = function() 
    {
        
        if(hr.readyState == 4 && hr.status == 200 && hr.statusText == "OK" ) {
            
            console.log(hr.readyState);
            
            var data = JSON.parse(hr.responseText);
            
            results.innerHTML = "";
            
            var prop = "";
            
            var ncount = 0;
            
            for(var obj in data){
                
                
                //results.innerHTML += "Property A: "+data[obj].propertyA+"<hr />";
                
                //results.innerHTML += "Property B: "+data[obj].propertyB;
                if ( ncount == 0 )
                {
                    prop = "A";
                    
                }
                else
                {
                    prop = "B";
                    
                }
                
                ncount++;
                
                final2.innerHTML += "Property " + prop + ": "+ data[obj]+"<hr />";
                //document.write("Property " + prop + ": "+ data[obj]+"<hr />");
                
                
            }
            
            
        }
        
    }
        
        hr.open("POST", "./myjson.php", true);
    
    hr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    
    hr.send("var1=birds&var2=bees");
    
    //results.innerHTML = "requesting...";
    
}

function ajax_get_json1()
{
    
    var final1 = document.getElementById("final1");
    
    var hr = new XMLHttpRequest();
    
    hr.onreadystatechange = function() 
    {
        
        if(hr.readyState == 4 && hr.status == 200 && hr.statusText == "OK" ) {
            
            console.log(hr.readyState);
            
            var data = JSON.parse(hr.responseText);
            
            results.innerHTML = "";
            
            var prop = "";
            
            var ncount = 0;
            
            for(var obj in data){
                
                
                //results.innerHTML += "Property A: "+data[obj].propertyA+"<hr />";
                
                //results.innerHTML += "Property B: "+data[obj].propertyB;
                if ( ncount == 0 )
                {
                    prop = "A";
                    
                }
                else
                {
                    prop = "B";
                    
                }
                
                ncount++;
                
                final1.innerHTML += "Property " + prop + ": "+ data[obj]+"<hr />";
                //document.write("Property " + prop + ": "+ data[obj]+"<hr />");
                
                
            }
            
            
        }
        
    }
        
        hr.open("POST", "myjson.php", true);
    
    hr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    
    hr.send("var1=birds&var2=bees");
    
    //results1.innerHTML = "requesting...";
    
}

window.onload=init;
