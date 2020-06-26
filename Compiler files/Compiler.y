%{
	#include<stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <malloc.h>
	#include <stdbool.h>
	bool called = false;
%}
%error-verbose
%union {
	char *cval;
	}

%token HLT STC CLC STZ CLZ MOV RA RB RC RD COMM ACC JMP JC JNC JZ JNZ JS JNS ADD ADC SUB AND OR NOT XOR CALL RET  
%token <cval> MEMADD
%token <cval> IMMED 

%% 
basic	   : statements hlt ;
statements :
	   | statements add ;
	   | statements mov ;
	   | statements adc ;
	   | statements sub ;
	   | statements and ;
	   | statements or ;
	   | statements not ;
	   | statements xor ;
	   | statements stc ;
	   | statements clc ;
	   | statements stz ;
	   | statements clz ;
	   | statements jmp ;
	   | statements js ;
	   | statements jns ;
	   | statements jz ;
	   | statements jnz ;
	   | statements jc ;
	   | statements jnc ;
	   | statements call ;
	   | statements ret ;
hlt	: HLT {writetofile(0xff);}
mov	: MOV minimove ;
minimove: RA COMM RB {writetofile(0x01);}
	| RA COMM RC {writetofile(0x02);}
	| RA COMM RD {writetofile(0x03);}
	| RB COMM RA {writetofile(0x04);}
	| RB COMM RC {writetofile(0x06);}
	| RB COMM RD {writetofile(0x07);}
	| RC COMM RA {writetofile(0x08);}
	| RC COMM RB {writetofile(0x09);}
	| RC COMM RD {writetofile(0x0B);}
	| RD COMM RA {writetofile(0x0C);}
	| RD COMM RB {writetofile(0x0D);}
	| RD COMM RC {writetofile(0x0E);}

	| ACC COMM RA {writetofile(0x10);}
	| ACC COMM RB {writetofile(0x11);}
	| ACC COMM RC {writetofile(0x12);}
	| ACC COMM RD {writetofile(0x13);}

	| RA COMM ACC {writetofile(0x20);}
	| RB COMM ACC {writetofile(0x24);}
	| RC COMM ACC {writetofile(0x28);}
	| RD COMM ACC {writetofile(0x2C);}

	| ACC COMM IMMED { 
			   int x = (int)strtol($3, NULL, 16);
			        if(x<256 && x!=10 && x!=26)
				{ writetofile(0x30);
				  writetofile(stringtohex($3));
				  }
				else
				{
				  yyerror("Wrong immediate value");
				  YYABORT;
				}
	       		 }
	| ACC COMM MEMADD { 
			        int x = (int)strtol($3, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0x41);
				  writetofile(stringtohex($3));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }

	| MEMADD COMM ACC { 
			        int x = (int)strtol($1, NULL, 16);
			        if(x<251 && x>127 && x!=10 && x!=26)
				{ writetofile(0x42);
				  writetofile(stringtohex($1));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }


add	: ADD miniadd ;
miniadd : ACC COMM RA {writetofile(0x50);}
	| ACC COMM RB {writetofile(0x51);}
	| ACC COMM RC {writetofile(0x52);}
	| ACC COMM RD {writetofile(0x53);}
	;
adc	: ADC miniadc ;
miniadc : ACC COMM RA {writetofile(0x70);}
	| ACC COMM RB {writetofile(0x71);}
	| ACC COMM RC {writetofile(0x72);}
	| ACC COMM RD {writetofile(0x73);}
	;
sub	: SUB minisub ;
minisub : ACC COMM RA {writetofile(0x60);}
	| ACC COMM RB {writetofile(0x61);}
	| ACC COMM RC {writetofile(0x62);}
	| ACC COMM RD {writetofile(0x63);}
	;
and	: AND miniand ;
miniand : ACC COMM RA {writetofile(0x80);}
	| ACC COMM RB {writetofile(0x81);}
	| ACC COMM RC {writetofile(0x82);}
	| ACC COMM RD {writetofile(0x83);}
	;
or	: OR minior ;
minior  : ACC COMM RA {writetofile(0x90);}
	| ACC COMM RB {writetofile(0x91);}
	| ACC COMM RC {writetofile(0x92);}
	| ACC COMM RD {writetofile(0x93);}
	;
not	: NOT {writetofile(0xa0);}
	;
xor	: XOR minixor ;
minixor : ACC COMM RA {writetofile(0xb0);}
	| ACC COMM RB {writetofile(0xb1);}
	| ACC COMM RC {writetofile(0xb2);}
	| ACC COMM RD {writetofile(0xb3);}
	;
stc	: STC {writetofile(0xc1);}
clc	: CLC {writetofile(0xc2);}
stz	: STZ {writetofile(0xc4);}
clz	: CLZ {writetofile(0xc8);}

jmp	: JMP IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0xd0);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }

js	: JS IMMED {  
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0xec);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
jns	: JNS IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{  writetofile(0xe4);
				   writetofile(stringtohex($2));
				   }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
jz	: JZ IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0xea);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
jnz	: JNZ IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0xe2);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
jc	: JC IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ writetofile(0xe9);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
jnc	: JNC IMMED { 
				int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ 
				  writetofile(0xe1);
				  writetofile(stringtohex($2));
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
call	: CALL IMMED { 
			        int x = (int)strtol($2, NULL, 16);
			        if(x<251 && x!=10 && x!=26)
				{ 
				  writetofile(0xf1);
			          writetofile(0xfb);
				  writetofile(stringtohex($2));
				called = true;
				  }
				else
				{
				  yyerror("Wrong memory address value");
				  YYABORT;
				}
			   }
ret	: RET {
		if(called)
		{
		writetofile(0xf2);
		writetofile(0xfb);
		called = false;
		}
		else
		{
		yyerror("CALL statemant hasn't been called to call RET.");
		 YYABORT;
		}
		
		}
%%
main( argc, argv )
	int argc;
	char **argv;
	{
		FILE *fp;
	        fp = fopen ("program.bin", "w+");
		fclose(fp);
		extern FILE *yyin;
		++argv, --argc; /* skip over program name */
		if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
		else
		yyin = stdin;
		int ii = yyparse();
		if(ii == 0)
		printf("Input accepted, binary file has been written.\n\n");
		else
		{
		FILE *fp2;
	        fp2 = fopen ("program.bin", "w+");
		fclose(fp2);
		}
		
	}
yyerror (char *s) /* Called by yyparse on error */
	{ extern int *yylineno; 
	  printf("error in line %d: %s\n",yylineno,s);
	 }

writetofile(unsigned char *bb)
{
FILE *fp; fp = fopen ("program.bin", "a+"); fwrite(&bb,sizeof(unsigned char),1,fp); fclose(fp);
}

stringtohex(char *aa)
{
 int *res;
 int *array[256] = {
 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
 0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f,
 0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2a,0x2b,0x2c,0x2d,0x2e,0x2f,
 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3a,0x3b,0x3c,0x3d,0x3e,0x3f,
 0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4a,0x4b,0x4c,0x4d,0x4e,0x4f,
 0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5a,0x5b,0x5c,0x5d,0x5e,0x5f,
 0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6a,0x6b,0x6c,0x6d,0x6e,0x6f,
 0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7a,0x7b,0x7c,0x7d,0x7e,0x7f,
 0x80,0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88,0x89,0x8a,0x8b,0x8c,0x8d,0x8e,0x8f,
 0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,0x9a,0x9b,0x9c,0x9d,0x9e,0x9f,
 0xa0,0xa1,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,0xa8,0xa9,0xaa,0xab,0xac,0xad,0xae,0xaf,
 0xb0,0xb1,0xb2,0xb3,0xb4,0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xbb,0xbc,0xbd,0xbe,0xbf,
 0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xcb,0xcc,0xcd,0xce,0xcf,
 0xd0,0xd1,0xd2,0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0xdf,
 0xe0,0xe1,0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,0xec,0xed,0xee,0xef,
 0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd,0xfe,0xff};
 int temp = (int)strtol(aa, NULL, 16);
 res = array[temp];
 return res;
}
