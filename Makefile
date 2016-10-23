all: haml

haml: lex.yy.c haml.tab.cpp haml.tab.hpp
	g++ haml.tab.cpp lex.yy.c html_tag.cpp -ll -o haml

lex.yy.c: haml.l haml.tab.hh
	flex -d haml.l

haml.tab.cc haml.tab.hh: haml.ypp
	/usr/local/Cellar/bison/3.0.4/bin/bison -d haml.ypp

clean:
	rm -f haml lex.yy.c lex.yy.cc haml.tab.cpp haml.tab.hpp

run:
	cat sample.html.haml | ./haml
