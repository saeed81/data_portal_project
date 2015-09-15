var numImages = 0;
var currentImage = 1;
var totalWidth = 0;
var jq = $.noConflict();

jq(document).ready(function() {
    hideBtns();
    jq('.gallery-li').each(function(){
        numImages++;
        totalWidth += 480;
    });
    //jq('.gallery-ul').css('width',totalWidth + 'px');
    
    jq('.rightbtn-inner').click(function(){
        moveLeft();
        hideBtns();
    
        });
         
    jq('.leftbtn-inner').click(function(){
        moveRight();
        hideBtns();
         

    });

    hideBtns();
});



function moveRight()
{
    if( currentImage > 1 )
    {
        jq('.gallery-ul').animate({'marginLeft' : '+=100%' }, 800, 'swing');
        currentImage--;
}

}
function moveLeft()
{
    if( currentImage < numImages )
    {
        jq('.gallery-ul').animate({'marginLeft' : '-=100%' }, 800, 'swing');
        currentImage++;
}
}

function hideBtns(){

if( currentImage == 1 ) 
{
//jq('.leftbtn-inner').show(); 
}
else
{
//jq('.leftbtn-inner').show();
}
if( currentImage == numImages )
{ 
//jq('.rightbtn-inner').show(); 
}
else
{
//jq('.rightbtn-inner').show();
}
}
