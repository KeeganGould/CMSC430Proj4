/* CMSC 430 Compiler Theory and Design
   Project 4 Skeleton
   UMGC CITE
   Summer 2023
   
   Project 4 Parser with semantic actions for static semantic errors */

%{
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"
#include "iostream"

int yylex();
Types find(Symbols<Types>& table, CharPtr identifier, string tableName);
void checkDuplicate(Symbols<Types>& table, CharPtr identifier, string kind);
void yyerror(const char* message);

Symbols<Types> scalars;
Symbols<Types> lists;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER

%token <type> INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token ADDOP MULOP MODOP EXPOP NEGOP REMOP
%token RELOP ANDOP OROP NOTOP ARROW

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDIF ENDFOLD ENDSWITCH
%token FOLD FUNCTION INTEGER IS LEFT LIST OF OTHERS RETURNS
%token RIGHT SWITCH THEN WHEN IF REAL

%type <type> list expressions body type statement_ statement cases case expression
	term primary factor exponent relation condition elsif_clause elsif_clauses else_clause
	list_choice function_header

%%

function:	
	function_header optional_variable body {checkAssignment($1, $3, "Function Return");} ;
	
		
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';' {$$ = $4;} ;

type:
	INTEGER {$$ = INT_TYPE;} |
	CHARACTER {$$ = CHAR_TYPE; } |
	REAL {$$ = REAL_TYPE; } ;
	
optional_variable:
	optional_variable variable	|
	variable 	|
	%empty ;
    
variable:	
	IDENTIFIER ':' type IS statement ';' {checkAssignment($3, $5, "Variable Initialization"); 
		checkDuplicate(scalars, $1, "Scalar"); scalars.insert($1, $3);} 	|
	IDENTIFIER ':' LIST OF type IS list ';' {checkListAssignment($5, $7); 
		checkDuplicate(lists, $1, "List"); lists.insert($1, $5);} ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$$ = checkList($1, $3);}| 
	expression ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression { $$ = $1; } |
	IF condition THEN statement_ elsif_clauses else_clause ENDIF
    	{$$ = checkIf($4, $5, $6);}	| 
	WHEN condition ',' expression ':' expression 
		{$$ = checkWhen($4, $6);} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH 
		{$$ = checkSwitch($2, $4, $7);}	| 
	FOLD direction operator list_choice ENDFOLD {$$ = checkFold($4);} ; 

elsif_clauses:
    elsif_clauses elsif_clause { $$ = checkElses($1, $2); } |
    %empty { $$ = NONE; } ;

elsif_clause:
    ELSIF condition THEN statement_ { $$ = $4; } ;

else_clause:
    ELSE statement_ {$$ = checkElses(NONE, $2); }	| 
	%empty { $$ = NONE; } ;

cases:
	cases case {$$ = checkCases($1, $2);} |
	%empty {$$ = NONE;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $4;} ; 

direction:
    LEFT | 
	RIGHT ;

operator:
	ADDOP | 
    MULOP ;

list_choice:
 	list |
 	IDENTIFIER ;

condition:
	condition ANDOP relation |
	relation ;

relation:
	'(' condition')' { $$ = $2; }	|
	expression RELOP expression {$$ = checkRelationAssignment($1, $3);} ;
	
expression:
	expression ADDOP term {$$ = checkArithmetic($1, $3);} |
	term ;
      
term:
	term MULOP factor {$$ = checkExpopAssignment($1, $3);}	|
	term REMOP factor {$$ = checkRemopAssignment($1, $3);} 	|
	factor ;

factor:      
    NEGOP factor {$$ = checkNegopAssignment($2);}	| 
	exponent ;

exponent:
    primary EXPOP exponent {$$ = checkExpopAssignment($1, $3);}|
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL 	{$$ = INT_TYPE;}	| 
	CHAR_LITERAL 	{$$ = CHAR_TYPE;}	|
	REAL_LITERAL 	{$$ = REAL_TYPE;}	| 
	IDENTIFIER '(' expression ')' {$$ = checkListSubscript($3); find(lists, $1, "List");} |
	IDENTIFIER  {$$ = find(scalars, $1, "Scalar");} ;

%%

Types find(Symbols<Types>& table, CharPtr identifier, string tableName) {
	Types type;
	if (!table.find(identifier, type)) {
		appendError(UNDECLARED, tableName + " " + identifier);
		return MISMATCH;
	}
	return type;
}

void checkDuplicate(Symbols<Types>& table, CharPtr identifier, string kind) {
    Types dummy;
    if (table.find(identifier, dummy)) {
        appendError(GENERAL_SEMANTIC, "Duplicate " + kind + " " + string(identifier));
    }
}

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
