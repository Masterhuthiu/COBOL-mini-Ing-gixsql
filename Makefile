COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy

# Cập nhật tham số include đúng cho ocesql v1.4.0
SQLPP_FLAGS = --inc=./$(CPY_DIR)
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
			# Ocesql mặc định tạo file .cob cùng thư mục với file .cbl nguồn \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: ocesql failed to generate $${f%.cbl}.cob"; \
				exit 1; \
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