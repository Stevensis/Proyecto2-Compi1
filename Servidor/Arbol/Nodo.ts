export class Nodo{
    id:number;
    lexema:string;
    tipo:string;
    lstNodo:Array<Nodo>

    constructor(tipoC:string,lexemaC:string,idC:number){
        this.lstNodo = [];
        this.tipo = tipoC;
        this.lexema=lexemaC;
        this.id = idC;
    }

    encontrarNode(listaNodo:Array<Nodo>){
        for(let i=0;i<listaNodo.length;i++){
            this.lstNodo.push(listaNodo[i]);
        }
    }
}