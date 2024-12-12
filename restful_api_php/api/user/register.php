<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../config/database.php";

// Nonaktifkan PHP Notice agar tidak mengganggu respons JSON
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(E_ALL & ~E_NOTICE);

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

// Pastikan semua data yang dibutuhkan tersedia
if (!empty($data->name) && !empty($data->email) && !empty($data->password)) {
    // Simpan data dalam variabel sebelum dipass ke bindParam
    $name = $data->name;
    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_DEFAULT);

    $query = "INSERT INTO users SET name=:name, email=:email, password=:password";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":name", $name);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":password", $password);

    // Eksekusi statement
    if ($stmt->execute()) {
        http_response_code(200); // OK
        echo json_encode(["message" => "User registered successfully"]);
    } else {
        http_response_code(500); // Internal server error
        echo json_encode(["message" => "Unable to register user"]);
    }
} else {
    http_response_code(400); // Bad request
    echo json_encode(["message" => "Incomplete data"]);
}
