%{
#include <iostream>
#include "haml.tab.hpp"
using namespace std;
%}

DOCTYPE     !!!
STRING_LITERAL \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'

%x TAG
%x TAG_ATTRIBUTES
%x HTML_TEXT

%%

^{DOCTYPE}                     { return DOCTYPE; }
\%[a-zA-Z]+                    { BEGIN(TAG); return TAG_NAME; }
\.[a-zA-Z\-]+                  { BEGIN(TAG); return DIV; }

[a-z][0-9a-zA-Z_]*[?!]? { return IDENTIFIER; }

<TAG>"{"            { BEGIN(TAG_ATTRIBUTES); return '{'; }
<TAG>"."[a-zA-Z\-]+ { return TAG_CLASS; }
<TAG>" "            { BEGIN(HTML_TEXT); }
<TAG>\n             { BEGIN(INITIAL); }

<TAG_ATTRIBUTES>[a-zA-Z\-]+      { return ATTRIBUTE_NAME; }
<TAG_ATTRIBUTES>":"              { return ':'; }
<TAG_ATTRIBUTES>","              { return ','; }
<TAG_ATTRIBUTES>{STRING_LITERAL} { return STRING_LITERAL; }
<TAG_ATTRIBUTES>[a-z][0-9a-zA-Z_]*[?!]? { return IDENTIFIER; }
<TAG_ATTRIBUTES>"}"              { BEGIN(TAG); return '}'; }

<HTML_TEXT>[^\n]+\n { BEGIN(INITIAL); }


":" { return ':'; }
"{" { return '{'; }
"}" { return '}'; }
"," { return ','; }

%%
