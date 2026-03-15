COBOL=cobc
OCESQL=ocesql

SRC=src
BIN=bin

PROGRAMS=main policy rider db

all: build

build:
	mkdir -p $(BIN)

	for f in $(SRC)/*.cbl; do \
	    $(OCESQL) $$f $$f.cob; \
	    $(COBOL) -x $$f.cob -o $(BIN)/$$(basename $$f .cbl); \
	done

clean:
	rm -rf $(BIN)/*.cob $(BIN)/*