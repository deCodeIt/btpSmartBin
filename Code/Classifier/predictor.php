<?php 

putenv('PYTHONPATH=/home/laststnd/.local/lib/python3.5/site-packages');
// putenv('PYTHONPATH=/usr/lib/python3/dist-packages');

$soundFile = 'uploads/P-80_W-0_M-20_17_05_01_11_49_59.wav';
$wifiFile = 'uploads/wifi_data.txt';


$command = escapeshellcmd("/var/www/html/classifier/predictor.py '".$soundFile."' '".$wifiFile."'");
$output = shell_exec($command);
echo $output;

?>