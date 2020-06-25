%{
#include <stdio.h>
#include <string.h>
extern int yylex();
int yyerror(char *s);
%}

%token ERRO tag sctag nest scnest

%%

Pug : Tags
    ; 

Tags : Tags TagP
     |
     ;

TagP : tag Nests
     | SelfClosingTag
     | BlockExpansion Nests
     ;

Nests : Nests nest
      |
      ;

BlockExpansion : tag ':' tag
               | tag ':' SelfClosingTag
               | tag ':' BlockExpansion
               ;

SelfClosingTag : sctag
               | tag '/'
               | sctag '/'
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