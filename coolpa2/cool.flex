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
 
 /*
 *  Keep the contract for MAX_STR_CONST by counting string constant chars
 */
 
 int string_length = 0;

%}

 /*
  *  Exclusive states (%x) switch to using only their rules, necessary for strings that
  *  could contain keywords.
  */
%x string

 /*
 * Keywords from cool manual 10.4, in same order
 */

/*
 * Keywords from cool manual 10.4, in same order
 */
CLASS           (?i:class)
ELSE            (?i:else)
FALSE           ([f][aA][lL][sS][eE])
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
TRUE            ([t][rR][uU][eE])

/*
 * Whitespace as defined in cool manual 10.5
 */
WSP             [ \n\f\r\t\v]+


DIGIT           [0-9]
ID              [a-z][a-zA-Z0-9_]*
TYPE            [A-Z][a-zA-Z0-9_]*



%%


 /*
  *  TODO -  Nested comments
  */


 /*
  *  The (non-keyword) operators, in the order presented in figure 10.
  */
":"		{ return ':'; }
"<-"	{ return (ASSIGN); }
"@"     { return '@'; }
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
"{"		{ return '{'; }
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

 /*
  * TODO - some way to get the constant through as a token
  */
  
{TRUE}            { return (BOOL_CONST); }

{FALSE}           { return (BOOL_CONST); }



 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
  
\"                  { 
                        string_buf_ptr = string_buf;
                        string_length = 0;
                        BEGIN(string); 
                    }
<string>\"          {
                        if (string_length < MAX_STR_CONST ) {
                            cool_yylval.symbol = stringtable.add_string(string_buf);
                            *string_buf_ptr = '\0';
                            return (STR_CONST);
                        } else {
                            cool_yylval.error_msg = "String constant is longer than the buffer";
                            return (ERROR);
                        }
                    }
<string>\\n         {
                        string_length++;
                        if ( string_length < MAX_STR_CONST ) {
                            *string_buf_ptr++ = '\n';
                        }
                    }
 
 /*
  * put this ANY dot last so that specific chars are visible
  */                   
<string>.           {
                        string_length++;
                        if ( string_length < MAX_STR_CONST ) {
                            *string_buf_ptr++ = '\n';
                        }
                    } 
  
   
  
{TYPE}              {
                        cool_yylval.symbol = idtable.add_string(yytext);
                        return (TYPEID);
                    }
                    
{ID}                {
                        cool_yylval.symbol = idtable.add_string(yytext);
                        return (OBJECTID);
                    }

%%
