%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);
int pot_enable = 0;
%}

%token INT SOMA EOL SUB MULT DIV POT ABRE FECHA
%left SOMA
%left SUB
%left MULT
%left DIV
%left POT
%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf(";Resultado: %d\n", $2);
                                 if(pot_enable == 1){
                                 printf("HLT\npotencia:\nMUL C\nDEC B\nJNZ potencia\nRET\n");
                                                    }}
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

    | EXPRESSAO POT EXPRESSAO {
          int res; res = 1;
          for(int i = 0; i < $3; i++){res = res * $1;}
          printf(";Encontrei pot: %d ^ %d = %d\n", $1, $3,res);

	  if ( $3 == 0 ) {
	      printf("POP B\nPOP A\nMOV A, 1\nPUSH A\n");
	  } else {
	      
          printf("POP B\nPOP A\nMOV C,A\nDEC B\nCall potencia\nPUSH A\n");
          pot_enable = 1;
	  }
          $$ = res;
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
