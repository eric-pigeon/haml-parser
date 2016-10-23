%{
#include <iostream>
#include "haml.tab.hpp"
using namespace std;
%}

DOCTYPE     !!!
ALPHA       [a-zA-Z]
ATTRIBUTE_KEY [a-zA-Z\-]
STRING_LITERAL \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'

%%

^{DOCTYPE}                     { return DOCTYPE; }
\%{ALPHA}+                     { return TAG; }
[a-zA-Z\-]+:\ {STRING_LITERAL} { return HTML_ATTRIBUTE; }


":" { return ':'; }
"{" { return '{'; }
"}" { return '}'; }
"," { return ','; }
