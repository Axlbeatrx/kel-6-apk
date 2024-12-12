<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

// Validasi data
if (!empty($data->id) && !empty($data->user_id) && !empty($data->title) && !empty($data->content)) {
    $query = "UPDATE posts SET title=:title, content=:content WHERE id=:id AND user_id=:user_id";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":id", $data->id);
    $stmt->bindParam(":user_id", $data->user_id);
    $stmt->bindParam(":title", $data->title);
    $stmt->bindParam(":content", $data->content);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Post updated successfully"]);
    } else {
        http_response_code(500); // Internal server error
        echo json_encode(["message" => "Unable to update post"]);
    }
} else {
    http_response_code(400); // Bad request
    echo json_encode(["message" => "Incomplete data"]);
}
?>
