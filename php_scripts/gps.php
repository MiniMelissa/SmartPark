<?php

require("db_connect.php");

$request = file_get_contents('php://input');
$json = json_decode($request, TRUE);

foreach ($json as $elem) {
    $userid = $elem['UserID'];
    $timestamp = $elem['Timestamp'];
    $latitude = $elem['Latitude'];
    $longitude = $elem['Longitude'];
    $query = "INSERT INTO Gps (UserID, Timestamp, Latitude, Longitude) VALUES ('$userid', '$timestamp', '$latitude', '$longitude')";
    mysql_query($query) or die(mysql_error());
}

echo("COMPLETE");
?>
