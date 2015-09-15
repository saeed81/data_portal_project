<?php
	include('header.html');
?>

<style>
#recaptcha_image img { 
      width: 185px; 
      height: 28.5px; 
      border: 1px solid gainsboro; 
    } 
#recaptcha_widget {
    	height:400;
    }
</style>

<script type="text/javascript">
    // Changes the styling for the Captcha image
    var RecaptchaOptions = {
    		theme : 'custom',
    		custom_theme_widget: 'recaptcha_widget'
 			};
</script>

<?php

      if (isset($_POST['submitted'])) { // Check if the form has been submitted.

		// Security check for a valid username
		if (preg_match ('%^[A-Za-z0-9]\S{8,20}$%', stripslashes(trim($_POST['userid'])))) {

			// Scrub username with function in header.php
			$u = escape_data($_POST['userid']);

		} else {

			$u = FALSE;

			echo '<p><font color="red" size="+1">Please enter a valid User ID!</font></p>';
		}
		
		// Security check for a valid password

		if (preg_match ('%^[A-Za-z0-9]\S{8,20}$%', stripslashes(trim($_POST['pass'])))) {

			// Scrub password with function in header.php
			$p = escape_data($_POST['pass']);

		} else {

			$p = FALSE;

			echo '<p><font color="red" size="+1">Please enter a valid Password!</font></p>';

		}
		
		// PHP Code for the CAPTCHA System

		$captchchk = 1;
		
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

		// Query the database. Verify the username, password and captcha
		
		if ($u && $p && $captchchk) {

			$query = "SELECT user_id, first_name, last_name, email, username, passwd, active FROM users WHERE username='$u' AND passwd=SHA('$p')";		

			$result = mysql_query ($query) or trigger_error("Either the Userid or Password are incorrect 1");

			if (mysql_affected_rows() == 1) { // A match was made

				$row = mysql_fetch_array ($result, MYSQL_NUM); 

				mysql_free_result($result);
				
				// If they haven't activated the account redirect
				if ($row[6] != NULL) 
				{
					header("Location: http://localhost/msgbrd/mbforgotpass.php");
					mysql_close(); // Close the database connection.
					exit();
				}

				$_SESSION['first_name'] = $row[1];

				$_SESSION['userid'] = $row[4];
				
				// Create Second Token for security
				
				$tokenId = rand(10000, 9999999);
				
				$query2 = "update users set tokenid = $tokenId where username = '$_SESSION[userid]'";
				
				$result2 = mysql_query ($query2);
		
				$_SESSION['token_id'] = $tokenId;
				
				// Reset session id for security
				session_regenerate_id();

				// Redirect the user
				header("Location: http://localhost/msgbrd/mblogin.php");
				mysql_close(); // Close the database connection.
				exit();
			}

			} else { // No match was made.

			echo '<br><br><p><font color="red" size="+1">Either the Userid or Password are incorrect 2</font></p>'; 
			mysql_close(); // Close the database connection
			exit();
			}
	} // End of SUBMIT

?>
      
<body>
	<div id="header"><h2>Message Board</h2></div>

     <div id="login">
     
    <?php
    	echo '<h1>Welcome';

		if (isset($_SESSION['first_name'])) {
			echo ", {$_SESSION['first_name']}!";
		}
		echo '</h1>';
		
		// Display links based upon the login status
		// If user is on the logout page disable the login

		if (isset($_SESSION['userid']) AND (substr($_SERVER['PHP_SELF'], -10) != 'logout.php')) {

			echo '<a href="logout.php">Logout</a><br />
			<a href="change_password.php">Change Password</a><br />';

		} else { //  Not logged in.

			echo "
			
				<form action='mblogin.php' method='post'>
				<p><b>Userid:</b> <input type='text' name='userid' size='20' maxlength='20' /></p>
				<p><b>Password:</b> <input type='password' name='pass' size='16' maxlength='30' /></p>";
	
			// Captcha stuff from Google
			echo "
				<div id='recaptcha_widget' style='display:none'>

   			<div id='recaptcha_image'></div>
   			<div class='recaptcha_only_if_incorrect_sol' style='color:red'>Incorrect please try again</div>

   			<span class='recaptcha_only_if_image'>Enter the words above:</span><br />
   			<span class='recaptcha_only_if_audio'>Enter the numbers you hear:</span>

   			<input type='text' id='recaptcha_response_field' name='recaptcha_response_field' />

   			<div><a href='javascript:Recaptcha.reload()'>Get another CAPTCHA</a></div>
   			<div class='recaptcha_only_if_image'><a href='javascript:Recaptcha.switch_type(\'audio\')'>Get an audio CAPTCHA</a></div>
  			 <div class='recaptcha_only_if_audio'><a href='javascript:Recaptcha.switch_type(\'image\')'>Get an image CAPTCHA</a></div>

   			<div><a href='javascript:Recaptcha.showhelp()'>Help</a></div>

 			</div>

 <script type='text/javascript'
    src='http://www.google.com/recaptcha/api/challenge?k=6LfXR8ASAAAAAAaDH3VUIOuMbqAHQEfmSr0_W-Oq'>
 </script>
 <noscript>
   <iframe src='http://www.google.com/recaptcha/api/noscript?k=6LfXR8ASAAAAAAaDH3VUIOuMbqAHQEfmSr0_W-Oq'
        height='300' width='500' frameborder='0'></iframe><br>
   <textarea name='recaptcha_challenge_field' rows='3' cols='40'>
   </textarea>
   <input type='hidden' name='recaptcha_response_field'
        value='manual_challenge'>
 </noscript>
			";
    
    		echo "<div align='left'><input type='submit' name='submit' value='Login' /></div>
				<input type='hidden' name='submitted' value='TRUE' />
				</form>";
			
			echo '<a href="register.php">Register</a><br />
			<a href="forgot_password.php">Forgot Password</a><br />';

	}
	?>

    </div>

  </body>

</html>