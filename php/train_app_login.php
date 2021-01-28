<?php
require_once("dbconfig.php");

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM trainapp WHERE name = '".$username."' AND pass = '".$password."'";

$result = mysqli_query($con,$sql);
//var_dump(mysqli_error($db));
$data = mysqli_fetch_array($result);
$count = mysqli_num_rows($result);
$id = $data[0];

if ($count == 1) {
    echo json_encode(data[0]);
    
}else{
    echo json_encode(0);
}


?>