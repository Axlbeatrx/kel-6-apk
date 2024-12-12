<?php
header("Content-Type: application/json");
include_once "../../config/database.php";

$db = (new Database())->getConnection();

$query = "SELECT posts.*, users.name AS author FROM posts JOIN users ON posts.user_id = users.id";
$stmt = $db->prepare($query);
$stmt->execute();

$posts = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($posts);
?>
