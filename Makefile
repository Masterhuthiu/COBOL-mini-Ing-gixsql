COBOL = cobc
SQLPP = ocesql

BIN_DIR = bin
SRC_DIR = src
DB_DIR  = db
CPY_DIR = copy

OCESQL_COPY  = /usr/local/share/open-cobol-esql/copy
OCESQL_SHARE = /usr/local/share/open-cobol-esql

SQLPP_FLAGS = --inc=$(CPY_DIR) --inc=$(OCESQL_COPY)

COBFLAGS = -x \
    -I$(CPY_DIR) \
    -I$(OCESQL_COPY) \
    -I$(OCESQL_SHARE) \
    -locesql

all: clean prep build

prep:
	mkdir -p $(BIN_DIR)

build:
	@echo "========================================"
	@echo " COBOL + ESQL BUILD START"
	@echo "========================================"

	@echo "Checking sqlca..."
	@ls -l $(OCESQL_COPY)

	@for f in $(SRC_DIR)/*.cbl $(DB_DIR)/*.cbl; do \
		[ -e "$$f" ] || continue; \
		base=$$(basename $$f .cbl); \
		echo ""; \
		echo "Processing $$f"; \
		echo "----------------------------------------"; \
		if grep -q "EXEC SQL" "$$f"; then \
			echo "SQL detected → running ocesql"; \
			$(SQLPP) $(SQLPP_FLAGS) "$$f"; \
			if [ -f "preeql$$base.cob" ]; then \
				mv "preeql$$base.cob" "$${f%.cbl}.cob"; \
			fi; \
			if [ -f "$${f%.cbl}.cob" ]; then \
				echo "Compiling generated COBOL"; \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "ERROR: generated file not found for $$base"; \
				exit 1; \
			fi; \
		else \
			echo "Normal COBOL compile"; \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

	@echo ""
	@echo "========================================"
	@echo " BUILD FINISHED"
	@echo "========================================"

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete
	find . -name "preeql*.cob" -delete