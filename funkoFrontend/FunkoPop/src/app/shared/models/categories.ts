export class CategoryModel { 

    id? : number;
    categoryName : string;

    constructor(funko? : CategoryModel){
        
        if(this.id !== undefined){
            this.id = funko?.id;
        }

        this.categoryName = funko !== undefined ? funko.categoryName : '';
    }
}