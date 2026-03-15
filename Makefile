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
		if grep -q "EXEC SQL" $$f; then \
			echo "Running ocesql for $$f"; \
			$(OCESQL) $$f; \
			$(COBOL) -x $(SRC)/$$base.cob -o $(BIN)/$$base; \
		else \
			echo "No SQL, compiling directly"; \
			$(COBOL) -x $$f -o $(BIN)/$$base; \
		fi; \
	done

clean:
	rm -f $(SRC)/*.cob
	rm -rf $(BIN)