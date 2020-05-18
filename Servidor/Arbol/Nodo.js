"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Nodo = /** @class */ (function () {
    function Nodo(tipoC, lexemaC, idC) {
        this.lstNodo = [];
        this.tipo = tipoC;
        this.lexema = lexemaC;
        this.id = idC;
    }
    Nodo.prototype.searchNode = function (listaNodo) {
        for (var i = 0; i < listaNodo.length; i++) {
            this.lstNodo.push(listaNodo[i]);
        }
    };
    Nodo.prototype.addLastChildren = function (NodoAdd) {
        this.lstNodo[this.lstNodo.length - 1].lstNodo.push(NodoAdd);
    };
    return Nodo;
}());
exports.Nodo = Nodo;
