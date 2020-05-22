export class Nodo{
    id:number;
    lexema:string;
    tipo:string;
    lstNodo:Array<Nodo>
    tipodato:string="";
    constructor(tipoC:string,lexemaC:string,idC:number){
        this.lstNodo = [];
        this.tipo = tipoC;
        this.lexema=lexemaC;
        this.id = idC;
    }

    searchNode(listaNodo:Array<Nodo>){
        for(let i=0;i<listaNodo.length;i++){
            this.lstNodo.push(listaNodo[i]);
        }
    }

    addLastChildren(NodoAdd:Nodo){
        this.lstNodo[this.lstNodo.length-1].lstNodo.push(NodoAdd);
    }
}