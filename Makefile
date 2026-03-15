COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy

# Thêm thư mục copy vào đường dẫn tìm kiếm của ocesql bằng tham số -I
SQLPP_FLAGS = -I./$(CPY_DIR)
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
			# Kiểm tra các vị trí file .cob có thể xuất hiện \
			if [ -f "$$base.cob" ]; then mv "$$base.cob" "$${f%.cbl}.cob"; fi; \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: ocesql failed to generate $$base.cob. Check syntax in $$f"; \
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