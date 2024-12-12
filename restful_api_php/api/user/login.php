<?php
header("Content-Type: application/json");
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

if (!empty($data->email) && !empty($data->password)) {
    $query = "SELECT * FROM users WHERE email = ?";
    $stmt = $db->prepare($query);
    $stmt->execute([$data->email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($data->password, $user['password'])) {
        echo json_encode(["id" => $user['id'], "name" => $user['name']]);
    } else {
        echo json_encode(["message" => "Invalid email or password"]);
    }
} else {
    echo json_encode(["message" => "Incomplete data"]);
}
?>
