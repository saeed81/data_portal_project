<?php
	// Initialize a session.

	session_start();

    require_once("configmsgbrd.php");
?>

<?php

      if (isset($_POST['submitted'])) { // Check if the form has been submitted.
      

		if (preg_match ('%^[A-Za-z0-9]{8,20}$%', stripslashes(trim($_POST['username'])))) {

			$u = escape_data($_POST['username']);

		} else {

			$u = FALSE;

			echo '<p><font color="red" size="+1">Please enter a valid Username!</font></p>';

		}
		
		// FIX IT Check for a good password

		if (preg_match ('%^[A-Za-z0-9]{8,20}$%', stripslashes(trim($_POST['pass'])))) {

			$p = escape_data($_POST['pass']);

		} else {

			$p = FALSE;

			echo '<p><font color="red" size="+1">Please enter a valid Password!</font></p>';

		}
		
		// FIX IT PHP Code for the CAPTCHA System

		$captchchk = 1;
  		require_once('recaptchalib.php');
  		$privatekey = "6LfXR8ASAAAAAKpztg_bZb27P7KwUwFZYPi0pvOA";
  		$resp = recaptcha_check_answer ($privatekey,
                                $_SERVER["REMOTE_ADDR"],
                                $_POST["recaptcha_challenge_field"],
                                $_POST["recaptcha_response_field"]);

  		if (!$resp->is_valid) {
    		// What happens when the CAPTCHA was entered incorrectly
   	 		echo '<p><font color="red" size="+1">The CAPTCHA Code wasn\'t entered correctly!</font></p>';
  			$captchchk = 0;
  		}

		// Query the database.
		
		if ($u && $p && $captchchk) {

			$query = "SELECT username, email, passwd FROM users WHERE username='$u' AND passwd=SHA('$p')";		

			$result = mysql_query ($query) or trigger_error("Either the Userid or Password are incorrect");

			if (mysql_affected_rows() == 1) { // A match was made.

				$row = mysql_fetch_array ($result, MYSQL_NUM); 

				mysql_free_result($result);

				$_SESSION['username'] = $row[0];
				
				// Create Second Token
				
				$tokenId = rand(10000, 9999999);
				
				$query2 = "update users set tokenid = $tokenId where username = '$_SESSION[username]'";
				
				$result2 = mysql_query ($query2);
		
				$_SESSION['token_id'] = $tokenId;
				
				session_regenerate_id();

				header("Location: http://localhost/prc_msgbrd/index.php");
				mysql_close(); // Close the database connection.
				exit();
			}

			} else { // No match was made.

			echo '<br><br><p><font color="red" size="+1">2Either the Userid or Password are incorrect</font></p>'; 
			mysql_close(); // Close the database connection
			exit();
			}
			echo '<br><br><p><font color="red" size="+1">3Either the Userid or Password are incorrect</font></p>'; 
			mysql_close(); // Close the database connection
			exit();
			}
			

// End of SUBMIT conditional.

?>
      
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"

   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

  <head>

    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

    <title>Good Login</title>
  </head>
  
  <body>

     <div id="main">
     
    <?php
    	echo '<h1>Welcome';

		if (isset($_SESSION['username'])) {
			echo ", {$_SESSION['username']}!";
		}
		echo '</h1>';
		
		// Display links based upon the login status

		if (isset($_SESSION['username']) AND (substr($_SERVER['PHP_SELF'], -10) != 'logout.php')) {

			echo '<a href="logout.php">Logout</a><br />
			<a href="change_password.php">Change Password</a><br />';

		} else { //  Not logged in.

			echo '	<a href="register.php">Register</a><br />
			<a href="goodlogin.php">Login to your account</a><br />
			<a href="forgot_password.php">Forgot Password</a><br />';

	}
	?>

<h1>Login</h1>

<p>Your browser must allow cookies in order to log in.</p>

<form action="login.php" method="post">

	<fieldset>

	<p><b>Username:</b> <input type="text" name="username" size="20" maxlength="20" /></p>

	<p><b>Password:</b> <input type="password" name="pass" size="20" maxlength="20" /></p>
	
	<?php
          require_once('recaptchalib.php');
          $publickey = "6LfXR8ASAAAAAAaDH3VUIOuMbqAHQEfmSr0_W-Oq"; // you got this from the signup page
          echo recaptcha_get_html($publickey);
    ?>

	<div align="center"><input type="submit" name="submit" value="Login" /></div>

	<input type="hidden" name="submitted" value="TRUE" />

	</fieldset>

</form>

    </div>

  </body>

</html>