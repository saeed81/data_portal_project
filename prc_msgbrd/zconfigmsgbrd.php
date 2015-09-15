<?php
	// Define these as constants so that they can't be changed
	DEFINE ('DBUSER', 'mysqladm');
	DEFINE ('DBPW', 'Turtle2Dove');
	DEFINE ('DBHOST', 'localhost');
	DEFINE ('DBNAME', 'msgbrd');
	
	if ($dbc = mysql_connect (DBHOST, DBUSER, DBPW)) {
	
	if (!mysql_select_db (DBNAME)) { // If it can’t select the database.

	// Handle the error.

	trigger_error("Could not select the database!<br />MySQL Error: " . mysql_error());

	exit();

	} // End of mysql_select_db IF.
	
	} else {

	// Print a message to the user, and kill the script.

	trigger_error("Could not connect to MySQL!<br />MySQL Error: " . mysql_error());

	exit();

	} 
	
	// A function that strips harmful data.
function escape_data ($data) {

	// Check for mysql_real_escape_string() support.
	// This function escapes characters that could be used for sql injection
	if (function_exists('mysql_real_escape_string')) {
		global $dbc; // Need the connection.
		$data = mysql_real_escape_string (trim($data), $dbc);
		$data = strip_tags($data);
	} else {
		$data = mysql_escape_string (trim($data));
		$data = strip_tags($data);
	}

	// Return the escaped value.	
	return $data;

}

function retrieve_messages() {

	global $dbc;
	
	$query = "SELECT m.subject, m.message_text, u.username, m.date, m.parent_id, m.user_id, m.mess_block, m.topic, m.user_id FROM message AS m, users AS u WHERE (m.user_id = u.user_id) ORDER BY m.mess_block, m.date;";
	
	$result = mysql_query($query) or trigger_error("An Error Happened");
	
	if (mysql_affected_rows() > 0) {
		$tagSwitch = FALSE;
		while ($messages = mysql_fetch_array($result, MYSQLI_ASSOC))
		{
			if ($messages['parent_id'] == 0)
			{
				($tagSwitch) ? print '</div>' : print '<div class="commentBox">';
				$tagSwitch = !$tagSwitch;
				
				echo "<p><h3>{$messages['subject']}</h3></p>";
				echo "<p>{$message['message_txt']}</p>";
				echo "<br />via: {messages['username']} <a href='#' class='getComments'>Comments</a><hr />";
				echo "<div class='comments'>";
				echo "<form id='theForm'>";
				echo "<textarea name='comment' class='comment' cols=60 rows=10>Enter Comment...</textarea>";
				
				echo "<input type=hidden name='username' value={$messages['username']}>";
				
				echo "<input type=hidden name='parent_id' value=1";
				
				echo "<input type=hidden name='mess_block' value={$messages['mess_block']}>";
				
				echo "<input type=hidden name='token_id' value={$messages['token_id']}>";
				
				echo "<input type=hidden name='topic_id' value={$messages['topic_id']}>";
				
				echo "<input type=hidden name='user_id' value={$messages['user_id']}>";
				
				echo "<button type='button' id='oneButton'>Post Comment</button></form></div>";
				
				} else {
					echo "<div class='comments'>";
					echo "{messages['message_txt']}<br />";
					echo "via: {$messages['username']}<br /><hr />";
					echo "</div>";
					}
				}
			}	
				

}

?>











