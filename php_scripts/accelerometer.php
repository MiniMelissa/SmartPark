<?php

require("db_connect.php");

$request = file_get_contents('php://input');
$json = json_decode($request, TRUE);

foreach ($json as $elem) {
    $userid = $elem['UserID'];
    $timestamp = $elem['Timestamp'];
    $x = $elem['X'];
    $y = $elem['Y'];
    $z = $elem['Z'];
    $query = "INSERT INTO Accelerometer (UserID, Timestamp, X, Y, Z) VALUES ('$userid', '$timestamp', '$x', '$y', '$z')";
    mysql_query($query) or die(mysql_error());
}

echo("COMPLETE");

?>
