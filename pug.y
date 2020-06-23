%{
#include <stdio.h>
#include <string.h>
extern int yylex();
int yyerror(char *s);
%}

%union{
}

%token ERRO HTML TAGP TAG BLOCK SCTAG

%%

Pug : HTML Tags
    ; 

Tags : Tags TagP
     | TagP
     |
     ;

TagP : TAGP TagS
     ;

TagSec : TAG 
       | TagSec TAG
       | SelfClosingTag
       | BLOCK ':' TagSec
       ;

SelfClosingTag : SCTAG
               | TAG '/'
               ;

%%

int main(){
    yyparse();
    return 0;
}

int yyerror(char *s){
    printf("Erro sintático \n");
    return 0;
}