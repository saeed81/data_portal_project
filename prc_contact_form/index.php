<!DOCTYPE HTML>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Contact Form</title>
<style>
     @charset "utf-8";

/* CSS Document */

@font-face 
{
    
    font-family: 'BebasRegular';
    
    src: url('fonts/BEBAS___-webfont.eot');
    
    src: url('fonts/BEBAS___-webfont.eot?#iefix') format('embedded-opentype'),
        url('fonts/BEBAS___-webfont.woff') format('woff'),
        url('fonts/BEBAS___-webfont.ttf') format('truetype'),
        url('fonts/BEBAS___-webfont.svg#BebasRegular') format('svg');
    
    font-weight: normal;
    
    font-style: normal;
    
}


body 
{
    
    font-size:100%;
    
    font-family:Georgia, "Times New Roman", Times, serif;
    
    color:#3a3a3a;
}


.body 
{
    
    width:576px;
    
    margin:0 auto;
    
    display:block;
    
}


h1 
{
    
    width:498px;
    
    height:64px;
    
    /*background:url(images/h1-bg.jpg);*/
    
    color:#fff;
    font-family:bebas;
    
    padding:17px 0px 0px 78px;
    
    letter-spacing:1px;
    
    font-size:2.2em;
    
    margin:0 auto;
    
}


form 
{
    
    width:459px;
    
    margin:0 auto;
    
}


label 
{
    
    display:block;
    
    margin-top:20px;
    
    letter-spacing:2px;
    
}


input, textarea 
{
    
    width:439px;
    
    height:27px;
    
    background:#efefef;
    border-radius:5px;
    
    -moz-border-radius:5px;
    
    -webkit-border-radius:5px;
    
    border:1px solid #dedede;
        padding:10px;
    
    margin-top:3px;
    
    font-size:0.9em;
    
    color:#3a3a3a;
}


input:focus, textarea:focus 
{
    
    border:1px solid #97d6eb;
        }

textarea 
{
    
    height:213px;
    
    font-family:Arial, Helvetica, sans-serif;
    
    /*background:url(images/textarea-bg.jpg) right no-repeat #efefef;*/
        }

#submit {
/*background:url(images/submit.jpg);*/

width:127px;

height:38px;

text-indent:-9999px;

border:none;

margin-top:20px;

cursor:pointer;

}


#submit:hover {
opacity:0.9;

}


footer a img 
{
    
    border:none;
    
    float:right;
    
    margin:0px 59px 40px 0px;
    
}




</style>

</head>

<body>

    <header class="body">
    </header>

    <section class="body">

      <form method="post" action="index.php">
        
    <label>Name</label>
    <input name="name" placeholder="Type Here">
            
    <label>Email</label>
    <input name="email" type="email" placeholder="Type Here">
            
    <label>Message</label>
    <textarea name="message" placeholder="Type Here"></textarea>
            
    <input id="submit" name="submit" type="submit" value="Submit">
        
</form>




    </section>

    <footer class="body">
    </footer>

</body>

</html>