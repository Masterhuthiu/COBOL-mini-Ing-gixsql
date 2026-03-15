COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy
# Thư mục chứa sqlca.cbl của ocesql (mặc định trên Ubuntu thường là /usr/local/share/ocesql)
OCESQL_SHARE = /usr/local/share/ocesql

# Tham số ocesql: --inc cho copybook của bạn, --inc cho sqlca của hệ thống
SQLPP_FLAGS = --inc=./$(CPY_DIR) --inc=$(OCESQL_SHARE)
# Tham số cobc: -I cho copybook, -I cho sqlca
COBFLAGS = -x -I$(CPY_DIR) -I$(OCESQL_SHARE) -locesql

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
			# Xử lý file đầu ra có tiền tố preeql \
			if [ -f "preeql$$base.cob" ]; then \
				mv "preeql$$base.cob" "$${f%.cbl}.cob"; \
			elif [ -f "$$base.cob" ]; then \
				mv "$$base.cob" "$${f%.cbl}.cob"; \
			fi; \
			# Biên dịch file .cob đã tạo \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: Failed to generate $$base.cob"; exit 1; \
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