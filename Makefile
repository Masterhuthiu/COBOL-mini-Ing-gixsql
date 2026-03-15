COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy

# Cờ biên dịch: -x (thực thi), -I (thư mục copybook), -locesql (thư viện DB)
COBFLAGS = -x -I$(CPY_DIR) -locesql

all: clean prep build

prep:
	@mkdir -p $(BIN_DIR)

build:
	@for f in $(SRC_DIR)/*.cbl $(DB_DIR)/*.cbl; do \
		[ -e "$$f" ] || continue; \
		base=$$(basename $$f .cbl); \
		echo "Processing $$f..."; \
		if grep -q "EXEC SQL" "$$f"; then \
			echo "  --> Running ocesql..."; \
			$(SQLPP) "$$f" > /dev/null; \
			# Kiểm tra file .cob ở cả thư mục gốc và thư mục của file nguồn \
			if [ -f "$$base.cob" ]; then \
				mv "$$base.cob" "$${f%.cbl}.cob"; \
			fi; \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: Could not find generated $$base.cob"; exit 1; \
			fi; \
		else \
			echo "  --> Compiling directly..."; \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete

.PHONY: all clean prep build