export class AdminModel { 

    id? : number;
    emailAddress : string;
    id_person? : number;
    password : string;
    userName : string;
    idRol : number;
    tkR : number;
    lastAccess? : Date;
    name:string;
    surnameOne:string;
    surnameTwo:string;


    constructor(admin? : AdminModel){
        
        if(this.id !== undefined){
            this.id = admin?.id;
        }

        this.emailAddress = admin !== undefined ? admin.emailAddress : '';
        this.password = admin !== undefined ? admin.password : '';
        this.userName = admin !== undefined ? admin.userName : '';
        this.idRol = admin !== undefined ? admin.idRol : 0;
        this.tkR = admin !== undefined ? admin.tkR : 0;
        this.name= admin !== undefined ? admin.name: '';
        this.surnameOne= admin !== undefined ? admin.surnameOne: '';
        this.surnameTwo= admin !== undefined ? admin.surnameTwo: '';
  

        if (this.lastAccess !== undefined) {
            this.lastAccess = admin?.lastAccess;
        }
    }
}