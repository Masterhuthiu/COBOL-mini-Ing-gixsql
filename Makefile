COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy

# Tham số include đúng cho ocesql v1.4.0
SQLPP_FLAGS = --inc=./$(CPY_DIR)
# Liên kết thư viện runtime của Open-COBOL-ESQL
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
			$(SQLPP) $(SQLPP_FLAGS) "$$f"; \
			# XỬ LÝ LỖI TÊN FILE: ocesql v1.4.0 tạo ra 'preeql' + tên file \
			if [ -f "preeql$$base.cob" ]; then \
				mv "preeql$$base.cob" "$${f%.cbl}.cob"; \
			elif [ -f "$$base.cob" ]; then \
				mv "$$base.cob" "$${f%.cbl}.cob"; \
			fi; \
			# Kiểm tra lại và biên dịch \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: Cannot find generated file for $$base"; \
				ls -F; exit 1; \
			fi; \
		else \
			echo "  --> Compiling directly..."; \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete
	find . -name "preeql*.cob" -delete

.PHONY: all clean prep build