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
    jq('.gallery-ul').css('width',totalWidth + 'px');
    
    jq('.gallery-mask').click(function(){
        moveLeft();
        hideBtns();
    });

        jq('.rightbtn').click(function(){
        moveLeft();
        hideBtns();
    
        });
         
    jq('.leftbtn').click(function(){
        moveRight();
        hideBtns();
         

    });

    hideBtns();
});



function moveRight()
{
    if( currentImage > 1 )
    {
        jq('.gallery-ul').animate({'marginLeft' : '+=480px' }, 1000, 'swing');
        currentImage--;
}

}
function moveLeft()
{
    if( currentImage < numImages )
    {
        jq('.gallery-ul').animate({'marginLeft' : '-=480px' }, 1000, 'swing');
        currentImage++;
}
}

function hideBtns(){

if( currentImage == 1 ) 
{
jq('.leftbtn').hide(); 
}
else
{
jq('.leftbtn').show();
}
if( currentImage == numImages )
{ 
jq('.rightbtn').show(); 
}
else
{
jq('.rightbtn').show();
}
}
