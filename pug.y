%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylineno;
extern int yylex();
int yyerror(char *s);

%}

%union{
    char* svalue;
}

%token ERRO tag sctag nest scnest atributo conteudo
%type <svalue> tag sctag nest scnest atributo conteudo
%type <svalue> Tags TagP Nests Group BlockExpansion SelfClosingTag SelfClosingNest
%type <svalue> Tag SCTag Nest SCNest

%%

Pug : Tags {
                printf("<!DOCTYPE html>\n<html>\n%s\n</html>",$1);
           }
    ; 

Tags : Tags TagP {
                    asprintf(&$$, "%s\n%s", $1, $2);
                 }
     | {
           asprintf(&$$, "");
       }
     ;

TagP : tag Nests {
                    asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $2, $1);
                 }
     | tag conteudo Nests {
                                asprintf(&$$, "<%s>%s\n\t%s\n</%s>", $1, $2, $3, $1); 
                          }
     | tag '(' atributo ')' Nests {
                                        asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $5, $1);
                                  }
     | tag '(' atributo ')' conteudo Nests {
                                                asprintf(&$$, "<%s %s> %s\n\t%s\n</%s>", $1, $3, $5, $6, $1);
                                           }
     | SelfClosingTag {
                          asprintf(&$$, "%s", $1);
                      }
     | BlockExpansion Nests {
                                asprintf(&$$, "%s", $1);
                            }
     ;

Nests : Nests Group {
                        asprintf(&$$, "%s \n %s", $1, $2);
                    }
      | {
           asprintf(&$$, "");
        }
      ; 

Group : SelfClosingNest {
                            asprintf(&$$, "%s", $1);
                        }
      | Nest {
                asprintf(&$$, "%s", $1);
             }
      | nest ':' Tag {
                        asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $3, $1);
                     }
      | nest '(' atributo ')' ':' Tag {
                                         asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $6, $1);
                                      }
      | nest ':' BlockExpansion {
                                    asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $3, $1);
                                }
      | nest '(' atributo ')' ':' BlockExpansion {
                                                    asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $6, $1);
                                                 }
      ;

BlockExpansion : tag ':' Tag {
                                 asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $3, $1);
                             }
               | tag '(' atributo ')' ':' Tag {
                                                    asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $6, $1);
                                              }
               | tag ':' SelfClosingTag {
                                            asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $3, $1);
                                        }
               | tag '(' atributo ')' ':' SelfClosingTag {
                                                             asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $6, $1);
                                                         }
               | tag ':' BlockExpansion {
                                            asprintf(&$$, "<%s>\n\t%s\n</%s>", $1, $3, $1);
                                        }
               | tag '(' atributo ')' ':' BlockExpansion {
                                                             asprintf(&$$, "<%s %s>\n\t%s\n</%s>", $1, $3, $6, $1);
                                                         }
               ;

SelfClosingTag : SCTag {
                           asprintf(&$$, "%s", $1);
                       }
               | tag '/' {
                             asprintf(&$$, "<%s />", $1); 
                         }
               | tag '(' atributo ')' '/' {
                                              asprintf(&$$, "<%s %s />", $1, $3);
                                          }
               | SCTag '/' {
                                asprintf(&$$, "%s", $1);
                           }
               ;

SelfClosingNest : SCNest {
                             asprintf(&$$, "%s", $1);
                         }
                | nest '/' {
                               asprintf(&$$, "<%s />", $1); 
                           }
                | nest '(' atributo ')' '/' {
                                                asprintf(&$$, "<%s %s />", $1, $3);
                                            }
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
                                asprintf(&$$, "<%s %s> </%s>", $1, $3, $1);
                           }
    | tag '(' atributo ')' conteudo {
                                        asprintf(&$$, "<%s %s> %s </%s>", $1, $3, $5, $1);
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
                                 asprintf(&$$, "<%s %s> </%s>", $1, $3, $1);
                             }
     | nest '(' atributo ')' conteudo {
                                          asprintf(&$$, "<%s %s> %s </%s>", $1, $3, $5, $1);
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
    printf("\nErro na linha %d \n", yylineno);
    return 0;
}