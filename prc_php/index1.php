<!DOCTYPE html>
<html>
<head>
<script>
function ajax_get_json()
{
    
    var results = document.getElementById("results");
    
    var hr;
    if ( window.XMLHttpRequest )
    {
        hr = new XMLHttpRequest();
    
    }
    else
    {
        hr = new ActiveObject("MICROSOFT.XMLHTTP");
    }
    
    hr.onerror = function(){};
    hr.onstart = function(){};
    hr.success = function(){};
    
    window.onload = 
    hr.onreadystatechange = function() 
    {
        
        if(hr.readyState == 4 && hr.status == 200) {
            
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
                
                results.innerHTML += "Property " + prop + ": "+ data[obj]+"<hr />";
                
            }
            
            
        }
        
    }
        var parameter = "var1=birds&var2=bees";
    
    hr.open("POST", "myjson.php", true);
    
    hr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    
    hr.setRequestHeader("Content-length", parameter.length)
    
    hr.send(parameter);
    
    results.innerHTML = "requesting...";
    
}

</script>
</head>
<body>
<div id="results"></div>
<script>ajax_get_json();</script>
</body>
</html>
