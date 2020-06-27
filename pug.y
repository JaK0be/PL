%{
#include <stdio.h>
#include <string.h>
extern int yylex();
int yyerror(char *s);
%}

%union{
    char* svalue;
}

%token ERRO tag sctag nest scnest atributo conteudo
%type <svalue> tag sctag nest scnest atributo conteudo
%type <svalue> Tags TagP Nests Group BlockExpansion SelfClosingTag SelfClosingNest
%type <svalue> Tag TagC SCTag Nest NestC SCNest

%%

Pug : Tags {
                printf("%s\n",$1);
            }
    ; 

Tags : Tags TagP {
                    asprintf(&$$, "%s \n %s", $1, $2);
                 }
     | {
           asprintf(&$$, "\n");
       }
     ;

TagP : Tag Nests
     | SelfClosingTag {
                          asprintf(&$$, "%s", $1);
                      }
     | BlockExpansion Nests
     ;

Nests : Nests Group
      | {
           asprintf(&$$, "\n");
        }
      ; 

Group : SelfClosingNest {
                            asprintf(&$$, "%s", $1);
                        }
      | Nest {
                asprintf(&$$, "%s", $1);
             }
      | NestC ':' Tag
      | NestC ':' BlockExpansion
      ;

BlockExpansion : TagC ':' Tag
               | TagC ':' SelfClosingTag
               | TagC ':' BlockExpansion
               ;

SelfClosingTag : SCTag {
                           asprintf(&$$, "%s", $1);
                       }
               | TagC '/'
               | SCTag '/' {
                                asprintf(&$$, "%s", $1);
                           }
               ;

SelfClosingNest : SCNest {
                             asprintf(&$$, "%s", $1);
                         }
                | NestC '/'
                | SCNest '/' {
                                 asprintf(&$$, "%s", $1);
                             }
                ;

Tag : tag {
              asprintf(&$$, "<%s> </%s>", $1, $1);
          }
    | tag conteudo {
                       asprintf(&$$, "<%s> %s </%s>", $1, $2, $1); 
                   }
    | tag '(' atributo ')' {
                                asprintf(&$$, "<%s %s> </%s> \n", $1, $3, $1);
                           }
    | tag '(' atributo ')' conteudo {
                                        asprintf(&$$, "<%s %s> %s </%s> \n", $1, $3, $5, $1);
                                    }
    ;

TagC : tag {
                asprintf(&$$, "<%s> </%s>", $1, $1);
           }
     | tag '(' atributo ')' {
                                asprintf(&$$, "<%s %s> </%s> \n", $1, $3, $1);
                            }
     ;

SCTag : sctag {
                  asprintf(&$$, "<%s />", $1); 
              }
      | sctag '(' atributo ')' {
                                    asprintf(&$$, "<%s %s />", $1, $3);
                               }
      ;

Nest : nest {
                asprintf(&$$, "<%s> </%s>", $1, $1); 
            }
     | nest conteudo {
                         asprintf(&$$, "<%s> %s </%s>", $1, $2, $1);
                     } 
     | nest '(' atributo ')' {
                                 asprintf(&$$, "<%s %s> </%s> \n", $1, $3, $1);
                             }
     | nest '(' atributo ')' conteudo {
                                          asprintf(&$$, "<%s %s> %s </%s> \n", $1, $3, $5, $1);
                                      }
     ;

NestC : nest {
                  asprintf(&$$, "<%s> </%s>", $1, $1); 
             }
      | nest '(' atributo ')' {
                                  asprintf(&$$, "<%s %s> </%s> \n", $1, $3, $1); 
                              }
      ;

SCNest : scnest {
                    asprintf(&$$, "<%s />", $1);
                }
       | scnest '(' atributo ')' {
                                     asprintf(&$$, "<%s %s />", $1, $3);
                                 }
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