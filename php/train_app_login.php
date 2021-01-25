<?php
require_once("dbconfig.php");

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM trainapp WHERE name = '".$username."' AND pass = '".$password."'";

$result = mysqli_query($con,$sql);
//var_dump(mysqli_error($db));
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode("Success");
}else{
    echo json_encode("Error");
}


?>