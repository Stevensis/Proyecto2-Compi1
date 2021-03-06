"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express = require("express");
var cors = require("cors");
var bodyParser = require("body-parser");
var gramatica = require("./Analizador/Gramatica");
var NClase = require("./Arbol/Clase");
var NFunciones = require("./Arbol/Funciones");
var NVariables = require("./Arbol/Variables");
var lstVariablesP = [];
var lstVariablesC = [];
var lstClasesC = [];
var lstFuncionesC = [];
var lstVariablesCC = [];
var pruebaClases = new Array();
var pruebaFunciones = new Array();
var pruebaVariables = new Array();
var pruebaErrores = new Array();
var bandera1 = false;
var app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var logger = require('morgan');
app.use(logger('dev'));
app.post('/Analizar/', function (req, res) {
    lstVariablesP = [];
    lstVariablesC = [];
    pruebaErrores = new Array();
    pruebaClases = new Array();
    pruebaFunciones = new Array();
    pruebaVariables = new Array();
    var entrada = req.body.text;
    var resultado = parser(entrada);
    var entrada2 = req.body.text2;
    var resultado2 = parser(entrada2);
    if (resultado[1].length == 0) {
        copiaClase(resultado[0], resultado2[0]);
        var json = JSON.stringify(resultado[0], null, 2);
        json = json.split('lexema').join('text').split('lstNodo').join('children');
        var jsonClases = JSON.stringify(lstClasesC);
        jsonClases = jsonClases.split('canCYM').join('Cantidad_Funciones_metodos');
        imprimir();
        //    console.log(jsonClases);
        //    console.log(json)
        //    tree(resultado)
        res.send({ uno: json, dos: pruebaClases, tres: pruebaFunciones, cuatro: pruebaVariables });
    }
    else {
        var lista = resultado[1];
        console.log("entraqui");
        listaError(lista);
        res.send({ uno: "Error" });
    }
});
function listaError(lstE) {
    for (var index = 0; index < lstE.length; index++) {
        var element = lstE[index].lexema;
        console.log(element);
    }
}
function copiaClase(principal, copia) {
    var MYFPrincipal = [];
    var MYFfCopia = [];
    /*Analizo primero el root principal */
    principal.lstNodo.forEach(function (element) {
        if (element.tipo == "class") {
            MYFPrincipal = [];
            MYFfCopia = [];
            /*por cada calse encontrada, la busco en el otro arbol*/
            copia.lstNodo.forEach(function (element2) {
                if (element2.tipo == "class") {
                    /*Por cada clase que encuentro en el otro root compruebo si son los mismos*/
                    if (element.lexema == element2.lexema) {
                        /*recorro para encontrar los metodos y funciones de la clase principal*/
                        element.lstNodo.forEach(function (element3) {
                            if (element3.tipo == "Funcion") {
                                MYFPrincipal.push(element3.lexema);
                                /*encontramos si tiene parametros la funcion*/
                                element3.lstNodo.forEach(function (parametrosMF) {
                                    if (parametrosMF.tipo == "Parametros") {
                                        var parametroslst = returnLst(parametrosMF.lstNodo);
                                        element2.lstNodo.forEach(function (fmCopia) {
                                            if (fmCopia.tipo == "Funcion" && element3.tipodato == fmCopia.tipodato) {
                                                bandera1 = false;
                                                fmCopia.lstNodo.forEach(function (paramCopia) {
                                                    if (paramCopia.tipo == "Parametros") {
                                                        var parametroslstCopia = returnLst(paramCopia.lstNodo);
                                                        if (parametroslst.toString() == parametroslstCopia.toString()) {
                                                            console.log("las funciones " + element3.lexema + " con retorno " + element3.tipodato + " Son iguales en ambos archivos,por tener los mismos tipos de parametros en el mismo orden" + " de la calse " + element.lexema + " Con parametros " + returnLst2(paramCopia.lstNodo).toString());
                                                            lstFuncionesC.push(new NFunciones.Funciones(element3.tipodato, element3.lexema, returnLst2(paramCopia.lstNodo).toString(), element.lexema));
                                                            pruebaFunciones.push([element3.tipodato, element3.lexema, returnLst2(paramCopia.lstNodo).toString(), element.lexema]);
                                                            /*validacion de copia de las variables*/
                                                            reporteVariables(element3, fmCopia, element.lexema);
                                                            /** Fin validacion copia de variables */
                                                            MYFfCopia.push(element3.lexema);
                                                        }
                                                    }
                                                });
                                            }
                                        });
                                    }
                                });
                            }
                            else if (element3.tipo == "Metodo") {
                                MYFPrincipal.push(element3.lexema);
                                /*encontramos si tiene parametros la funcion*/
                                element3.lstNodo.forEach(function (parametrosF) {
                                    if (parametrosF.tipo == "Parametros") {
                                        var parametroslstM = returnLst(parametrosF.lstNodo);
                                        element2.lstNodo.forEach(function (mCopia) {
                                            if (mCopia.tipo == "Metodo" && element3.lexema == mCopia.lexema) {
                                                mCopia.lstNodo.forEach(function (paramCopiaM) {
                                                    if (paramCopiaM.tipo == "Parametros") {
                                                        var parametroslstCopiaM = returnLst(paramCopiaM.lstNodo);
                                                        if (parametroslstM.toString() == parametroslstCopiaM.toString()) {
                                                            console.log("los metodos " + element3.lexema + " Son iguales en ambos archivos,por tener los mismos tipos de parametros en el mismo orden" + " de la calse " + element.lexema);
                                                            lstFuncionesC.push(new NFunciones.Funciones("void", element3.lexema, returnLst2(parametrosF.lstNodo).toString(), element.lexema));
                                                            pruebaFunciones.push(["void", element3.lexema, returnLst2(parametrosF.lstNodo).toString(), element.lexema]);
                                                            MYFfCopia.push(element3.lexema);
                                                            /*validacion de copia de las variables*/
                                                            reporteVariables(element3, mCopia, element.lexema);
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
                        if (MYFPrincipal.toString() == MYFfCopia.toString()) {
                            console.log("las clases " + element.lexema + " Son iguales en ambos archivos");
                            lstClasesC.push(new NClase.Clase(element.lexema, MYFPrincipal.length + ""));
                            pruebaClases.push([element.lexema, MYFPrincipal.length + ""]);
                        }
                    }
                }
            });
        }
    });
}
function reporteVariables(FuncionP, FuncionC, claseP) {
    lstVariablesP = [];
    lstVariablesC = [];
    FuncionP.lstNodo.forEach(function (element) {
        if (element.lexema == "contenido") {
            FuncionC.lstNodo.forEach(function (element2) {
                if (element2.lexema == "contenido") {
                    tree(element);
                    tree2(element2);
                    /** Teniendo el listado de variables por cada variable verficiamos si existe en la otra lista */
                    lstVariablesP.forEach(function (variablesP) {
                        lstVariablesC.forEach(function (variablesC) {
                            if (variablesP.lexema == variablesC.lexema && variablesP.lstNodo[0].lexema == variablesC.lstNodo[0].lexema) {
                                console.log("La variable de tipo " + variablesP.lexema + " es copia con el id: " + variablesP.lstNodo[0].lexema + " de la funcion: " + FuncionP.lexema);
                                lstVariablesCC.push(new NVariables.Variables(variablesP.lexema, variablesP.lstNodo[0].lexema, FuncionP.lexema, claseP));
                                pruebaVariables.push([variablesP.lexema, variablesP.lstNodo[0].lexema, FuncionP.lexema, claseP]);
                            }
                        });
                    });
                }
            });
        }
    });
}
function imprimir() {
    for (var i = 0; i < pruebaClases.length; i++) {
        //Recorremos el array de cada posición i
        for (var j = 0; j < pruebaClases[i].length; j++) {
            //Creamos un array en cada posición
            console.log(pruebaClases[i][j] + "");
        }
    }
}
function returnLst(lstLista) {
    var temporalLst = [];
    if (lstLista.length > 0) {
        lstLista.forEach(function (element) {
            temporalLst.push(element.tipo);
        });
    }
    return temporalLst;
}
function returnLst2(lstLista) {
    var temporalLst = [];
    if (lstLista.length > 0) {
        lstLista.forEach(function (element) {
            temporalLst.push(element.lexema);
        });
    }
    return temporalLst;
}
function tree(temporal) {
    if (temporal != null) {
        if (temporal.lstNodo != null && temporal.lstNodo.length > 0) {
            for (var index = 0; index < temporal.lstNodo.length; index++) {
                if (temporal.lstNodo[index].tipo == "tipoDato") {
                    lstVariablesP.push(temporal.lstNodo[index]);
                }
                tree(temporal.lstNodo[index]);
            }
        }
    }
}
function tree2(temporal) {
    if (temporal != null) {
        if (temporal.lstNodo != null && temporal.lstNodo.length > 0) {
            for (var index = 0; index < temporal.lstNodo.length; index++) {
                if (temporal.lstNodo[index].tipo == "tipoDato") {
                    lstVariablesC.push(temporal.lstNodo[index]);
                }
                tree(temporal.lstNodo[index]);
            }
        }
    }
}
/*---------------------------------------------------------------*/
var server = app.listen(8080, function () {
    console.log('Servidor escuchando en puerto 8080...');
});
function parser(texto) {
    try {
        return gramatica.parse(texto);
    }
    catch (e) {
        return "Error en compilacion de Entrada: " + e.toString();
    }
}
