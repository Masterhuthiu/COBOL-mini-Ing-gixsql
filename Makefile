COBOL=cobc
OCESQL=ocesql

SRC=src
BIN=bin

all: build

build:
	pwd
	ls -l
	mkdir -p $(BIN)

	for f in $(SRC)/*.cbl; do \
		base=$$(basename $$f .cbl); \
		echo "Compiling $$base"; \
		$(OCESQL) $$f; \
		ls src; \
		$(COBOL) -x $(SRC)/$$base.cob -o $(BIN)/$$base; \
	done

clean:
	rm -f $(SRC)/*.cob
	rm -rf $(BIN)