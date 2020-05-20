
/*------------------------------------------------IMPORTS----------------------------------------------*/
%{
    let NNodo=require('../Arbol/Nodo');
    let contador=0;
%}


/*------------------------------------------------Scanner------------------------------------------------*/
%lex
%%

"//".*   {};

[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]    {};

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
"."     return 'tk_punto';
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
"import"    return 'tk_import'
"class"     return 'tk_class'
"void"      return 'tk_void'
"System"    return 'tk_System'
"out"       return 'tk_out'
"println"   return 'tk_println'
"print"     return 'tk_print'
"default"   return 'tk_default'

(\"[^"]*\")             return 'tk_cadena';
(\'[^']\')              return'tk_caracter';

[0-9]+"."[0-9]+     %{  return 'tk_decimal'; %} 
[0-9]+              %{  return 'tk_entero';  %} 
([a-zA-Z]|[_])[a-zA-Z0-9_]*  %{  return 'tk_id';  %}


[ \t\r\n\f] %{ /*se ignoran*/ %}


<<EOF>>     %{  return 'EOF';   %}

.           { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
    
/lex


%left tk_igualdad, tk_distinto, tk_not
%left tk_mayorigualque, tk_menorigualque, tk_menorque, tk_mayorque
%left tk_or
%left tk_and
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
      |       DECLARACIONFUNCION {$$=$1;}
      ;
/*Declaracion de funciones*/
DECLARACIONFUNCION: DATETIPO tk_id tk_parentecisIz tk_parentecisDe tk_llaveIz tk_llaveDe {$$=new NNodo.Nodo("Funcion",$2+"",contador++);}
      |             DATETIPO tk_id tk_parentecisIz PARAMETROSF_M tk_parentecisDe tk_llaveIz tk_llaveDe {$$=new NNodo.Nodo("Funcion",$2+"",contador++); $$.searchNode($4);}
      |             DATETIPO tk_id tk_parentecisIz PARAMETROSF_M tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$=new NNodo.Nodo("Funcion",$2+"",contador++);  $$.searchNode($4); let temp5 = new NNodo.Nodo("ContenidoF","Contenido",contador++); temp5.searchNode($7); $$.lstNodo.push(temp5); }
      |             DATETIPO tk_id tk_parentecisIz tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$=new NNodo.Nodo("Funcion",$2+"",contador++); let temp6 = new NNodo.Nodo("ContenidoF","Contenido",contador++); temp6.searchNode($6); $$.lstNodo.push(temp6);  }
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

ANALISISMEDIO2: RETURNMETODOF {$$=$1;}
            | METODOCALL tk_puntoycoma {$$=$1;}
            | ASIGNACIONVARIABLEPost tk_puntoycoma {$$=$1;}
            | DECLARACIONIF {$$=$1;}
            | DECLARACIONVARIABLE tk_puntoycoma {$$=$1;}
            | DECLARACIONFOR {$$=$1;}
            | DECLARACIONWHILE {$$=$1;}
            | DECLARACIONDOWHILE {$$=$1;}
            | AUMENTOODISMINUCION tk_puntoycoma {$$=$1;}
            | tk_break tk_puntoycoma {$$=new NNodo.Nodo("Break","break",contador++);}
            | tk_continue tk_puntoycoma {$$=new NNodo.Nodo("Continue","continue",contador++);}
            | DECLARACIONCONSOLE {$$=$1;}
            | DECLARACIONSWITCH {$$=$1;}
;
/*Declaracion para el metodo Switch*/
DECLARACIONSWITCH: tk_switch tk_parentecisIz ASIGNACIONVARIABLE tk_parentecisDe  tk_llaveIz DECLARACIONSWITCH2 tk_llaveDe {$$=new NNodo.Nodo("Switch","switch",contador++); $$.lstNodo.push($3); let contenidoSwitch = new NNodo.Nodo("CuerpoSwitch","cuerpo",contador++); contenidoSwitch.searchNode($6); $$.lstNodo.push(contenidoSwitch);}
            |      tk_switch tk_parentecisIz ASIGNACIONVARIABLE tk_parentecisDe  tk_llaveIz tk_llaveDe {$$=new NNodo.Nodo("Switch","switch",contador++); $$.lstNodo.push($3);}
;

DECLARACIONSWITCH2: DECLARACIONSWITCH2 DECLARACIONSWITCH3 {$$=$1; $$.push($2);}
            | DECLARACIONSWITCH3 {$$=[]; $$.push($1);}
;
DECLARACIONSWITCH3: tk_case ASIGNACIONVARIABLE tk_dospuntos {$$= new NNodo.Nodo("Case","case",contador++); let caso0 = new NNodo.Nodo("Caso","caso",contador++); caso0.lstNodo.push($2); $$.lstNodo.push(caso0); }
            |       tk_case ASIGNACIONVARIABLE tk_dospuntos ANALISISMEDIO {$$= new NNodo.Nodo("Case","case",contador++); let caso1 = new NNodo.Nodo("Caso","caso",contador++); caso1.lstNodo.push($2); $$.lstNodo.push(caso1); let cuerpoCase1 = new NNodo.Nodo("CuerpoCase","cuerpo",contador++); cuerpoCase1.lstNodo.push($4); $$.lstNodo.push(cuerpoCase1); }
            |       tk_default tk_dospuntos {$$= new NNodo.Nodo("Default","default",contador++); }
            |       tk_default tk_dospuntos ANALISISMEDIO {$$= new NNodo.Nodo("Default","default",contador++); let cuerpoCase2 = new NNodo.Nodo("CuerpoDefault","cuerpo",contador++); cuerpoCase2.lstNodo.push($3); $$.lstNodo.push(cuerpoCase2); }
;
/*Declaracion al momento de imprimir algo en consola*/
DECLARACIONCONSOLE: tk_System tk_punto tk_out tk_punto tk_print tk_parentecisIz ASIGNACIONVARIABLE tk_parentecisDe tk_puntoycoma {$$ = new NNodo.Nodo("Imprimir","imprimir",contador++); $$.lstNodo.push($7);}
            |       tk_System tk_punto tk_out tk_punto tk_print tk_parentecisIz  tk_parentecisDe tk_puntoycoma {$$ = new NNodo.Nodo("Imprimir","imprimir",contador++);}
            |       tk_System tk_punto tk_out tk_punto tk_println tk_parentecisIz ASIGNACIONVARIABLE tk_parentecisDe tk_puntoycoma {$$ = new NNodo.Nodo("Imprimir","imprimir SaltoL",contador++); $$.lstNodo.push($7);}
            |       tk_System tk_punto tk_out tk_punto tk_println tk_parentecisIz  tk_parentecisDe tk_puntoycoma {$$ = new NNodo.Nodo("Imprimir","imprimir SaltoL",contador++);}
;
/*Contendra la declaracion de la funcion While*/
DECLARACIONWHILE: tk_while tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$= new NNodo.Nodo("While","while",contador++); $$.lstNodo.push($3); let cuerpoWhile0 = new NNodo.Nodo("CuerpoWhile","cuerpo",contador++); cuerpoWhile0.searchNode($6); $$.lstNodo.push(cuerpoWhile0);}
            |     tk_while tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz  tk_llaveDe {$$= new NNodo.Nodo("While","while",contador++); $$.lstNodo.push($3);}
;
DECLARACIONDOWHILE: tk_do tk_llaveIz ANALISISMEDIO tk_llaveDe tk_while tk_parentecisIz CONDICIONES tk_parentecisDe tk_puntoycoma {$$= new NNodo.Nodo("doWhile","do while",contador++); let cuerpoDoW0=new NNodo.Nodo("CuerpoDoW","cuerpo",contador++); cuerpoDoW0.searchNode($3); $$.lstNodo.push(cuerpoDoW0); let whileDo = new NNodo.Nodo("whileDo","while",contador++); whileDo.lstNodo.push($7); $$.lstNodo.push(whileDo); }
            |       tk_do tk_llaveIz  tk_llaveDe tk_while tk_parentecisIz CONDICIONES tk_parentecisDe tk_puntoycoma {$$= new NNodo.Nodo("doWhile","do while",contador++); let whileDo2 = new NNodo("whileDo","while",contador++); whileDo2.lstNodo.push($6); $$.lstNodo.push(whileDo2); } 
;
/*Declaracion de la funcion FOR*/
DECLARACIONFOR: tk_for tk_parentecisIz DENTRODEFOR tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$ = new NNodo.Nodo("For","for",contador++); let condicionesfor = new NNodo.Nodo("condiciones","condiciones",contador++); condicionesfor.searchNode($3); $$.lstNodo.push(condicionesfor); let cuerpoFor0 = new NNodo.Nodo("CuerpoFor","cuerpo",contador++); cuerpoFor0.searchNode($6); $$.lstNodo.push(cuerpoFor0); } 
            | tk_for tk_parentecisIz DENTRODEFOR tk_parentecisDe  tk_llaveIz tk_llaveDe {$$ = new NNodo.Nodo("For","for",contador++); let condicionesfor2 = new NNodo.Nodo("condiciones","condiciones",contador++); condicionesfor2.searchNode($3); $$.lstNodo.push(condicionesfor2);}
;

DENTRODEFOR: ASIGNACIONVARIABLEPost tk_puntoycoma CONDICIONES tk_puntoycoma AUMENTOODISMINUCION {$$=[]; $$.push($1);$$.push($3);$$.push($5);}
      |      DECLARACIONVARIABLE tk_puntoycoma CONDICIONES tk_puntoycoma AUMENTOODISMINUCION {$$=[]; $$.push($1);$$.push($3);$$.push($5);}
;

AUMENTOODISMINUCION: tk_id tk_incremento {$$=new NNodo.Nodo("id",$1,contador++); $$.lstNodo.push(new NNodo.Nodo("incremento","+1",contador++));}
      |     tk_id tk_decremento  {$$=new NNodo.Nodo("id",$1,contador++); $$.lstNodo.push(new NNodo.Nodo("incremento","-1",contador++));}
;

/*Declaracion de la funcion IF*/
DECLARACIONIF: tk_if tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz tk_llaveDe {$$= new NNodo.Nodo("If","if",contador++); let condiciones0= new NNodo.Nodo("condiciones","condiciones",contador++); condiciones0.lstNodo.push($3); $$.lstNodo.push(condiciones0); } 
            | tk_if tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe DECLARACIONELSE {$$= new NNodo.Nodo("If","if",contador++); let condiciones1= new NNodo.Nodo("condiciones","condiciones",contador++); condiciones1.lstNodo.push($3); $$.lstNodo.push(condiciones1); let cuerpoIf1 = new NNodo.Nodo("Cuerpo","cuerpo",contador++); cuerpoIf1.searchNode($6); $$.lstNodo.push(cuerpoIf1); $$.lstNodo.push($8)}
            | tk_if tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz  tk_llaveDe DECLARACIONELSE {$$= new NNodo.Nodo("If","if",contador++); let condiciones2= new NNodo.Nodo("condiciones","condiciones",contador++); condiciones2.lstNodo.push($3); $$.lstNodo.push(condiciones2); $$.lstNodo.push($7); } 
            | tk_if tk_parentecisIz CONDICIONES tk_parentecisDe tk_llaveIz ANALISISMEDIO tk_llaveDe {$$= new NNodo.Nodo("If","if",contador++); let condiciones3= new NNodo.Nodo("condiciones","condiciones",contador++); condiciones3.lstNodo.push($3); $$.lstNodo.push(condiciones3); let cuerpoIf2 = new NNodo.Nodo("Cuerpo","cuerpo",contador++); cuerpoIf2.searchNode($6); $$.lstNodo.push(cuerpoIf2);} 
;
DECLARACIONELSE: tk_else tk_llaveIz ANALISISMEDIO tk_llaveDe {$$= new NNodo.Nodo("Else","else",contador++); $$.searchNode($3);}
      | tk_else tk_llaveIz tk_llaveDe {$$= new NNodo.Nodo("Else","else",contador++);}
      | tk_else DECLARACIONIF {$$= new NNodo.Nodo("ElseIf","else If",contador++); $$.lstNodo.push($2);}
;
/*Asigna valor a una variable ya creada*/
ASIGNACIONVARIABLEPost: tk_id tk_igual ASIGNACIONVARIABLE {$$= new NNodo.Nodo("AsignacionId",$1,contador++); $$.lstNodo.push($3);}
;
/*Al momento de venir return*/
RETURNMETODOF: tk_return tk_puntoycoma {$$= new NNodo.Nodo("return","return",contador++);}
            |  tk_return CONDICIONES tk_puntoycoma {$$= new NNodo.Nodo("return","return",contador++); let lstCondiciones0=[]; lstCondiciones0.push($2); $$.searchNode(lstCondiciones0);}
;
/*Condiciones*/
CONDICIONES: CONDICIONES2 {$$=$1;}
      |      tk_parentecisIz CONDICIONES tk_parentecisDe {$$=$2;}
      |      tk_not CONDICIONES {$$= new NNodo.Nodo("Negacion","not",contador++); $$.lstNodo.push($2);}
      |      CONDICIONES OPERADORES CONDICIONES  {$$= new NNodo.Nodo("OperadorLogico",$2,contador++); $$.lstNodo.push($1); $$.lstNodo.push($3); }    
;
CONDICIONES2: ASIGNACIONVARIABLE {$$= $1;}
      |       tk_parentecisIz CONDICIONES2 tk_parentecisDe { $$=$2;}
      |       CONDICIONES2 COMPARADORES CONDICIONES2 {$$= new NNodo.Nodo("Comparacion",$2,contador++); $$.lstNodo.push($1); $$.lstNodo.push($3);}      
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
      | CONDICIONES
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
/*Operadores*/
OPERADORES: tk_and
      |     tk_or
;
/*Comparadores*/
COMPARADORES: tk_igualdad
      |       tk_menorigualque
      |       tk_menorque
      |       tk_mayorigualque
      |       tk_mayorque
      |       tk_distinto
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
