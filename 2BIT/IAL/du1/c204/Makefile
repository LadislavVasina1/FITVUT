
PRJ=c204
#
C202PATH=../c202/
PROGS=$(PRJ)-test
CC=gcc
CFLAGS=-std=c99 -Wall -Wextra -pedantic -lm -I$(C202PATH) -fcommon

.PHONY: run advanced clean tests

all: $(PROGS) $(PRJ)-advanced-test

run: $(PROGS) $(PRJ)-test.output
	@./$(PROGS) > current-test.output
	@echo "\nTest output differences:"
	@diff -su $(PROGS).output current-test.output
	@rm -f current-test.output

$(PRJ)-test: $(PRJ).c $(PRJ)-test.c $(C202PATH)c202.c
	$(CC) $(CFLAGS) -o $@ $(PRJ).c $(PRJ)-test.c $(C202PATH)c202.c

advanced: $(PRJ)-advanced-test $(PRJ)-advanced-test.output
	@./$(PRJ)-advanced-test > current-advanced-test.output
	@echo "\nTest output differences:"
	@diff -su $(PRJ)-advanced-test.output current-advanced-test.output
	@rm -f current-advanced-test.output

$(PRJ)-advanced-test: $(PRJ).c $(PRJ)-advanced-test.c $(C202PATH)c202.c
	$(CC) $(CFLAGS) -o $@ $(PRJ).c $(PRJ)-advanced-test.c $(C202PATH)c202.c

clean:
	rm -f *.o $(PROGS)
#