COBOL = cobc
SQLPP = ocesql
BIN_DIR = bin
SRC_DIR = src
DB_DIR = db
CPY_DIR = copy
# Đường dẫn chuẩn của ocesql sau khi cài đặt trên Ubuntu
OCESQL_SHARE = /usr/local/share/ocesql
# nơi chứa sqlca
OCESQL_COPY=/usr/local/share/ocesql/copy

# Tham số ocesql: --inc cho copybook của bạn và sqlca của hệ thống
SQLPP_FLAGS = --inc=./$(OCESQL_COPY) --inc=$(OCESQL_SHARE)

# Tham số cobc: -I để nạp sqlca.cbl và các copybook vào quá trình biên dịch
COBFLAGS = -x -I$(OCESQL_COPY) -I$(OCESQL_SHARE) -locesql

all: clean prep build

prep:
	@mkdir -p $(BIN_DIR)

build:
	@for f in $(SRC_DIR)/*.cbl $(DB_DIR)/*.cbl; do \
		[ -e "$$f" ] || continue; \
		base=$$(basename $$f .cbl); \
		echo "Processing $$f..."; \
		if grep -q "EXEC SQL" "$$f"; then \
			$(SQLPP) $(SQLPP_FLAGS) "$$f"; \
			# Xử lý tiền tố 'preeql' do ocesql v1.4.0 tạo ra \
			if [ -f "preeql$$base.cob" ]; then mv "preeql$$base.cob" "$${f%.cbl}.cob"; fi; \
			if [ -f "$${f%.cbl}.cob" ]; then \
				$(COBOL) $(COBFLAGS) "$${f%.cbl}.cob" -o $(BIN_DIR)/$$base; \
			else \
				echo "  ERROR: Generated file not found for $$base"; exit 1; \
			fi; \
		else \
			$(COBOL) $(COBFLAGS) "$$f" -o $(BIN_DIR)/$$base; \
		fi; \
	done

clean:
	rm -rf $(BIN_DIR)
	find . -name "*.cob" -delete
	find . -name "preeql*.cob" -delete