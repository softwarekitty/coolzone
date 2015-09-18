/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */
#define yywrap() 1
#define YY_SKIP_YYWRAP

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */

/*
 * Keywords from cool manual 10.4, in same order
 */
CLASS           (?i:class)
ELSE            (?i:else)
FALSE           [f][aA][lL][sS][eE]
FI              (?i:fi)
IF              (?i:if)
IN              (?i:in)
INHERITS        (?i:inherits)
ISVOID          (?i:isvoid)
LET             (?i:let)
LOOP            (?i:loop)
POOL            (?i:pool)
THEN            (?i:then)
WHILE           (?i:while)
CASE            (?i:case)
ESAC            (?i:esac)
NEW             (?i:new)
OF              (?i:of)
NOT             (?i:not)
TRUE            [t][rR][uU][eE]

/*
 * Whitespace as defined in cool manual 10.5
 */
WSP             [ \n\f\r\t\v]+


DIGIT           [:digit:]
ID              [:lower:][a-zA-Z0-9_]*
TYPE            [:upper:][a-zA-Z0-9_]*

%%


 /*
  *  Nested comments
  */


 /*
  *  The (non-keyword) operators, in the order presented in figure 10.
  */
":"		{ return ':'; }
"<-"	{ return 'ASN'; }
"@'     { return '@'; }
"."		{ return '.'; }
","		{ return ','; }
"=>"	{ return (DARROW); }
"+"		{ return '+'; }
"-"		{ return '-'; }
"*"		{ return '*'; }
"/"		{ return '/'; }
"~"		{ return '~'; }
"<"		{ return '<'; }
"<="	{ return 'LE'; }
"="		{ return '='; }
"("		{ return '('; }
")"		{ return ')'; }

 /*
  *  blocks.
  */
"{"		{ return '}'; }
"}"		{ return '}'; }
";"		{ return ';'; }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.  Operator-like keywords are first.
  */
  
{NOT}	        { return (NOT); }
{ISVOID}        { return (ISVOID); }

{CLASS}           { return (CLASS); }
{ELSE}            { return (ELSE); }
{FALSE}           { return (FALSE); }
{FI}              { return (FI); }
{IF}              { return (IF); }
{IN}              { return (IN); }
{INHERITS}        { return (INHERITS); }
{LET}             { return (LET); }
{LOOP}            { return (LOOP); }
{POOL}            { return (POOL); }
{THEN}            { return (THEN); }
{WHILE}           { return (WHILE); }
{CASE}            { return (CASE); }
{ESAC}            { return (ESAC); }
{NEW}             { return (NEW); }
{OF}              { return (OF); }
{TRUE}            { return (TRUE); }


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
