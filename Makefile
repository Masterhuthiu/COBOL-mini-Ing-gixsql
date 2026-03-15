COBOL=cobc
OCESQL=ocesql

SRC=src
BIN=bin

all: build

build:
	mkdir -p $(BIN)

	for f in $(SRC)/*.cbl; do \
	    echo "Compiling $$f"; \
	    $(OCESQL) $$f; \
	    $(COBOL) -x $$f.cob -o $(BIN)/$$(basename $$f .cbl); \
	done

clean:
	rm -f $(SRC)/*.cob
	rm -rf $(BIN)