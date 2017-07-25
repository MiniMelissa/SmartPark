<?php

require("db_connect.php");

$request = file_get_contents('php://input');
$json = json_decode($request, TRUE);

foreach ($json as $elem) {
    $userid = $elem['UserID'];
    $timestamp = $elem['Timestamp'];
    $count = $elem['Count'];
    $query = "INSERT INTO Step (UserID, Timestamp, Count) VALUES ('$userid', '$timestamp', '$count')";
    mysql_query($query) or die(mysql_error());
}
echo("COMPLETE");
?>
