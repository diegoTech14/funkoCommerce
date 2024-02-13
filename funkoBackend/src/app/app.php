<?php 
    use DI\Container;
    use Slim\Factory\AppFactory;
    require __DIR__.'/../../vendor/autoload.php';

    //injecting 
    $cont_aux = new \DI\Container();

    AppFactory::setContainer($cont_aux);

    $app = AppFactory::create();
    
    $app->add(new Tuupola\Middleware\JwtAuthentication([
        "secure" => false,
        "ignore" => ["/session", "/user", "/person", "/funko", "/categories", "/ptypes", "/detailBills", "/bills"],
        "secret" => 'Some key',
        "algoritm" => ["HS256", "HS384"]
    ]));


    
    $container = $app -> getContainer();

    include_once 'routes.php';
    include_once 'config.php';
    include_once 'connection.php';
    

    $app->run();
?>