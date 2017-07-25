<?php

$host = "mysql.cs.binghamton.edu";
$user = "smartpark";
$pw = "Shuwie4Eofei";
$selected_db = "smartpark_ios";

$database = mysql_connect($host, $user, $pw);

if(!$database){
    die("Could not connect to database:".mysql_error());
}

mysql_select_db($selected_db);

?>
