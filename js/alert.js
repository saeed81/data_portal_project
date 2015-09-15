var ifc;
function CustomAlert(){
    this.render = function(dialog,idf){
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH+"px";
        dialogbox.style.left = (winW/2) - (550 * .5)+"px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "Acknowledge This Message";
        document.getElementById('dialogboxbody').style.fontSize = "2em";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<button onclick="Alert.ok();">OK</button>';
        document.getElementById('dialogboxfoot').innerHTML = '<button onclick="Alert.ok();">OK</button>';
        ifc=idf; 
}
this.ok = function(){
document.getElementById('dialogbox').style.display = "none";
document.getElementById('dialogoverlay').style.display = "none";
//document.getElementById('datepicker1').focus();
document.getElementById(ifc).focus();
}

    this.showProgress = function(){
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('wraprog');
        var dialogbox = document.getElementById('idajax');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.opacity = "1.0";
        dialogoverlay.style.height = winH+"px";
        dialogbox.style.left = (winW/2) - (550 * .5)+"px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        
}


this.hideProgress = function(){
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('wraprog');
        var dialogbox = document.getElementById('idajax');
        dialogoverlay.style.display = "none";
        dialogbox.style.display = "none";
        
}




}
var Alert = new CustomAlert();
