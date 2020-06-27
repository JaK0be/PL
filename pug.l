%{
#include "y.tab.h"
%}

TagList1        a|"abbr"|"address"|"article"|"aside"|"audio"|"b"|"bdi"|"bdo"|"blockquote"|"body"|"button"|"canvas"|"caption"|"cite"|"code"
TagList2        "dd"|"del"|"details"|"dfn"|"dialog"|"div"|"dl"|"dt"|"em"|"fieldset"|"figcaption"|"figure"|"footer"|"form"|"h1"|"h2"|"h3"|"h4"|"h5"|"h6"
TagList3        "head"|"header"|"html"|"i"|"iframe"|"ins"|"kbd"|"label"|"legend"|"li"|"main"|"map"|"mark"|"meter"|"nav"|"noscript"|"object"|"ol"|"optgroup"|"option"|"output"
TagList4        "p"|"pre"|"progress"|"q"|"rp"|"rt"|"ruby"|"s"|"samp"|"script"|"select"|"small"|"span"|"strong"|"style"|"sub"|"summary"|"sup"|"svg"
TagList5        "table"|"tbody"|"td"|"template"|"textarea"|"tfoot"|"th"|"thead"|"time"|"title"|"tr"|"u"|"ul"|"var"|"video"
Tag             ({TagList1}|{TagList2}|{TagList3}|{TagList4}|{TagList5})

SCTagList       "area"|"base"|"br"|"col"|"embed"|"hr"|"img"|"input"|"link"|"meta"|"param"|"source"|"track"|"wbr"

%x atrib

%%
[\n\r] ;
\:|\/ return yytext[0];
\( {
    BEGIN atrib;
    return yytext[0];
   }
<atrib>[^\)]+ {
                  yylval.svalue = strdup(yytext);
                  return atributo;
              }
<atrib>\) {
                BEGIN INITIAL;
                return yytext[0];
             }
{Tag} {
         yylval.svalue = strdup(yytext);
         return tag;
      }
{SCTagList} {
               yylval.svalue = strdup(yytext);
               return sctag;
            }
(\ \ ){Tag} {
               yylval.svalue = strdup(yytext+2);
               return nest;
            }
(\ \ ){SCTagList} {
                     yylval.svalue = strdup(yytext+2);
                     return scnest;
                  }
(\ )[^\ ][^\:\n]* {
                     yylval.svalue = strdup(yytext+1);
                     return conteudo;
                  }
.  return ERRO;

%%