<?php 
include ('header.html');
?>

<body>

<div id="header"><h2>Message Board</h2></div>

<div id="login">
	<p>
    <?php

	// Welcome the user (by name if they are logged in).

	echo '<h4>Welcome';

	if (isset($_SESSION['first_name'])) {

	    echo ", {$_SESSION['first_name']}!";

	}

	echo '</h4>';

	// Display links based upon the login status

	if (isset($_SESSION['user_id']) AND (substr($_SERVER['PHP_SELF'], -10) != 'logout.php')) {

	echo '<a href="logout.php">Logout</a><br />

	<a href="change_password.php">Change Password</a><br />';

	} else { //  Not logged in.

	echo '	<a href="register.php">Register</a><br />

	<a href="login.php">Login to your account</a><br />

	<a href="forgot_password.php">Forgot Password</a><br />';

	}

    ?>
    </p>
    
    
</div>

<div id="lypsum">
	<h3>Just Some Random Text</h3>
    
    <p>
    	But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?
    </p>
    
    <p>
    	But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?
    </p>
    
    <p>
    	But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?
    </p>
    
</div>

<div id="footer"><h2>This is the Footer</h2></div>

</body>
</html>
