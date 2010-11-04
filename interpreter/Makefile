CXXFLAGS=-O3 -Wall
tm: tm.o lexer.o parser.o vm.o debugger.o
	g++ $^ -o tm -Wall -lncurses

clean:
	rm -f *.o

