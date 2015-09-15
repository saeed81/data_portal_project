<?php

include('includes/header.html') ;

include('includes/navbar.html') ;


if($_GET['page'] == "home"){
    
    include('includes/home.html') ;

}elseif($_GET['page'] == "data"){

    include('includes/data.html') ;

}elseif ($_GET['page'] == "data1"){
    include('includes/data1.html');

}elseif($_GET['page'] == "data2"){

    include('includes/data2.html');

}elseif($_GET['page'] == "about"){

    include('includes/about.html');
} else{
    include('includes/home.html') ;
}

include('includes/footer.html') 


?>
