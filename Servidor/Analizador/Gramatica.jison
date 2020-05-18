
/*------------------------------------------------IMPORTS----------------------------------------------*/
%{
    let NNodo=require('../Arbol/Nodo');
    let contador=0;
%}


/*------------------------------------------------Scanner------------------------------------------------*/
%lex
%%


"++"    return 'tk_incremento'
"--"    return 'tk_decremento'

"*"     return 'tk_multiplicacion'
"/"     return 'tk_division'
"-"     return 'tk_resta'
"+"     return 'tk_suma'
"%"     return 'tk_modulo';
"^"     return 'tk_potencia';
"{"     return 'tk_llaveIz';
"}"     return 'tk_llaveDe';

"&&"    return 'tk_and';
"||"    return 'tk_or';
"!"     return 'tk_not'
"!="    return 'tk_distinto';
"=="    return 'tk_igualdad';
"="     return 'tk_igual'
">="    return 'tk_mayorigualque';
"<="    return 'tk_menorigualque';
">"     return 'tk_mayorque';
"<"     return 'tk_menorque';


"["     return 'tk_corcheteIz';
"]"     return 'tk_corcheteDe';
":"     return 'tk_dospuntos';
";"     return 'tk_puntoycoma';
"("     return 'tk_parentecisIz';
")"     return 'tk_parentecisDe';
","     return 'tk_coma';

"int"   return 'tk_int'
"double"    return 'tk_double'
"boolean"   return 'tk_bolean'
"char"  return 'tk_char'
"String"    return 'tk_String'
"true"  return 'tk_true'
"false" return 'tk_false'
"if"    return 'tk_if'
"else"  return 'tk_else'
"switch"    return 'tk_switch'
"case"      return 'tk_case'
"break"     return 'tk_break'
"while"     return 'tk_while'
"do"        return 'tk_do'
"for"       return 'tk_for'
"continue"  return 'tk_continue'
"return"    return 'tk_return'
"main"      return 'tk_main'
"import"    return 'tk_import'
"class"     return 'tk_class'
"void"     return 'tk_void'


(\"[^"]*\")             return 'tk_cadena';
(\'[^']\')              return'tk_caracter';

[0-9]+"."[0-9]+     %{  return 'tk_decimal'; %} 
[0-9]+              %{  return 'tk_entero';  %} 
([a-zA-Z]|[_])[a-zA-Z0-9_]*  %{  return 'tk_id';  %}


"//".*  { }								
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {    }

[ \t\r\n\f] %{ /*se ignoran*/ %}


<<EOF>>     %{  return 'EOF';   %}

.           { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
    
/lex

%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS

%start S
%% 

S : INICIO EOF { return $$=$1; return $$; }
      ;
INICIO :    IMPORTC CLASSP { $$= new NNodo.Nodo("Root","Root",contador++); $$.searchNode($1); $$.searchNode($2); }
      |     CLASSP      { $$= new NNodo.Nodo("Root","Root",contador++);$$.searchNode($1);  }
      ;
/*Creamos imports*/
IMPORTC :   IMPORTC tk_import tk_id tk_puntoycoma { $$=$1; $$.push(new NNodo.Nodo("Import",$2+" "+$3,contador++)) }
      |     tk_import tk_id tk_puntoycoma { $$=[]; $$.push(new NNodo.Nodo("Import",$1+" "+$2,contador++))  }
      ;
/*Declarmos la clase*/
CLASSP :    CLASSP tk_class tk_id tk_llaveIz CUERPOCLASS tk_llaveDe { let temp = new NNodo.Nodo("class",$2+" "+$3,contador++); temp.searchNode($5); $$=$1; $$.push(temp); }
      |     tk_class tk_id tk_llaveIz CUERPOCLASS tk_llaveDe { $$=[]; let temp2 = new NNodo.Nodo("class",$1+" "+$2,contador++); temp2.searchNode($4); $$.push(temp2); }
      ;
/*recuersivo la delcaracion de clases*/
CUERPOCLASS:  CUERPOCLASS CUERPOCLASS2 {$$=$1; $$.push($2);}
      |        CUERPOCLASS2 {$$=[]; $$.push($1);}
      ;
/*Lo que vendra adentro del cuerpo de la clase*/
CUERPOCLASS2: DECLARACIONVARIABLE tk_puntoycoma {$$=$1;}
      |       DECLARACIONMETODO {$$=$1;}
      ;
/*Declaracion de variables*/
DECLARACIONVARIABLE: DATETIPO LSTIDS {$$=new NNodo.Nodo("tipoDato",$1+"",contador++); $$.searchNode($2);}
      |     DATETIPO LSTIDS tk_igual ASIGNACIONVARIABLE {$$=new NNodo.Nodo("tipoDato",$1+"",contador++); $$.searchNode($2); $$.addLastChildren($4)}
      ;
/*E l listado de ids se se declaran mas variables*/
LSTIDS: LSTIDS tk_coma tk_id { $$=$1; $$.push(new NNodo.Nodo("ID",$3+"",contador++)); }
      | tk_id { $$=[]; $$.push(new NNodo.Nodo("ID",$1+"",contador++));  }
;
/*Declaracion de metodo*/
DECLARACIONMETODO: tk_void tk_id tk_parentecisIz tk_parentecisDe tk_llaveIz tk_llaveDe {$$=new NNodo.Nodo("Metodo",$2+"",contador++);}
      |     tk_void tk_id tk_parentecisIz PARAMETROSF_M tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$=new NNodo.Nodo("Metodo",$2+"",contador++);  $$.searchNode($4); let temp4 = new NNodo.Nodo("ContenidoM","Contenido",contador++); temp4.searchNode($7); $$.lstNodo.push(temp4); }
      |     tk_void tk_id tk_parentecisIz  tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$=new NNodo.Nodo("Metodo",$2+"",contador++); let temp3 = new NNodo.Nodo("ContenidoM","Contenido",contador++); temp3.searchNode($6); $$.lstNodo.push(temp3);  }
      |     tk_void tk_id tk_parentecisIz PARAMETROSF_M tk_parentecisDe tk_llaveIz  tk_llaveDe {$$=new NNodo.Nodo("Metodo",$2+"",contador++); $$.searchNode($4);}
;
/*Paramteris que puede tener una funcion o metodo*/
PARAMETROSF_M: PARAMETROSF_M tk_coma DATETIPO tk_id {$$=$1; $$.push(new NNodo.Nodo("Parametro",$3+" "+$4,contador++));}
      |        DATETIPO tk_id {$$=[]; $$.push(new NNodo.Nodo("Parametro",$1+" "+$2,contador++));}
;
/*Contendra las sentencias que pueden ir en un metodo*/
ANALISISMEDIO: ANALISISMEDIO ANALISISMEDIO2 {$$=$1; $$.push($2);}
      |        ANALISISMEDIO2 {$$=[]; $$.push($1);}
;
ANALISISMEDIO2: DECLARACIONVARIABLE tk_puntoycoma {$$=$1;}
;
/*Verifica cual tipo de dato de esta declando*/
DATETIPO: tk_int
      |   tk_String
      |   tk_double
      |   tk_bolean
      |   tk_char
;
/*Asignamos algo despues de un =*/
ASIGNACIONVARIABLE: VALUES {$$=$1;}
      | ASIGNACIONVARIABLE SIGNOSA ASIGNACIONVARIABLE {$$=new NNodo.Nodo("OperacionA",$2+"",contador++); $$.lstNodo.push($1); $$.lstNodo.push($3);}
      | VALUES tk_incremento {$$=$1; $$.lstNodo.push(new NNodo.Nodo("Incremento","+1",contador++));}
      | VALUES tk_decremento {$$=$1; $$.lstNodo.push(new NNodo.Nodo("Decremento","-1",contador++));}
      | tk_parentecisIz ASIGNACIONVARIABLE tk_parentecisDe {$$=$2;}
      | tk_resta ASIGNACIONVARIABLE {$$=$2;}
      ;
/*Produccion cuando se llama a un metodo*/
METODOCALL: tk_id tk_parentecisIz tk_parentecisDe { $$= new NNodo.Nodo("MetodoLlamada",$1+"",contador++);}
      |     tk_id tk_parentecisIz LISTLLAMADA tk_parentecisDe { $$= new NNodo.Nodo("MetodoLlamada",$1+"",contador++); $$.searchNode($3);}
      ;
/*Si el metodo pide parametros, produccion para los parametros que piden*/
LISTLLAMADA: LISTLLAMADA tk_coma ASIGNACIONVARIABLE {$$=$1; $$.push($3);}
      |      ASIGNACIONVARIABLE {$$=[]; $$.push($1);}
      ;      
/*Varificamos signos de aritmetica*/
SIGNOSA: tk_suma
      | tk_resta
      | tk_multiplicacion
      | tk_division
      | tk_potencia
      | tk_modulo
      ;
/*Los posibles valores que puede tener una variable*/
VALUES: tk_cadena { $$ = new NNodo.Nodo("Cadena",$1+"",contador++); }
      |  tk_true  { $$ = new NNodo.Nodo("true",$1+"",contador++); }
      |  tk_false { $$ = new NNodo.Nodo("false",$1+"",contador++); }
      |  METODOCALL { $$=$1;}
      |  tk_entero { $$ = new NNodo.Nodo("Entero",$1+"",contador++); }
      |  tk_decimal { $$ = new NNodo.Nodo("Decimal",$1+"",contador++); }
      |  tk_caracter { $$ = new NNodo.Nodo("Caracter",$1+"",contador++); }
      |  tk_id { $$ = new NNodo.Nodo("Id",$1+"",contador++); }
      ;
