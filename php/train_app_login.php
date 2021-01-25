<?php
require_once("dbconfig.php");

$email = $_POST["email"];
$pass = $_POST["pass"];

//check account exists
$query = "SELECT * FROM trainapp_accounts WHERE email='test'";
$res = mysqli_query($con,$query);
$data = mysqli_fetch_array($res);

// data[0] = id, data[1] = name, data[2] = email, data[3] = password
if($data[1]>=1){
    //acount exists
    $query = "SELECT * FROM trainapp_accounts WHERE pass LIKE '$pass'";
    $res = mysqli_query($con,$query);
    $data = mysqli_fetch_array($res);

    if($data[3] == $pass){
        // password matched
        $resarr = array();
        array_push($resarr,array("email"=>$data[2],"pass"=>$data[3],));
        json_encode(array("result"=>$resarr));
    }else{
        echo json_encode("false");
        //incorrect password
    }

}else{
    echo json_encode("xxx");
    //acount not exists, Create a new account
}


?>