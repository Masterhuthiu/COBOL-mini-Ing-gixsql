COBOL = cobc
SQLPP = gixsql

# Các thư mục nguồn
SRC_DIR = src
DB_DIR = db
BUILD_DIR = build

# Tìm tất cả file .cbl trong thư mục db và chuyển tên thành .cob (sau khi qua gixsql)
DB_SOURCES = $(wildcard $(DB_DIR)/*.cbl)
DB_INTERMEDIATE = $(patsubst $(DB_DIR)/%.cbl, %.cob, $(DB_SOURCES))

# Tìm tất cả file .cbl trong thư mục src
SRC_SOURCES = $(wildcard $(SRC_DIR)/*.cbl)

# Cờ biên dịch (Thêm thư viện SQL nếu cần, ví dụ -lpq cho PostgreSQL)
COBFLAGS = -x -free

all: prep app

# Tạo thư mục build nếu chưa có (để giữ môi trường sạch sẽ)
prep:
	@mkdir -p $(BUILD_DIR)

# Quy tắc tiền xử lý SQL: .cbl trong db/ -> .cob ở thư mục hiện tại
%.cob: $(DB_DIR)/%.cbl
	$(SQLPP) $< -o $@

# Biên dịch ứng dụng chính
app: $(DB_INTERMEDIATE)
	$(COBOL) $(COBFLAGS) -o app \
	$(SRC_SOURCES) \
	$(DB_INTERMEDIATE)

clean:
	rm -f app *.cob
	rm -rf $(BUILD_DIR)

.PHONY: all clean prep