export class User{

    email :string ='';
    nombre :string =''; 
    rol:number=-1;

    constructor (us?: User){
        this.email =us !==undefined ? us.email :'';
        this.nombre =us !==undefined ? us.nombre :'';
        this.rol=us!==undefined ? us.rol :-1;
    }
}