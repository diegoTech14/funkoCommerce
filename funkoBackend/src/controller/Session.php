<?php

    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use Firebase\JWT\JWT;

    class Session extends dbAccess{

        CONST USER_TYPE = [
            1 => "User",
            3 => "Person",
            4 => "Client" //debemos crear los clientes
        ];

        private function modifyToken(string $idUser, string $tokenRef = " "){
            return $this->accessToken('modify', $idUser, $tokenRef);
        }

        private function verifyToken(string $idUser, string $tokenRef){
            return $this->accessToken('verify', $idUser, $tokenRef);
        }

        public function generateToken(string $idUser, int $rol, string $name){
            $key = "Some key";
            $payload = [
                'iss' => $_SERVER['SERVER_NAME'],
                'iat' => time(),
                'exp' => time() + 520,
                'sub' => $idUser,
                'rol' => $rol,
                'nom' => $name // nom es una variable propiamente creada
            ];

            $payloadRef = [
                'iss' => $_SERVER['SERVER_NAME'],
                'iat' => time(),
                'rol' => $rol,
            ];

            $tkRef = JWT::encode($payloadRef, $key, 'HS256');
            $this -> modifyToken($idUser, $tkRef);

            return [
                "token" => JWT::encode($payload, $key, 'HS256'),
                "refreshToken" => $tkRef
            ];
        }

        private function authenticate($idUser, $passw){
            $data = $this -> searchUser(idUser: $idUser);// arreglo asociativo
            return (($data) && (password_verify($passw, $data['password']))) ?
                ['rol' => $data['idRol']] : null; 
            
            }

        public function initSession(Request $request, Response $response, $args){
            $body = json_decode($request -> getbody());
            $res = $this -> authenticate($args['id'], $body -> password);
            if($res){
                $name = $this -> searchName($args['id'], self::USER_TYPE[$res['rol']]); 
                $tokens = $this -> generateToken($args['id'], $res['rol'], $name);
                $response -> getBody() -> write(json_encode($tokens));

                $status = 200;
            }else{
                $status = 401;
            }

            return $response
                    ->withHeader('Content-type', 'Application/json')
                    ->withStatus($status);
        }

        public function refreshSession(Request $request, Response $response, $args){
            $body = json_decode($request->getBody());
            $rol = $this -> verifyToken($args['id'], $body->tkRef);
            if($rol){
                $name = $this -> searchName($args['id'], self::USER_TYPE[$rol]);
                $tokens = $this -> generateToken($args['id'], $rol, $name);
            }
            if(isset($tokens)){
                $status = 200;
                $response -> getBody()->write(json_encode($tokens));
            }else{
                $status = 401;
            }

            return $response 
                -> withHeader('Content-Type', 'Application/json')
                -> withStatus($status);

        }

        public function closeSession(Request $request, Response $response, $args){
            $this -> modifyToken(idUser:$args['id']);
            return $response -> withStatus(200);
        }

        
        private function authenticate2($email, $passw){
            $data = $this -> searchUser2(email: $email);// arreglo asociativo

            return (($data) && (password_verify($passw, $data['password']))) ?
                ['rol' => $data['idRol']] : null; 

            }

        public function initSession2(Request $request, Response $response, $args){
            $body = json_decode($request -> getbody());
            $res = $this -> authenticate2($args['email'], $body -> password);
            
            if($res){
                $name = $this -> searchName2($args['email'], self::USER_TYPE[$res['rol']]);
                $tokens = $this -> generateToken($args['email'], $res['rol'], $name);

                $response -> getBody() -> write(json_encode($tokens));

                $status = 200;
            }else{
                $status = 401;
            }

            return $response
                    ->withHeader('Content-type', 'Application/json')
                    ->withStatus($status);
        }
    }