<?php 

    namespace App\controller;
    use Psr\Http\Message\ResponseInterface as Response;
    use Psr\Http\Message\ServerRequestInterface as Request;
    use Psr\Container\ContainerInterface;
    use PDO;

    class dbAccess{

        private $container;

        public function __construct(ContainerInterface $c){
            $this -> container = $c;
        }

        public function generateParameters($data){
            $string = "(";
            foreach($data as $field => $value){
                $string .= ":$field,";
            }
            $string = trim($string, ',');
            return $string.")";
        }

        private function generateRouteImageStore($imageName){
        
            $newPath = "/../../assets/Images/$imageName";
            return $newPath;
        }

        public function createRegister($data, $resource){

                $parameters = $this -> generateParameters($data);
            
                $sql = "SELECT create$resource$parameters;";
                //var_dump($sql); die();
                $dataArray = [];

                foreach($data as $key => $value){
                    $dataArray[$key] = $value;
                }

                $connection = $this -> container -> get('bd');
                $query = $connection -> prepare($sql);
                $query -> execute($dataArray); //devuelve 0 si encontró, 1 duplicados
                $result = $query -> fetch(PDO::FETCH_NUM);
                $query = null;
                $con = null;
                return $result[0];
            
        }

        public function createRegisterFunko($data){
            
            $parameters = $this -> generateParameters($data);            
            $sql = "SELECT createFunko$parameters;";           
            $dataArray = [];

            foreach($data as $key => $value){
                $dataArray[$key] = $value;
            }

            $dataArray['_urlFirstImage'] = $this->generateRouteImageStore($dataArray['_urlFirstImage']);

            $dataArray['_urlSecondImage'] = $this->generateRouteImageStore($dataArray['_urlSecondImage']);
            
            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);
            $query -> execute($dataArray); //devuelve 0 si encontró, 1 duplicados
            $result = $query -> fetch(PDO::FETCH_NUM);
            //var_dump($result); die();
            $query = null;
            $con = null;
            return $result[0];
        }



        public function createRegisterUser($data, $resource, $idField){//recibe el idField porque es para reutilizar y no todos los usuarios son clientes, y solo los clientes tienen idCliente
            $passw = $data->password;
            //unset($data->password);// destruir una variable o destruye el campo del arreglo

            //$resource es el nombre del recurso (la tabla en este caso)
            $parameters = $this -> generateParameters($data);
             
            $connection = $this -> container -> get('bd');
            $connection -> beginTransaction();//permite cancelar el autocommit y generar transacciones manuales
            try{
                $sql = "SELECT create$resource$parameters;";// SELECT nuevoCliente(id, nombre, correo, etc, etc, etc);
                $query = $connection -> prepare($sql);
                $d = [];

                foreach($data as $key => $value){
                    $d[$key] = filter_var($value, FILTER_SANITIZE_SPECIAL_CHARS); //filter_var caracteres indeseables, para ayudar a que no se produzcan las inyecciones sql
                }           

                $query -> execute($d);
                $result = $query -> fetch(PDO::FETCH_NUM)[0];

                $sql = "SELECT createUser(:id_Person, :emailAddress, :password, :userName);";
                $query = $connection -> prepare($sql);

                $d['id'] = $this->lastId();

                $query -> execute(array(
                    'id_Person' => $d[$idField],
                    'emailAddress' => $d['emailAddress'],
                    'password' => $passw,
                    'userName' => $d['userName']
                ));

                $connection->commit();
            }
            catch(PDOException $error){
                print_r($error->getMessage());
                $connection -> rollback();
                $result = 2;
            }
            $query = null;
            $connection = null;
            echo $result;
            return $result;
        }

        public function deleteRegister($id, $resource){
            $sql = "SELECT delete$resource(:id);";
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);
            
            $query->execute(["id" => $id]);
    
            $res = $query->fetch(PDO::FETCH_NUM);
            $query = null;
            $con = null;
    
            return $res[0];
        }

        public function searchRegister($resource, $id){
            $sql = "CALL search$resource(:id);";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute(['id' => $id]);
            $result = $query->fetch(PDO::FETCH_ASSOC);
            $query = null;
            $con = null;
            return $result;
        }

        public function searchFunko($id){
            $sql = "CALL searchFunkoDetail(:id);";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute(['id' => $id]);
            $result = $query->fetch(PDO::FETCH_ASSOC);
            $query = null;
            $con = null;
            return $result;
        }

        public function createDetailBill($data, $resource){
            $result = true;
            try{
                $parameters = $this -> generateParameters($data);
                $sql = "CALL create$resource$parameters;";
                $dataArray = [];
    
                foreach($data as $key => $value){
                    $dataArray[$key] = $value;
                }
                
                $connection = $this -> container -> get('bd');
                $query = $connection -> prepare($sql);

                $query -> execute($dataArray); 
                
            } catch(PDOException $error){
                
                throw new Exception("Internal Server Error", 500);
            }
            
            $query = null;
            $con = null;
            return $result;
        }

        public function editRegister($data, $resource, $id){
            $d['id'] = $id;
            $parameters = $this -> generateParameters($data);
            $parameters = substr($parameters, 0, 1) . ":id," . substr($parameters, 1);
            $sql = "SELECT edit$resource$parameters;";


            foreach($data as $key => $value){
                $d[$key] = $value;
            }

            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);
            //var_dump($query);die();
            $query -> execute($d);
            
            $result = $query->fetch(PDO::FETCH_NUM);
            $query = null;
            $con = null;
            return $result[0];
        }

        public function editUserSession(string $emailUser, int $rol = -1, string $passwordNew = ' '){
            
            $proc = $rol == -1 ? 'SELECT userPassword(:emailAddress, :passw);' : 'SELECT userRol(:id, :rol);';
            
            $sql = "call searchUserByEmail('$emailUser');";
            
            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);
            $query->execute();
            $user = $query->fetch(PDO::FETCH_ASSOC);
            
            
            if($user){
                $parameters = ['emailAddress' => $user['emailAddress']];
                $parameters = $rol == -1 ? array_merge($parameters, ['passw' => $passwordNew]) :
                                        array_merge($parameters, ['rol' => $rol]);
                         
                $query = $connection->prepare($proc);
                
                $return = $query->execute($parameters);
                 
            }else{
                $return = false;
            }

            $query = null;
            $connection = null;
            return $return;
        }

        public function editRegisterFunko($data, $resource, $id){
            $dataArray['id'] = $id;
            $parameters = $this -> generateParameters($data);
            $parameters = substr($parameters, 0, 1) . ":id," . substr($parameters, 1);
            $sql = "SELECT edit$resource$parameters;";
            

            foreach($data as $key => $value){
                $dataArray[$key] = $value;
            }            
            
            $dataArray['_urlFirstImage'] = $this->generateRouteImageStore($dataArray['_urlFirstImage']);
            $dataArray['_urlSecondImage'] = $this->generateRouteImageStore($dataArray['_urlSecondImage']);

            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);

            $query -> execute($dataArray); //devuelve 0 si encontró, 1 duplicados, 2 el cliente no existe
            $result = $query->fetch(PDO::FETCH_NUM);
            $query = null;
            $con = null;
            return $result[0];
        }

        public function filterRegister($data, $args, $resource){
            $limit = $args['limit'];
            $page = ($args['page'] - 1) * $limit;
            
            $stringResult = "";
            foreach($data as $value){
                $stringResult .= "%$value%&";
            }
            
            $sql = "call filter$resource('$stringResult', $page, $limit);";
            
            $con = $this->container->get('bd');

            $query = $con->prepare($sql);

            $query ->execute();
            $res = $query->fetchAll();//extraer todos los datos

            $query = null;
            $con = null;

            $dataR['data'] = $res;
            $dataR['regs'] = $this->numRegsBD($data, $resource);
            
            return $dataR;

        }


        public function numRegsBD($data, $resource){

            $string="";
            foreach($data as $value){
            $string .= "%$value%&";//concatenado de valores
            }

            $sql = "call numRegs$resource('$string');";
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);
            
            $query->execute();

            $res = $query ->fetch(PDO::FETCH_NUM)[0];
            
            $query=null;
            $con=null;

            return $res;
        }

       
        public function filterFunkoFeed(){
            $con = $this-> container -> get('bd');
            $query = $con -> prepare("CALL funkoFeed();");
            $query -> execute();
            $result = $query->fetchAll();
            $query = null;
            $con = null;
            return $result;
        }  

        public function filterFunkoCategory($id){
            $sql = "CALL categoryFilter(:id);";
            $con = $this -> container->get('bd');
            $query = $con -> prepare($sql);
            $query -> execute(['id' => $id]);
            $result = $query->fetchAll();
            $query = null;
            $con = null;
            return $result;
        }

        public function searchUser(string $email){
            $con = $this -> container -> get('bd');
            $query = $con -> prepare("CALL searchUserByEmail('$email');");
            
            $queryla = $query -> execute();
            //var_dump($queryla); die();
            $result = $query->fetch(PDO::FETCH_ASSOC);
            //var_dump($result); die();
            $query = null;
            $con = null;
            return $result;
        }

        public function searchName(int $id, string $userType = "User"){
            $fieldName = "userName";

            if($userType == "Person"){
                $fieldName = "name";
            }

            ($userType == "Person") ? $procedure = 'search' . $userType . "('$id')":
            $procedure = 'search' . $userType . "(0, '$id')";
  
            $sql = "CALL $procedure";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute();
            if($query -> rowCount() > 0){
                $res = $query -> fetch(PDO::FETCH_ASSOC);
            }else{
                $res = [];
            }
            $query = null;
            $con = null;
            
            $res = $res[$fieldName];
            if(str_contains($res, " ")){
                $res = substr($res, 0, strpos($res, " "));
            }
            return $res;
        }

        public function accessToken(string $proc, string $idUser, string $tokenRef = ""){
            $sql = $proc == "modify" ? 
                "SELECT modifyToken(:id_person, :tk);" : 
                "CALL verifyToken(:id_person, :tk);";

            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);
            $query->execute(["id_person" => $idUser, "tk" => $tokenRef]);
            
            if($proc == "modify"){
                $data = $query -> fetch(PDO::FETCH_NUM);

            }else{
                $data = $query -> fetchColumn();
            }

            $query = null;
            $connection = null;
            return $data;
        }

        public function lastId(){
            $sql = "SELECT lastId();";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute();
            $result = $query->fetch(PDO::FETCH_ASSOC);
            $query = null;
            $con = null;
            return $result['lastId()'];
        }

        public function searchName2(string $email, string $userType = "User"){
            $fieldName = "userName";

            if($userType == "PersonByEmail"){
                $fieldName = "name";

            }

            $userType ="UserByEmail";
            $procedure = 'search' . $userType . "('$email')";

            $sql = "CALL $procedure";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute();
            if($query -> rowCount() > 0){
                $res = $query -> fetch(PDO::FETCH_ASSOC);
            }else{
                $res = [];
            }
            $query = null;
            $con = null;
           // var_dump($procedure);die();
            $res = $res[$fieldName];
            if(str_contains($res, " ")){
                $res = substr($res, 0, strpos($res, " "));
            }
            return $res;
        }
        
        public function getIdDirecition(string $email){

            $userType ="PersonByEmail";
            $procedure = 'search' . $userType . "('$email')";
            $sql = "CALL $procedure";
            $con = $this -> container -> get('bd');
            $query = $con -> prepare($sql);
            $query -> execute();
            $id=$query->fetch(PDO::FETCH_ASSOC)['id'];

              $query = null;
              $con = null;
              return $id;
        }

        public function editRegisterRol($data, $resource, $id){
            $d['id'] = $id;
            $parameters = $this -> generateParameters($data);
            $parameters = substr($parameters, 0, 1) . ":id," . substr($parameters, 1);
            $sql = "SELECT edit{$resource}Rol{$parameters};";



            foreach($data as $key => $value){
                $d[$key] = $value;
            }

            $connection = $this -> container -> get('bd');
            $query = $connection -> prepare($sql);
            $query -> execute($d); //devuelve 0 si encontró, 1 duplicados, 2 el cliente no existe
            $result = $query->fetch(PDO::FETCH_NUM);

            $query = null;
            $con = null;
            return $result[0];
        }

        public function searchUser2(string $email){
            $con = $this -> container -> get('bd');

            $query = $con -> prepare("CALL searchUserByEmail('$email');");


            $query -> execute();
            $result = $query->fetch(PDO::FETCH_ASSOC);
            $query = null;
            $con = null;
            return $result;
        }

        //Detail Bills Functions

        
    }
?>