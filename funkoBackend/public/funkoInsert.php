<?php
    $path = "C:\\languagesProjects\\funko-commerce\\funkoBackend\\src\\app\\funkos.json";
    $jsonString = file_get_contents($path);
    $jsonData = json_decode($jsonString, true);
    var_dump($jsonData);
?>