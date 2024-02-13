<?php

    use Psr\Container\ContainerInterface;

    $container->set('bd', function(ContainerInterface $c){
        $conf = $c->get('config_bd');
        $opc = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ
        ];
        //cadena de conexión
        $dsn = "mysql:host=$conf->host;dbname=$conf->bd;charset=$conf->charset";
        try{
            $connection = new PDO($dsn, $conf->usr, $conf->pass, $opc);
        }catch(PDOException $error){
            print "Error: " . $error->getMessage() . "<br>"; // quitar en producción
            die();
        }
        return $connection;
    });
?>