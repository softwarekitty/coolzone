LIB= ?

SRC= cool.flex test.cl
CSRC= lextest.cc utilities.cc stringtab.cc handle_flags.cc
TSRC= mycoolc
CGEN= cool-lex.cc
LIBS= parser semant cgen
CFIL= ${CSRC} ${CGEN}
OBJS= ${CFIL:.cc=.o}
OUTPUT= test.output

CPPINCLUDE= -I. -Iinclude

FFLAGS= -d -ocool-lex.cc

CC=g++
CFLAGS= -g -Wall -Wno-unused ${CPPINCLUDE}
FLEX=./flex ${FFLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

${OUTPUT}:	lexer test.cl
	@rm -f test.output
	-./lexer test.cl >test.output 2>&1 

lexer: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -o lexer

.cc.o:
	${CC} ${CFLAGS} -c $<

cool-lex.cc: cool.flex 
	${FLEX} cool.flex

dotest:	lexer test.cl
	./lexer test.cl

clean :
	-rm -f ${OUTPUT} *.s *.d ${OBJS}

%.d: %.cc ${SRC}
	${SHELL} -ec '${DEPEND} $< | sed '\''s/\($*\.o\)[ :]*/\1 $@ : /g'\'' > $@'

-include ${CFIL:.cc=.d}

