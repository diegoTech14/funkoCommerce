<?php
//es como un acceso directo hacía un directorio y se puede utilizar todo lo que contenga dentro

namespace App\controller;
use Slim\Routing\RouteCollectorProxy;

/* 
    123 -> create
    456 -> delete
    789 -> update
    101112 -> search
    131415 -> filter
*/

$app->group('/categories', function(RouteCollectorProxy $category){
    $category -> get('/all/{page}/{limit}', Categories::class . ':filterCategories');
    $category -> get('/{id}', Categories::class . ':searchCategory');
    $category -> post('/', Categories::class . ':createCategory');
    $category -> delete('/delete/{id}', Categories::class . ':deleteCategory');
    $category -> put('/edit/{id}', Categories::class . ':editCategory');
    
});

$app->group('/funko', function (RouteCollectorProxy $funko) {
    $funko -> post('/autom', Funko::class . ':createAutomatically');
    $funko -> post('', Funko::class . ":create");
    $funko -> delete('/{id}', Funko::class . ":delete");
    $funko -> get('/{page}/{limit}', Funko::class . ":filter");
    $funko -> get('/feed', Funko::class . ":filterFeed");
    $funko -> get('/{id}', Funko::class . ":search");
    $funko -> get('/filter/categories/{id}', Funko::class . ":filterCategory");
    $funko -> put('/{id}', Funko::class . ":edit");
});

$app->group('/person', function (RouteCollectorProxy $user) {
    $user -> post('', Person::class . ':createPerson');
    $user -> get('/{id}', Person::class . ':searchPerson');
    $user -> put('/{id}', Person::class . ':editPerson');
    $user -> get('/{page}/{limit}', Person::class . ':filterPerson');
});

$app->group('/rol', function (RouteCollectorProxy $rol) {
    $rol -> post('', Rol::class . ':createRol');
    $rol -> delete('/{id}', Rol::class . ':deleteRol');

});

$app->group('/user', function (RouteCollectorProxy $user) {
    $user -> post('', Users::class . ':createUser');
    $user -> delete('/{id}', Users::class . ':deleteUser');
    $user -> put('/{id}', Users::class . ':editUser');
    $user -> get('/{page}/{limit}', Users::class . ':filterUser');
    $user -> patch('/change-rol/{id}', Users::class . ':changeRol');
    $user -> put('/rol/{id}', Users::class . ':editUserRol');
    
    $user -> group('/password', function(RouteCollectorProxy $user){
        $user -> patch('/change-password/{emailAddress}', Users::class . ':changePassword');
        $user -> patch('/reset-password/{emailAddress}', Users::class . ':resetPassword');
    });
});

$app -> group('/session', function (RouteCollectorProxy $session){
    $session->patch('/initSession/{email}', Session::class . ':initSession2');
    $session->patch('/refreshSession/{id}', Session::class . ':refreshSession');
    $session->patch('/closeSession/{id}', Session::class . ':closeSession');
});

$app -> group('/detailBills', function(RouteCollectorProxy $detailBills){
    $detailBills -> post('', DetailBill::class . ':create');
    $detailBills -> delete('/456/{id}', DetailBill::class . ':delete');
});

$app -> group('/bills', function(RouteCollectorProxy $bills){
    $bills -> post('', Bills::class . ':create');
});