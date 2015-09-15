<?php

include('includes/header.html') ;

include('includes/navbar.html') ;


if($_GET['page'] == "home"){
    
    include('includes/home.html') ;

}elseif ($_GET['page'] == "data"){

    if($_GET['page'] == "data1"){
        include('includes/data1.html') ;
    }elseif($_GET['page'] == "data2"){
        include('includes/data2.html');
    }
    else{
        include('includes/data3.html');
    }
}else{

include('includes/about.html') ;

}

include('includes/footer.html') 


?>
