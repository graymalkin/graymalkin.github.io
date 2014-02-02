<?php
$filename = "graymalkin.json";
if(time()-filemtime($filename) > 12 * 3600 || isset($_GET['update']))
{
// The file is over 12 hours old, we should get it again, then echo it's contents
shell_exec("wget http://osrc.dfm.io/graymalkin.json -O /var/www/graymalkin.json &");
echo file_get_contents("graymalkin.json");
}
else
{
// The file is less than 12 hours old, let's just echo out the local cache
echo file_get_contents("graymalkin.json");
}

?>
