<?php
$db_host = "127.0.0.1";
$db_name = "trainapp_accounts";
$db_user = "root";
$db_pass = "";
$con = mysqli_connect($db_host,$db_user,$db_pass,$db_name);

if(!$con){
    echo json_encode("problem z polaczeniem z baza danych");
}
else{
    echo json_encode("polaczenie powiodlo sie");
}





?>