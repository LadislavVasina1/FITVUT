PRJ=hinfosvc
CC=gcc
CFLAGS=-std=gnu99 -Wall -Wextra -pedantic
hinfosvc: $(PRJ).o
	$(CC) $(CFLAGS) -o $@ $(PRJ).c
clean:
	rm -f *.o $(PRJ)
