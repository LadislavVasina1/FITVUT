PRJ=main
CC=c++
CXXFLAGS=-std=c++17
main:
	$(CC) -g -Wall -Wextra $(CXXFLAGS) -o $@ $(PRJ).cpp -l simlib
run:	${PRJ}
	./${PRJ}
clean:
	rm -f *.o $(PRJ)
