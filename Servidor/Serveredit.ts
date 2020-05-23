import * as express from "express";
import * as cors from "cors";
import * as bodyParser from "body-parser";
import * as gramatica from "./Analizador/Gramatica";
import * as Nnodo from "./Arbol/Nodo";
import * as NClase from "./Arbol/Clase";
import * as NFunciones from "./Arbol/Funciones";
import * as NVariables from "./Arbol/Variables";

var lstVariablesP: Array<Nnodo.Nodo> = [];
var lstVariablesC: Array<Nnodo.Nodo> = [];
var lstClasesC: Array<NClase.Clase> = [];
var lstFuncionesC: Array<NFunciones.Funciones> =[];
var lstVariablesCC: Array<NVariables.Variables> =[];

var pruebaClases: string[][] = new Array();
var pruebaFunciones: string[][] = new Array();
var pruebaVariables: string[][] = new Array();

var bandera1: boolean = false;
var app=express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var logger = require('morgan');
app.use(logger( 'dev'));
app.post('/Analizar/', function (req, res) {
    lstVariablesP = [];
    lstVariablesC = [];
    pruebaClases= new Array();
    pruebaFunciones = new Array();
    pruebaVariables = new Array();
    var entrada=req.body.text;
    var resultado=parser(entrada);
    var entrada2 = req.body.text2;
    var resultado2 = parser(entrada2);
    copiaClase(resultado,resultado2);
    var json = JSON.stringify(resultado,null,2);
    json = json.split('lexema').join('text').split('lstNodo').join('children');
    var jsonClases = JSON.stringify(lstClasesC);
    jsonClases = jsonClases.split('canCYM').join('Cantidad_Funciones_metodos');
    imprimir();
//    console.log(jsonClases);
//    console.log(json)
//    tree(resultado)
    res.send({uno:json,dos:pruebaClases,tres:pruebaFunciones,cuatro:pruebaVariables});
});

function copiaClase(principal:Nnodo.Nodo,copia:Nnodo.Nodo){
    
    var MYFPrincipal:Array<String> =[];
    var MYFfCopia:Array<String> =[];
    /*Analizo primero el root principal */
    principal.lstNodo.forEach(element => {
        if (element.tipo=="class") {
            MYFPrincipal = [];
            MYFfCopia = [];
            /*por cada calse encontrada, la busco en el otro arbol*/ 
            copia.lstNodo.forEach(element2 => {
                if (element2.tipo=="class") {
                    /*Por cada clase que encuentro en el otro root compruebo si son los mismos*/ 
                    if (element.lexema==element2.lexema) {
                        /*recorro para encontrar los metodos y funciones de la clase principal*/
                        element.lstNodo.forEach(element3 => {
                            if(element3.tipo=="Funcion"){
                                MYFPrincipal.push(element3.lexema);
                                /*encontramos si tiene parametros la funcion*/ 
                                element3.lstNodo.forEach(parametrosMF => {
                                    if(parametrosMF.tipo=="Parametros"){
                                        var parametroslst = returnLst(parametrosMF.lstNodo);
                                        element2.lstNodo.forEach(fmCopia => {
                                            if (fmCopia.tipo=="Funcion" && element3.tipodato==fmCopia.tipodato) {
                                                bandera1=false;
                                                fmCopia.lstNodo.forEach(paramCopia => {
                                                    if (paramCopia.tipo=="Parametros"){
                                                        var parametroslstCopia = returnLst(paramCopia.lstNodo);
                                                        if (parametroslst.toString()==parametroslstCopia.toString()) {

                                                            console.log("las funciones "+element3.lexema+" con retorno "+element3.tipodato+" Son iguales en ambos archivos,por tener los mismos tipos de parametros en el mismo orden"+" de la calse "+element.lexema+" Con parametros "+returnLst2(paramCopia.lstNodo).toString());
                                                            lstFuncionesC.push(new NFunciones.Funciones(element3.tipodato,element3.lexema,returnLst2(paramCopia.lstNodo).toString(),element.lexema));
                                                            pruebaFunciones.push([element3.tipodato,element3.lexema,returnLst2(paramCopia.lstNodo).toString(),element.lexema]);
                                                            /*validacion de copia de las variables*/
                                                            reporteVariables(element3,fmCopia,element.lexema);
                                                            /** Fin validacion copia de variables */
                                                            MYFfCopia.push(element3.lexema);
                                                        }
                                                    }
                                                });
                                            }
                                        });
                                    }
                                });
                            }else if(element3.tipo=="Metodo"){
                                MYFPrincipal.push(element3.lexema);
                                /*encontramos si tiene parametros la funcion*/ 
                                element3.lstNodo.forEach(parametrosF => {
                                    if(parametrosF.tipo=="Parametros"){
                                        var parametroslstM = returnLst(parametrosF.lstNodo);
                                        element2.lstNodo.forEach(mCopia => {
                                            if (mCopia.tipo=="Metodo" && element3.lexema==mCopia.lexema) {
                                                mCopia.lstNodo.forEach(paramCopiaM => {
                                                    if (paramCopiaM.tipo=="Parametros"){
                                                        var parametroslstCopiaM = returnLst(paramCopiaM.lstNodo);
                                                        if (parametroslstM.toString()==parametroslstCopiaM.toString()) {
                                                            console.log("los metodos "+element3.lexema+" Son iguales en ambos archivos,por tener los mismos tipos de parametros en el mismo orden"+" de la calse "+element.lexema);
                                                            lstFuncionesC.push(new NFunciones.Funciones("void",element3.lexema,returnLst2(parametrosF.lstNodo).toString(),element.lexema));
                                                            pruebaFunciones.push(["void",element3.lexema,returnLst2(parametrosF.lstNodo).toString(),element.lexema]);
                                                            MYFfCopia.push(element3.lexema);
                                                            /*validacion de copia de las variables*/
                                                            reporteVariables(element3,mCopia,element.lexema);
                                                            /** Fin validacion copia de variables */                                                            
                                                        }
                                                    }
                                                });
                                            }
                                        });
                                    }
                                });
                            }
                        });
                        if(MYFPrincipal.toString()==MYFfCopia.toString()){
                            console.log("las clases "+element.lexema+" Son iguales en ambos archivos");
                            lstClasesC.push(new NClase.Clase(element.lexema,MYFPrincipal.length+""));
                            pruebaClases.push([element.lexema,MYFPrincipal.length+""]);
                        }
                    }
                }
            });
        }
    });
}

function reporteVariables(FuncionP:Nnodo.Nodo, FuncionC:Nnodo.Nodo,claseP:string){
    lstVariablesP=[];
    lstVariablesC=[];
    FuncionP.lstNodo.forEach(element => {
        if(element.lexema=="contenido"){
            
            FuncionC.lstNodo.forEach(element2 => {
                if (element2.lexema=="contenido") {
                    tree(element);
                    tree2(element2);
                    /** Teniendo el listado de variables por cada variable verficiamos si existe en la otra lista */
                    lstVariablesP.forEach(variablesP => {
                        lstVariablesC.forEach(variablesC => {
                            if (variablesP.lexema==variablesC.lexema && variablesP.lstNodo[0].lexema==variablesC.lstNodo[0].lexema) {
                                console.log("La variable de tipo "+variablesP.lexema+" es copia con el id: "+variablesP.lstNodo[0].lexema+" de la funcion: "+FuncionP.lexema);
                                lstVariablesCC.push(new NVariables.Variables(variablesP.lexema,variablesP.lstNodo[0].lexema,FuncionP.lexema,claseP));
                                pruebaVariables.push([variablesP.lexema,variablesP.lstNodo[0].lexema,FuncionP.lexema,claseP]);
                            }
                        });
                    });
                }
            });
        }
    });

}

function imprimir(){
    for(var i=0; i<pruebaClases.length; i++) {
        //Recorremos el array de cada posición i
        for(var j=0; j<pruebaClases[i].length; j++) {
            //Creamos un array en cada posición
            console.log(pruebaClases[i][j]+"");
            }
        }
}

function returnLst(lstLista:Array<Nnodo.Nodo>):Array<String>{
    var temporalLst:Array<String>=[];
    if(lstLista.length>0){
        lstLista.forEach(element => {
            temporalLst.push(element.tipo);
        }); 
    }
    
    return temporalLst;
}

function returnLst2(lstLista:Array<Nnodo.Nodo>):Array<String>{
    var temporalLst:Array<String>=[];
    if(lstLista.length>0){
        lstLista.forEach(element => {
            temporalLst.push(element.lexema);
        }); 
    }
    
    return temporalLst;
}

function tree(temporal:Nnodo.Nodo){
    if (temporal!=null) {
        if (temporal.lstNodo!=null && temporal.lstNodo.length>0) {
            for (let index = 0; index < temporal.lstNodo.length; index++) {
                    if(temporal.lstNodo[index].tipo=="tipoDato"){
                        lstVariablesP.push(temporal.lstNodo[index]);
                    }
                tree(temporal.lstNodo[index])
            }
        }
    }
}

function tree2(temporal:Nnodo.Nodo){
    if (temporal!=null) {
        if (temporal.lstNodo!=null && temporal.lstNodo.length>0) {
            for (let index = 0; index < temporal.lstNodo.length; index++) {
                    if(temporal.lstNodo[index].tipo=="tipoDato"){
                        lstVariablesC.push(temporal.lstNodo[index]);
                    }
                tree(temporal.lstNodo[index])
            }
        }
    }
}
/*---------------------------------------------------------------*/
var server = app.listen(8080, function () {
    console.log('Servidor escuchando en puerto 8080...');
});

function parser(texto:string) {
    try {
        return gramatica.parse(texto);
    } catch (e) {
        return "Error en compilacion de Entrada: "+ e.toString();
    }
}

