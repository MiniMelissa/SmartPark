<?php

require("db_connect.php");

$request = file_get_contents('php://input');
$json = json_decode($request, TRUE);

foreach ($json as $elem) {
    $userid = $elem['UserID'];
    $timestamp = $elem['Timestamp'];
    $state = $elem['State'];
    $query = "INSERT INTO WiFi (UserID, Timestamp, State) VALUES ('$userid', '$timestamp', '$state')";
    mysql_query($query) or die(mysql_error());
}
echo("COMPLETE");
?>
