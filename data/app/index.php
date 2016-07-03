<?php
    $link = mysqli_connect('localhost', 'root');
    if ($link) {
        echo  mysqli_get_server_info($link);
        echo "Connect!";
    }

    phpinfo();
?>