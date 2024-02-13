export class SaleDetail {
    id?:number;
    name : string;
    description : string;
    urlFirstImage : string;
    price : number;
    quantity:number;

    constructor(funko?: SaleDetail){
        if(this.id !== undefined){
            this.id = funko?.id;
        }

        this.quantity = funko !== undefined ? funko?.quantity : 0;
        this.name = funko !== undefined ? funko.name : '';
        this.urlFirstImage = funko !== undefined ? funko.urlFirstImage : '';
        this.price = funko !== undefined ? funko.price : 0.0;
        this.description = funko !== undefined ? funko.description : '';
    }
}

