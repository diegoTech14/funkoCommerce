<?php 
    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    //Will use these methods on the routes
    class Person extends dbAccess {
        //const ROLUSER = 0;
        const RESOURCE = "Person";
        const ID = 'id'; // código de West

        public function createPerson(Request $request, Response $response, $args){
            $body = json_decode($request->getBody());
            $body -> password = 
            password_hash($body -> password, PASSWORD_BCRYPT, ['cost' => 10]);
            //var_dump($body); die();
            $result = $this -> createRegisterUser($body, self::RESOURCE, self::ID);
            $status = match($result){
                1,'1' => 201,
                0,'0' => 409,
                2,'2' => 500
            };

            return $response->withStatus($status);
        }

        public function deletePerson(Request $request, Response $response, $args){
            $result = $this -> deleteRegister($args['id'],self::RESOURCE);
            $status = $result > 0 ? 200 : 404;
            return $response->withStatus($status);
        }

        public function searchPerson(Request $request, Response $response, $args){
            
            $result = $this -> searchRegister(self::RESOURCE, $args['id']);
            $status = !$result ? 404 : 200;

            if($result){
                $response->getBody()->write(json_encode($result));
            }
            return $response
                ->withHeader('Content-type', 'Application/json')
                ->withStatus($status);
        }

        public function editPerson(Request $request, Response $response, $args){
         
            $id = $args['id'];
            $body = json_decode($request->getBody());
            $result = $this -> editRegister($body, self::RESOURCE, $id);            
            $status = match($result){
                0,'0' => 404,
                1,'1' => 200,
                2,'2' => 409
            };
            return $response->withStatus($status);
        }
        
        public function filterPerson(Request $request, Response $response, $args){

            $data = $request->getQueryParams();//parámetros que vienen ocultos o encapsulados en el get
            $result = $this -> filterRegister($data, $args, self::RESOURCE);
            $status = sizeof($result) > 0 ? 200 : 204;
            $response -> getBody() -> write(json_encode($result));

            return $response
                -> withHeader('Content-type', 'Application/json')
                -> withStatus($status);
        }

    }