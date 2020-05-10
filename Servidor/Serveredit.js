"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express = require("express");
var cors = require("cors");
var bodyParser = require("body-parser");
var app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var logger = require('morgan');
app.use(logger('dev'));
app.post('/Analizar/', function (req, res) {
    var entrada = req.body.text;
    console.log(entrada);
    res.send(entrada);
});
/*---------------------------------------------------------------*/
var server = app.listen(8080, function () {
    console.log('Servidor escuchando en puerto 8080...');
});
