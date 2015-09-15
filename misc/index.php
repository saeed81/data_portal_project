<?php

error_reporting(E_ALL ^ E_NOTICE);

//$message = isset($_GET['message']) ? $_GET['message'] : '';

//define("dir_portal","");

$root = realpath($_SERVER["DOCUMENT_ROOT"]);

include("$root/includes/header.html") ;

include("$root/includes/navbar.html") ;


if($_GET['page'] == "home"){
    
    include("$root/includes/home.html") ;

}elseif($_GET['page'] == "data"){

    include("$root/includes/data.html") ;

}elseif ($_GET['page'] == "data1"){
    include("$root/includes/data1.html");

}elseif($_GET['page'] == "data2"){

    include("$root/includes/data2.html");

}elseif($_GET['page'] == "about"){

    include("$root/includes/about.html");
} else{
    include("$root/includes/home.html") ;
}

include("$root/includes/footer.html") 


?>
