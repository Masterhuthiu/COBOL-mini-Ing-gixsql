name: COBOL Build System

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    # Sử dụng Docker Image có sẵn GixSQL để tránh lỗi biên dịch GixSQL thủ công
    container:
      image: mridoni/gixsql:latest

    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v3

      - name: Update System Libraries
        run: |
          # Cài đặt thêm thư viện để kết nối Database (ví dụ PostgreSQL)
          # Nếu dùng DB khác, bạn có thể thay đổi libpq-dev
          apt-get update
          apt-get install -y libpq-dev

      - name: Build Application
        run: |
          # Sử dụng Makefile để tự động tìm file .cbl trong /src và /db
          # Lệnh 'make prep' tạo thư mục build (nếu Makefile của bạn có dùng)
          make clean
          make prep || true 
          make

      - name: Archive Binary Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: cobol-executable
          path: app
          retention-days: 5