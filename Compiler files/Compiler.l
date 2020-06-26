%option noyywrap
%option yylineno

%{
	#include <stdlib.h>
	#include <string.h>
	#include <malloc.h>
	#include "y.tab.h"
	char* substring(char*, int, int);
%}
HEX [A-Fa-f0-9]

%%
"STC"	{return(STC);}
"CLC"	{return(CLC);}
"STZ"	{return(STZ);}
"CLZ"	{return(CLZ);}
"MOV" 	{return(MOV);}
"RA"	{return(RA);}
"RB" 	{return(RB);}
"RC" 	{return(RC);}
"RD" 	{return(RD);}
","	{return(COMM);}
"ACC" 	{return(ACC);}
"JMP"	{return(JMP);}
"JC"	{return(JC);}
"JNC"	{return(JNC);}
"JZ"	{return(JZ);}
"JNZ"	{return(JNZ);}
"JS"	{return(JS);}
"JNS"	{return(JNS);}
"ADD"	{return(ADD);}
"ADC"	{return(ADC);}
"SUB"	{return(SUB);}
"AND"	{return(AND);}
"OR"	{return(OR);}
"NOT"	{return(NOT);}
"XOR"	{return(XOR);}
"CALL"	{return(CALL);}
"RET"	{return(RET);}
"HLT"	{return(HLT);}
[ \t\n]+
;[^\n]*
"["{HEX}+[hH]"]"  {  yylval.cval = substring( yytext, 2, strlen(yytext)-1); return(MEMADD); }
{HEX}+[hH]  { yylval.cval = yytext; return(IMMED); }
%%

char *substring(char *string, int position, int length) 
{
   char *pointer;
   int c;
   pointer = malloc(length+1);
   if (pointer == NULL)
   {
      printf("Unable to allocate memory.\n");
      exit(EXIT_FAILURE);
   }
   for (c = 0 ; c < position -1 ; c++) 
      string++; 
   for (c = 0 ; c < length ; c++)
   {
      *(pointer+c) = *string;      
      string++;   
   }
   *(pointer+c) = '\0';
   return pointer;
}
	
	