<?php
$msg_id = sprintf(
    '<%s-%s@%s>',
    uniqid(time()),
    md5($from.$to),
    $_SERVER['SERVER_NAME']
);
$headers[] = 'Message-ID: '.$msg_id;
