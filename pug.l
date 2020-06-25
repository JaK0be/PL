%{
#include "y.tab.h"
%}

%%
[\n\r] ;
\:|\/ return yytext[0];
[a-z]+ return tag;
(\ \ )+[a-z]+ return nest;
.  return ERRO;

%%