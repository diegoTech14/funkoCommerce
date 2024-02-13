export class FunkoModel { 

    id? : number;
    name : string;
    typeName : string;
    categoryName : string;
    exclusivity : number;
    urlFirstImage : string;
    urlSecondImage : string;
    stock : number;
    price : number;
    description : string;
    categoryID : number;
    productID: number;

    constructor(funko? : FunkoModel){
        
        if(this.id !== undefined){
            this.id = funko?.id;
        }

        this.name = funko !== undefined ? funko.name : '';
        this.typeName = funko !== undefined ? funko.typeName : '';
        this.categoryName = funko !== undefined ? funko.categoryName : '';
        this.categoryID = funko !== undefined ? funko.categoryID : 0;
        this.productID = funko !== undefined ? funko.productID : 0;
        this.exclusivity = funko !== undefined ? funko.exclusivity : 0;
        this.urlFirstImage = funko !== undefined ? funko.urlFirstImage : '';
        this.urlSecondImage = funko !== undefined ? funko.urlSecondImage : '';
        this.stock = funko !== undefined ? funko.stock : 0;
        this.price = funko !== undefined ? funko.price : 0.0;
        this.description = funko !== undefined ? funko.description : '';
    }
}