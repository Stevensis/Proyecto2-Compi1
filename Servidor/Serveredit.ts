import * as express from "express";
import * as cors from "cors";
import * as bodyParser from "body-parser";
var app=express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var logger = require('morgan');
app.use(logger( 'dev'));
app.post('/Analizar/', function (req, res) {
    var entrada=req.body.text;
    res.send("ppp");
});

/*---------------------------------------------------------------*/
var server = app.listen(8080, function () {
    console.log('Servidor escuchando en puerto 8080...');
});

