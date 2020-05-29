
%{
#include <stdlib.h>
void yyerror(char *);

#include "y.tab.h"
%}


%%

[0-9]+  {
          yylval = atoi(yytext);
          return INT;
        }

[+]     {
          return SOMA;
        }

[-]     {
          return SUB;
        }

[*]     {
          return MULT;
        }

\^     {
          return POT;
        }


[/]     {
          return DIV;
        }

[(]     {
          return ABRE;
        }

[)]     {
          return FECHA;
        }


\n   {
         return EOL;
       }

[ \t]+ ;

.     {yyerror("Token nao reconhecido!\n");}

%%

int yywrap() {
  return 1;
}
