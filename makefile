pug.exe : y.tab.o lex.yy.o
	gcc -o pug.exe y.tab.o lex.yy.o -ll

y.tab.o : y.tab.c
	gcc -c y.tab.c

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c

y.tab.c y.tab.h : pug.y
	yacc -d pug.y

lex.yy.c : pug.l y.tab.h
	flex pug.l