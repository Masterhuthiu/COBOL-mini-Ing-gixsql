name: COBOL Build System

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    # Sử dụng container có sẵn GixSQL để không phải tự build GixSQL nữa
    container:
      image: mridoni/gixsql:latest

    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v4

      - name: Install Database Headers
        run: |
          # Cài đặt thư viện để kết nối PostgreSQL (nếu bạn dùng DB khác hãy đổi tên lib)
          apt-get update
          apt-get install -y libpq-dev

      - name: Build Application
        run: |
          # Xóa các file cũ và tạo thư mục build nếu cần
          # Lệnh 'make' sẽ tự động chạy theo file Makefile của bạn
          make clean
          mkdir -p build
          make

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: cobol-app
          path: app