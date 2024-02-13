<?php 
    namespace App\Controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    class DetailBill extends dbAccess{

        const RESOURCE = "DetailBill";

        public function create(Request $request, Response $response){
            try{
                $body = json_decode($request->getBody(), 1);
                $result = $this -> createDetailBill($body, self::RESOURCE);

                $status = 200;
            }catch (Exception $error){
                $status = 500;
            }
            return $response ->withStatus($status);
        }

        public function delete(Request $request, Response $response, $args){
            $id = $args['id'];
            $result = $this -> deleteRegister($id, self::RESOURCE);
            $status = $result > 0 ? 200 : 404;
            return $response -> withStatus($status);
        }
    }