<?php

namespace App\controller;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Container\ContainerInterface;
use PDO;

class Categories extends dbAccess{
    
    const RESOURCE = "Categories";

    private function authenticate($email, $password){
        $data = $this -> searchUser(email : $email);
        //var_dump($data); die();
        return (($data) && (password_verify($password, $data['password'])))?
            ['rol' => $data['idRol']] : null;
    }

    public function filterCategories(Request $request, Response $response, $args){
    
        $data = $request->getQueryParams();
        
        $result = $this -> filterRegister($data, $args, self::RESOURCE);
        
        $status = sizeof($result) > 0 ? 200 : 204;
        $response -> getBody() -> write(json_encode($result));
    
        return $response
            -> withHeader('Content-type', 'Application/json')
            -> withStatus($status);
    }

    public function createCategory(Request $request, Response $response, $args){
        $body = json_decode($request->getBody());
        $result = $this -> createRegister($body, self::RESOURCE);
        return $response->withStatus(200);
    }

    public function deleteCategory(Request $request, Response $response, $args){
        $result = $this -> deleteRegister($args['id'],self::RESOURCE);
        $status = $result > 0 ? 200 : 404;
        return $response->withStatus($status);
    }

    public function editCategory(Request $request, Response $response, $args){
         
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

    
    public function searchCategory(Request $request, Response $response, $args){
            
        $result = $this -> searchRegister(self::RESOURCE, $args['id']);
        $status = !$result ? 404 : 200;

        if($result){
            $response->getBody()->write(json_encode($result));
        }
        return $response
            ->withHeader('Content-type', 'Application/json')
            ->withStatus($status);
    }
}



?>