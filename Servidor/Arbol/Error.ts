export class Error{
    id: number;
    tipo: string;
    lexema: string;
    fila: string;
    columna: string;

    constructor(id:number,tipo:string,lexema:string,fila:string,columna:string){
        this.id=id;
        this.tipo = tipo;
        this.lexema = lexema;
        this.fila = fila;
        this.columna = columna;
    }
    
}