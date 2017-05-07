<?php 

putenv('PYTHONPATH=/home/laststnd/.local/lib/python3.5/site-packages');
// putenv('PYTHONPATH=/usr/lib/python3/dist-packages');

$command = escapeshellcmd('/var/www/html/classifier/predictor.py');
$output = shell_exec($command);
echo $output;

?>