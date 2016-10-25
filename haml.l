%{
#include <iostream>
#include "haml.tab.hpp"
using namespace std;
%}

DOCTYPE     !!!
STRING_LITERAL \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'

%x TAG
%x TAG_ATTRIBUTE_NAME
%x TAG_ATTRIBUTE_VALUE
%x HTML_TEXT
%x CODE
%s INDENTATION

%%

^{DOCTYPE}                     { return DOCTYPE; }
\%[a-zA-Z]+                    { BEGIN(TAG); yylval.sval = strdup(yytext+1); return TAG_NAME; }
\.[a-zA-Z\-]+                  { BEGIN(TAG); yylval.sval = strdup("div"); return DIV; }
^"  "                          { BEGIN(INDENTATION); return INDENT; }
[a-z][0-9a-zA-Z_]*[?!]?        { return IDENTIFIER; }

<INDENTATION>"  " { return INDENT; }

<TAG>"{"            { BEGIN(TAG_ATTRIBUTE_NAME); return '{'; }
<TAG>"."[a-zA-Z\-]+ { return TAG_CLASS; }
<TAG>" "            { BEGIN(HTML_TEXT); }
<TAG>"="            { BEGIN(CODE); }
<TAG>\n             { BEGIN(INITIAL); }

<TAG_ATTRIBUTE_NAME>[a-zA-Z\-_]+      { return ATTRIBUTE_NAME; }
<TAG_ATTRIBUTE_NAME>": "               { BEGIN(TAG_ATTRIBUTE_VALUE); return ':'; }

<TAG_ATTRIBUTE_VALUE>{STRING_LITERAL}        { return STRING_LITERAL; }
<TAG_ATTRIBUTE_VALUE>[a-z][0-9a-zA-Z_]*[?!]? { return IDENTIFIER; }
<TAG_ATTRIBUTE_VALUE>","                     { BEGIN(TAG_ATTRIBUTE_NAME); return ','; }
<TAG_ATTRIBUTE_VALUE>"}"                     { BEGIN(TAG); return '}'; }

<HTML_TEXT>[^\n]+\n { BEGIN(INITIAL); }
<CODE>[^\n]+\n      { BEGIN(INITIAL); }

":" { return ':'; }
"{" { return '{'; }
"}" { return '}'; }
"," { return ','; }

%%
