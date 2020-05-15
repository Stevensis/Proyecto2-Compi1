
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

"*"     return 'tk_mul'
"/"     return 'tk_div'
"-"     return 'tk_res'
"+"     return 'tk_sum'
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

%start S
%% 

S : INICIO EOF { return $$=$1; return $$; }
      ;
INICIO :    IMPORTC CLASSP { $$= new NNodo.Nodo("Root","Root",contador++); $$.encontrarNode($1); $$.encontrarNode($2); }
      |     CLASSP      { $$= new NNodo.Nodo("Root","Root",contador++); $$.lstNodo.push($1); }
      ;
IMPORTC :   IMPORTC tk_import tk_id tk_puntoycoma { $$=$1; $$.push(new NNodo.Nodo("Import",$2+" "+$3,contador++)) }
      |     tk_import tk_id tk_puntoycoma { $$=[]; $$.push(new NNodo.Nodo("Import",$1+" "+$2,contador++))  }
      ;

CLASSP :    CLASSP tk_class tk_id tk_llaveIz CUERPOCLASS tk_llaveDe { let temp = new NNodo.Nodo("class",$2+" "+$3,contador++); temp.lstNodo.push($5); $$=$1; $$.push(temp); }
      |     tk_class tk_id tk_llaveIz CUERPOCLASS tk_llaveDe { $$=[]; let temp2 = new NNodo.Nodo("class",$1+" "+$2,contador++); temp2.lstNodo.push($4); $$.push(temp2); }
      ;

CUERPOCLASS:      tk_String tk_id tk_igual tk_cadena tk_puntoycoma { $$= new NNodo.Nodo($1+"",$2+" "+$3+" "+$4,contador++); }
      ;

