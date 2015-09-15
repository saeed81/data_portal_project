<?php

error_reporting(E_ALL ^ E_NOTICE);

//$message = isset($_GET['message']) ? $_GET['message'] : '';

//define("dir_portal","");

$root = realpath($_SERVER["DOCUMENT_ROOT"]);

include("includes/header.html") ;

include("includes/navbar.html") ;


if($_GET['page'] == "data"){

    include("includes/data.html") ;
    
}elseif ($_GET['page'] == "itmad"){
    include("includes/itmad.html");

}elseif($_GET['page'] == "ebas"){

    include("includes/ebas.html");
}

elseif($_GET['page'] == "ebas"){

    include("includes/ebas.html");
}

elseif($_GET['page'] == "aerocom"){

    include("includes/aerocom.html");
}

elseif($_GET['page'] == "ecds"){

    include("includes/ecds.html");
}

elseif($_GET['page'] == "cordex"){

    include("includes/cordex.html");
}

elseif($_GET['page'] == "instruments"){

    include("includes/instruments.html");

}elseif($_GET['page'] == "analysis"){

    include("includes/analysis.html");
}elseif($_GET['page'] == "esticc"){

    include("includes/esticc.html");

}elseif($_GET['page'] == "about"){

    include("includes/about.html");

}
elseif($_GET['page'] == "contact"){

    include("includes/contact.html");
} else{
    include("includes/home.html") ;
}

include("includes/footer.html");



?>
