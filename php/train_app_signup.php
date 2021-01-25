<?php
require_once("dbconfig.php");

$email = $_POST["email"];
$pass = $_POST["pass"];

$query = "SELECT * FROM trainapp_accounts WHERE email LIKE '100'";
$res = mysqli_query($con,$query);
$data = mysqli_fetch_array($res);

if($data[0]>=1){
    echo json_encode("konto już istnieje");
}else{
    $query = "INSERT INTO trainapp_accounts (email,pass) VALUES ('$email','$pass')";
    $res = mysqli_query($con,$query);
}
?>