<?php
// Allow from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific headers
header("Access-Control-Allow-Headers: Origin, Content-Type, Accept, Authorization");

header('Content-Type: application/json');

// Simple JSON response
$response = ['message' => 'Hello from the PHP backend!'];
echo json_encode($response);
?>
