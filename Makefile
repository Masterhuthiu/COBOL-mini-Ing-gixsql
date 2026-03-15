COBOL = cobc
SQLPP = ocesql

BIN_DIR = bin
SRC_DIR = src
DB_DIR  = db
CPY_DIR = copy

# Open-COBOL-ESQL install path
OCESQL_SHARE = /usr/local/share/ocesql
OCESQL_COPY  = /usr/local/share/ocesql/copy

# Precompiler include paths
SQLPP_FLAGS = --inc=$(CPY_DIR) --inc=$(OCESQL_COPY)

# COBOL compiler flags
COBFLAGS = -x \
	-I$(CPY_DIR) \
	-I$(OCESQL_COPY) \
	-I$(OCESQL_SHARE) \
	-locesql

all: clean prep build

prep:
	@mkdir -p $(BIN_DIR)

build:
	@for f in $(SRC_DIR)/*.cbl $(DB_DIR)/*.cbl; do \
		[ -e "$$f" ] || continue; \
		base=$$(basename $$f .cbl); \
		echo "Processing $$f ..."; \
		if grep -q "EXEC SQL" "$$f"; then \
			echo "  -> SQL detected, running ocesql"; \
			$(SQLPP) $(SQLPP_FLAGS) "$$f"; \
			\
			# rename file created by ocesql (preeql*.cob) \
			if [ -f "preeql$$base.cob" ]; then \
				mv "preeql$$base.cob" "$${f%.cbl}.cob"; \
			fi; \
			\
			if [ -f "$${f%.cbl}.cob" ]; then \
				echo "  -> compiling generated COBOL"; \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "ERROR: generated file not found for $$base"; \
				exit 1; \
			fi; \
		else \
			echo "  -> normal COBOL compile"; \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete
	find . -name "preeql*.cob" -delete