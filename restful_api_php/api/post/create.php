<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

if (!empty($data->user_id) && !empty($data->title) && !empty($data->content)) {
    $query = "INSERT INTO posts SET user_id=:user_id, title=:title, content=:content, created_at=NOW()";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":user_id", $data->user_id);
    $stmt->bindParam(":title", $data->title);
    $stmt->bindParam(":content", $data->content);

    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(["message" => "Post added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Unable to add post"]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Incomplete data"]);
}
