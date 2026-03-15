COBOL = cobc
SQLPP = gixsql

# Thêm đường dẫn chứa các file COPY (.cpy)
CPY_DIR = copy
# Cờ bổ sung cho GixSQL để tìm file copy
SQLPP_FLAGS = -I$(CPY_DIR)

# Các thư mục nguồn
SRC_DIR = src
DB_DIR = db
BUILD_DIR = build

DB_SOURCES = $(wildcard $(DB_DIR)/*.cbl)
DB_INTERMEDIATE = $(patsubst $(DB_DIR)/%.cbl, %.cob, $(DB_SOURCES))
SRC_SOURCES = $(wildcard $(SRC_DIR)/*.cbl)

COBFLAGS = -x -free -I$(CPY_DIR)

all: prep app

prep:
	@mkdir -p $(BUILD_DIR)

# Cập nhật quy tắc này để thêm $(SQLPP_FLAGS)
%.cob: $(DB_DIR)/%.cbl
	$(SQLPP) $(SQLPP_FLAGS) $< -o $@

app: $(DB_INTERMEDIATE)
	$(COBOL) $(COBFLAGS) -o app \
	$(SRC_SOURCES) \
	$(DB_INTERMEDIATE)

clean:
	rm -f app *.cob
	rm -rf $(BUILD_DIR)

.PHONY: all clean prep