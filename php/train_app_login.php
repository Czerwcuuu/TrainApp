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
$values = array(
    0 => $data[0],
    1 => "Success",
);
if ($count == 1) {
    echo json_encode("Success");
    
}else{
    echo json_encode("Error");
}


?>