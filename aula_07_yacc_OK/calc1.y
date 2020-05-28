%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT SOMA EOL SUB MULT DIV ABRE FECHA
%left SOMA
%left SUB
%left MULT
%left DIV
%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf(";Resultado: %d\n", $2); }
        |
        ;


EXPRESSAO:
    INT { $$ = $1;
	printf("PUSH %d\n", $1);
          }

    | ABRE EXPRESSAO FECHA  {
          printf(";Tirei parenteses em %d\n", $2);
          $$ = $2;
          }


    | EXPRESSAO DIV EXPRESSAO  {
          printf(";Encontrei divisao: %d / %d = %d\n", $1, $3, $1/$3);
	  printf("POP B\nPOP A\nDIV B\nPUSH A\n");
          $$ = $1 / $3;
          }

    | EXPRESSAO MULT EXPRESSAO  {
          printf(";Encontrei mult: %d * %d = %d\n", $1, $3, $1*$3);
	  printf("POP B\nPOP A\nMUL B\nPUSH A\n");
          $$ = $1 * $3;
          }



    | EXPRESSAO SOMA EXPRESSAO  {
        printf(";Encontrei soma: %d + %d = %d\n", $1, $3, $1+$3);
	printf("POP B\nPOP A\nADD A, B\nPUSH A\n");
        $$ = $1 + $3;
        }

    | EXPRESSAO SUB EXPRESSAO {
        printf(";Encontrei sub: %d - %d = %d\n", $1, $3, $1-$3);
	printf("POP B\nPOP A\nSUB A, B\nPUSH A\n");
        $$ = $1 - $3;
    }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;

}
