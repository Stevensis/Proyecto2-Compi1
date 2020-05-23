import * as NZErrores from "./Error";
export class PError{
    lista: Array<NZErrores.Error>;
    constructor(list:[]){
        this.lista=list;
    }
}
