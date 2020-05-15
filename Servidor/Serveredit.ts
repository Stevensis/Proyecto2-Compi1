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
    var json = JSON.stringify(resultado,null,2);
    json = json.split('lexema').join('text').split('lstNodo').join('children');
    console.log(json)
    tree(resultado)
    res.send(json);
});

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

