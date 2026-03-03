/* CMSC 430 Compiler Theory and Design
   Project 4 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		"//".*\n
comment2 	"--".*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*(_{1,2}[A-Za-z0-9]+)*
hex 		"#"[0-9A-Fa-f]+ 	
digit		[0-9]
dec		{digit}+
real 	[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
char		'([^\\]|\\[btnrf])'
punc		[\(\),:;]

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{comment2}	{ ECHO; nextLine(); }

"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"&"		{ ECHO; return(ANDOP); }

"|"		{ ECHO; return(OROP); }
"!"		{ ECHO; return(NOTOP); }

"="  	{ ECHO; return(RELOP); }
"<>" 	{ ECHO; return(RELOP); }
">=" 	{ ECHO; return(RELOP); }
"<=" 	{ ECHO; return(RELOP); }
">"  	{ ECHO; return(RELOP); }
"<"	{ ECHO; return(RELOP); }

"-" 	{ ECHO; return(ADDOP); }

"/" 	{ ECHO; return(MULOP); }

"%" 	{ ECHO; return(REMOP); }

"^" 	{ ECHO; return(EXPOP); }

"~"		{ ECHO; return(NEGOP); }

"=>"		{ ECHO; return(ARROW); }

begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
real        { ECHO; return(REAL); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }
if       { ECHO; return(IF); }
elsif    { ECHO; return(ELSIF); }
else     { ECHO; return(ELSE); }
endif    { ECHO; return(ENDIF); }
then     { ECHO; return(THEN); }
fold		{ ECHO; return(FOLD); }
left		{ ECHO; return(LEFT); }
right		{ ECHO; return(RIGHT); }
endfold		{ ECHO; return(ENDFOLD); }

ELSE		{ ECHO; return(ELSE); }
ELSIF		{ ECHO; return(ELSIF); }
ENDFOLD		{ ECHO; return(ENDFOLD); }
ENDIF		{ ECHO; return(ENDIF); }
FOLD		{ ECHO; return(FOLD); }
IF			{ ECHO; return(IF); }
LEFT		{ ECHO; return(LEFT); }
RIGHT		{ ECHO; return(RIGHT); }
THEN		{ ECHO; return(THEN); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{hex}		{ ECHO; return(INT_LITERAL); }
{real}   { ECHO; return(REAL_LITERAL); }
{dec}		{ ECHO; return(INT_LITERAL); }
{char}	{ ECHO; return(CHAR_LITERAL); }
{punc}	{ ECHO; return(yytext[0]); }
.		   { ECHO; appendError(LEXICAL, yytext); }

{line}		{ ECHO; nextLine(); }

%%