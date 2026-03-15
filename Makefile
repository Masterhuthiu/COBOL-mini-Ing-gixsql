COBOL = cobc
SQLPP = gixsql

# Thư mục chứa các file COPY (.cpy)
CPY_DIR = copy
SQLPP_FLAGS = -I$(CPY_DIR) -I.

# Tìm tất cả file .cbl có chứa EXEC SQL (thường nằm trong db/)
# Dùng shell find để chắc chắn tìm thấy file trên Linux
DB_SOURCES := $(shell find . -name "*.cbl" -path "*/db/*")
DB_INTERMEDIATE := $(patsubst %.cbl, %.cob, $(notdir $(DB_SOURCES)))

# Các file COBOL thuần trong src
SRC_SOURCES := $(shell find . -name "*.cbl" -path "*/src/*")

COBFLAGS = -x -free -I$(CPY_DIR) -lpq

all: prep $(DB_INTERMEDIATE) app

prep:
	@mkdir -p build

# Quy tắc biên dịch linh hoạt cho file SQL
%.cob: 
	@echo "Processing SQL for $<..."
	$(SQLPP) $(SQLPP_FLAGS) $(shell find . -name "$*.cbl") -o $@

app:
	$(COBOL) $(COBFLAGS) -o app $(SRC_SOURCES) $(DB_INTERMEDIATE)

clean:
	rm -f app *.cob
	rm -rf build

.PHONY: all clean prep