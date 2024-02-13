<?php 
    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;


    class Funko extends dbAccess{
    
        const RESOURCE = "Funko";

        public function createAutomatically(Request $request, Response $response, $args){
            $path = "C:\\languagesProjects\\funko-commerce\\funkoBackend\\src\\app\\funkos.json";
            $jsonString = file_get_contents($path);
            $jsonData = json_decode($jsonString, true);
            
            for($count = 0; $count < count($jsonData); $count++){
                
                $result = $this -> createRegister($jsonData[$count], self::RESOURCE);
            }
        
            $status = match($result){ //consultar
                0 => 201,
                1 => 409,
            };
            return $response->withStatus($status);
        }

        public function create(Request $request, Response $response, $args){
            $body = json_decode($request->getBody(), 1);
            $result = $this -> createRegisterFunko($body);

            $status = match($result){
                0 => 201,
                1 => 409
            };
            return $response->withStatus($status);
        }

        public function delete(Request $request, Response $response, $args){
            $id = $args['id'];
            $result = $this -> deleteRegister($id, self::RESOURCE);
            $status = $result > 0 ? 200 : 404;
            return $response -> withStatus($status);
        }

        public function search(Request $request, Response $response, $args){
            $result = $this -> searchFunko($args['id']);
            $status = !$result ? 404 : 200;

            if($result){
                $response->getBody()->write(json_encode($result, JSON_UNESCAPED_SLASHES));
            }
            return $response
            ->withHeader('Content-type', 'Application/json')
            ->withStatus($status);
        }

        public function filter(Request $request, Response $response, $args){

            $data = $request->getQueryParams();
            $result = $this -> filterRegister($data, $args, self::RESOURCE);
            $status = sizeof($result) > 0 ? 200 : 204;
            $response -> getBody() -> write(json_encode($result, JSON_UNESCAPED_SLASHES));
            return $response
                -> withHeader('Content-type', 'Application/json')
                -> withStatus($status);
        }

        public function filterFeed(Request $request, Response $response, $args){
            $result = $this -> filterFunkoFeed();
            $status = ($result) ? 200 : 404; 
            $response -> getBody() -> write(json_encode($result, JSON_UNESCAPED_SLASHES));
            return $response
                -> withHeader('Content-type', 'Application/json')
                -> withStatus($status);
        }
        
        public function filterCategory(Request $request, Response $response, $args){
            $result = $this -> filterFunkoCategory($args['id']);
            $status = ($result) ? 200 : 404;
            $response -> getBody() -> write(json_encode($result, JSON_UNESCAPED_SLASHES));
            return $response 
                -> withHeader('Content-type', 'Application/json')
                -> withStatus($status);
        }



        public function edit(Request $request, Response $response, $args){
            $id = $args['id'];
            $body = json_decode($request->getBody());
            $result = $this -> editRegisterFunko($body, self::RESOURCE, $id);            
            $status = match($result){
                0 => 404,
                1 => 200,
                2 => 409
            };
            return $response->withStatus($status);
        }


    }
?>