<?php 
 
header('Content-Type: application/json');

$target_dir = "uploads/";
$response = array();

// Check if image file is a actual image or fake image
if (isset($_FILES["file1"])&&isset($_FILES["file2"])) 
{
	$target_file_name1 = $target_dir.basename($_FILES["file1"]["name"]);
	$target_file_name2 = $target_dir.basename($_FILES["file2"]["name"]);

 	if (move_uploaded_file($_FILES["file1"]["tmp_name"], $target_file_name1)
  	&& move_uploaded_file($_FILES["file2"]["tmp_name"], $target_file_name2) ) 
 	{
  	$status = true;
  	$message = "Successfully Uploaded";
  	$soundFile = $target_file_name1;
	$wifiFile = $target_file_name2;


	$command = escapeshellcmd("/var/www/html/classifier/predictor.py '".$soundFile."' '".$wifiFile."'");
	$output = shell_exec($command);
	echo $output;
 	}
 	else 
 	{
  	$status = false;
  	$message = "Error while uploading";
 	}
}
else 
{
 	$status = false;
 	$message = "Required Field Missing";
}

$response["status"] = $status;
$response["message"] = $message;
// echo json_encode($response);

?>