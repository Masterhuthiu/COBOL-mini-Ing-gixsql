COBOL=cobc
GIX=gixsql

SRC=$(wildcard src/**/*.cbl)
OBJ=$(SRC:.cbl=.o)

all: ingenium

precompile:
	$(GIX) src/db/db_policy.cbl

compile:
	$(COBOL) -x -free -o ingenium $(SRC) -lpq

clean:
	rm -f ingenium *.o