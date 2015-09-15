<?php
	// Define these as constants so that they can't be changed
	DEFINE ('DBUSER', 'saeed');
	DEFINE ('DBPW', 'greatfriendfancylife');
	DEFINE ('DBHOST', 'localhost');
	DEFINE ('DBNAME', 'hamdb');
	
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

} // End of function.

?>