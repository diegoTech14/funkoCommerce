<?php

    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    class Bills extends dbAccess{
        const RESOURCE = "Bill";
        
        public function create(Request $request, Response $response, $args){
            $body = json_decode($request->getBody(), 1);
            $result = $this -> createRegister($body, self::RESOURCE);
    
            $status = match($result){
                0 => 201,
                1 => 409
            };
                return $response->withStatus($status);
            }
    }
?>