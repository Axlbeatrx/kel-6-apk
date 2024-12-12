<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: DELETE");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

// Validasi data
if (!empty($data->id) && !empty($data->user_id)) {
    $query = "DELETE FROM posts WHERE id=:id AND user_id=:user_id";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":id", $data->id);
    $stmt->bindParam(":user_id", $data->user_id);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Post deleted successfully"]);
    } else {
        http_response_code(500); // Internal server error
        echo json_encode(["message" => "Unable to delete post"]);
    }
} else {
    http_response_code(400); // Bad request
    echo json_encode(["message" => "Incomplete data"]);
}
?>
