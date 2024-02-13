<?php 
    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    //Will use these methods on the routes
    class Rol extends dbAccess {
        
        const RESOURCE = "Rol";

        public function createRol(Request $request, Response $response, $args){
            $body = json_decode($request->getBody());
            $result = $this -> createRegister($body, self::RESOURCE);
            return $response->withStatus(200);
        }

        public function deleteRol(Request $request, Response $response, $args){
            $result = $this -> deleteRegister($args['id'],self::RESOURCE);
            $status = $result > 0 ? 200 : 404;
            return $response->withStatus($status);


        }

     
    }
     