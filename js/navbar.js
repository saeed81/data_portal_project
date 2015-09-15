function chfont() {
    var tablinks = document.getElementsByClassName('anvtag');
    var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    if( w < 900){
        for (var i = 0, j = tablinks.length; i < j; i++) {
            tablinks[i].style.fontSize = "90%";
        }
   }
    else{
        for (var i = 0, j = tablinks.length; i < j; i++) {
            tablinks[i].style.fontSize = "125%";
        }
    
    }
    
    var nvbar = document.getElementById("navmenu");
    
    if ( w > 800 )
        {
            nvbar.style.display = "block";
            return true;
            
        }
    
        else if (w <= 800)
            {
                nvbar.style.display = "none";
                return true;
            }
    
}
window.onresize = chfont;
chfont();
