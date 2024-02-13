<?php 
    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    //Will use these methods on the routes
    class Users extends dbAccess {
        
        const RESOURCE = "User";

        private function authenticate($email, $password){
            $data = $this -> searchUser(email : $email);
            //var_dump($data); die();
            return (($data) && (password_verify($password, $data['password'])))?
                ['rol' => $data['idRol']] : null;
        }
        

        public function createUser(Request $request, Response $response, $args){
            $body = json_decode($request->getBody());
            $result = $this -> createRegister($body, self::RESOURCE);
            return $response->withStatus(200);
        }

        public function deleteUser(Request $request, Response $response, $args){
            $result = $this -> deleteRegister($args['id'],self::RESOURCE);
            $status = $result > 0 ? 200 : 404;
            return $response->withStatus($status);
        }
        
        public function editUser(Request $request, Response $response, $args){
         
            $id = $args['id'];
            $body = json_decode($request->getBody());
            $result = $this -> editRegister($body, self::RESOURCE, $id);            
            $status = match($result){
                0 => 404,
                1 => 200,
                2 => 409
            };
            return $response->withStatus($status);
        }
        
        public function filterUser(Request $request, Response $response, $args){

            $data = $request->getQueryParams();//parámetros que vienen ocultos o encapsulados en el get
            $result = $this -> filterRegister($data, $args, self::RESOURCE);
            $status = sizeof($result) > 0 ? 200 : 204;
            $response -> getBody() -> write(json_encode($result));

            return $response
                -> withHeader('Content-type', 'Application/json')
                -> withStatus($status);
        }

        public function changeRol(Request $request, Response $response, $args){
            $body = json_decode($request -> getbody());
            
            $data = $this->editUserSession(idUser:$args['id'], rol:$body->rol);
            
            $status = $data == true ? 200 : 404;
            return $response -> withStatus($status);  
        }

        public function changePassword(Request $request, Response $response, $args){
            
            $body = json_decode($request -> getbody());
            $user = $this -> authenticate($args['emailAddress'], $body -> password);
            
            if($user){
                $data = $this -> editUserSession(emailUser : $args['emailAddress'], passwordNew:Hash::hash($body -> passwordNew));
                $status = 200;
            }else{
                $status = 401;
            }
            
            return $response -> withStatus($status);
        }

        public function resetPassword(Request $request, Response $response, $args){ 
            $body = json_decode($request -> getbody());
            //hacer hash
            $data = $this->editUserSession(emailUser:$args['emailAddress'], passwordNew:Hash::hash($body->passwordNew));
            //var_dump($data); die();
            $status = $data == true ? 200 : 404;
            return $response -> withStatus($status);  
        }

        public function editUserRol(Request $request, Response $response, $args){

            $id = $args['id'];
            $body = json_decode($request->getBody());
            $result = $this -> editRegisterRol($body, self::RESOURCE, $id);
            $status = match($result){
                '0',0 => 404,
                '1',1 => 200,
                '2',2 => 409
            };
            return $response->withStatus($status);
        }
        
    }