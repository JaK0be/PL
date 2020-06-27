%{
#include <stdio.h>
#include <string.h>
extern int yylex();
int yyerror(char *s);
%}

%token ERRO tag sctag nest scnest snest atrib

%%

Pug : Tags
    ; 

Tags : Tags TagP
     |
     ;

TagP : Tag Nests
     | SelfClosingTag
     | BlockExpansion Nests
     ;

Nests : Nests Nest
      | 
      ;

Nest : SelfClosingNest
     | Nestt SNest
     | Nestt ':' Tag
     ;

SNest : SNest snest
      |
      ;

BlockExpansion : Tag ':' Tag
               | Tag ':' SelfClosingTag
               | Tag ':' BlockExpansion
               ;

SelfClosingTag : SCTag
               | Tag '/'
               | SCTag '/'
               ;

SelfClosingNest : SCNest
                | Nestt '/'
                | SCNest '/'
                ;

Tag : tag
    | tag '(' atrib ')'
    ;

SCTag : sctag
      | sctag '(' atrib ')'
      ;

Nestt : nest
      | nest '(' atrib ')'
      ;

SCNest : scnest
       | scnest '(' atrib ')'
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