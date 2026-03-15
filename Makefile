COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy

# Cờ biên dịch: -x (thực thi), -I (thư mục copybook)
# Lưu ý: ocesql cần liên kết với thư viện ocesql (thường là -locesql)
COBFLAGS = -x -I$(CPY_DIR) -locesql

all: clean prep build

prep:
	@mkdir -p $(BIN_DIR)

build:
	@# Duyệt qua cả src và db để tìm file .cbl
	@for f in $(SRC_DIR)/*.cbl $(DB_DIR)/*.cbl; do \
		[ -e "$$f" ] || continue; \
		base=$$(basename $$f .cbl); \
		dir=$$(dirname $$f); \
		echo "Checking $$f..."; \
		if grep -q "EXEC SQL" "$$f"; then \
			echo "  --> Running ocesql for $$f"; \
			$(SQLPP) "$$f"; \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: $${f%.cbl}.cob not generated!"; exit 1; \
			fi; \
		else \
			echo "  --> Compiling directly: $$f"; \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete

.PHONY: all clean prep build