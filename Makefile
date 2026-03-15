name: COBOL Build System

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    # SỬ DỤNG CONTAINER: Đây là chìa khóa để bỏ qua bước build GixSQL bị lỗi
    container:
      image: mridoni/gixsql:latest

    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v4

      - name: Install Database Headers
        run: |
          # Cài đặt thư viện để kết nối PostgreSQL (libpq)
          apt-get update
          apt-get install -y libpq-dev

      - name: Build Application
        run: |
          # Lệnh make sẽ tự động sử dụng gixsql và cobc có sẵn trong container
          make clean
          make prep || true
          make

      - name: Upload Binary
        uses: actions/upload-artifact@v4
        with:
          name: cobol-app
          path: app