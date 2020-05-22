import * as express from "express";
import * as cors from "cors";
import * as bodyParser from "body-parser";
import * as gramatica from "./Analizador/Gramatica";
import * as Nnodo from "./Arbol/Nodo";



var app=express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var logger = require('morgan');
app.use(logger( 'dev'));
app.post('/Analizar/', function (req, res) {
    var entrada=req.body.text;
    var resultado=parser(entrada);
    var entrada2 = req.body.text2;
    var resultado2 = parser(entrada2);
    copiaClase(resultado,resultado2);
    var json = JSON.stringify(resultado,null,2);
    json = json.split('lexema').join('text').split('lstNodo').join('children');
    
//    console.log(json)
//    tree(resultado)
    res.send(json);
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
                                                fmCopia.lstNodo.forEach(paramCopia => {
                                                    if (paramCopia.tipo=="Parametros"){
                                                        var parametroslstCopia = returnLst(paramCopia.lstNodo);
                                                        if (parametroslst.toString()==parametroslstCopia.toString()) {
                                                            console.log("las funciones "+element3.lexema+" Son iguales en ambos archivos,por tener los mismos tipos de parametros en el mismo orden"+" de la calse "+element.lexema);
                                                            /*validacion de copia de las variables*/

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
                                                            MYFfCopia.push(element3.lexema);
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
                        }
                    }
                }
            });
        }
    });
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

function tree(temporal:Nnodo.Nodo){
    if (temporal!=null) {
        if (temporal.lstNodo!=null && temporal.lstNodo.length>0) {
            for (let index = 0; index < temporal.lstNodo.length; index++) {
                    console.log(temporal.lexema+" -> "+temporal.lstNodo[index].lexema)
                
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

