<?php

require("db_connect.php");

$request = file_get_contents('php://input');
$json = json_decode($request, TRUE);

foreach ($json as $elem) {
    $userid = $elem['UserID'];
    $timestamp = $elem['Timestamp'];
    $percentage = $elem['Percentage'];
    $query = "INSERT INTO Battery (UserID, Timestamp, Percentage) VALUES ('$userid', '$timestamp', '$percentage')";
    mysql_query($query) or die(mysql_error());
}


echo("COMPLETE");
?>
