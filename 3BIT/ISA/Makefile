PRJ=feedreader
CC=c++
CXXFLAGS=-std=c++11
feedreader:
	$(CC) -I/usr/include/libxml2 -I/usr/local/include/libxml2 -L/usr/local/lib -g -Wall $(CXXFLAGS) -o $@ $(PRJ).cpp -lcrypto -lssl -lxml2 -lz
test:
	make clean
	make
	chmod +x test.sh
	bash test.sh
clean:
	rm -f *.o $(PRJ)
