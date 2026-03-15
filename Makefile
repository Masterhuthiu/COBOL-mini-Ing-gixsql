name: COBOL Build

on:
  push:
    branches: [ main ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:

    - name: Checkout
      uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt update
        sudo apt install -y \
          gnucobol \
          gcc \
          make \
          autoconf \
          automake \
          libtool \
          flex \
          bison \
          libpq-dev

    - name: Install GixSQL
      run: |
        git clone https://github.com/mridoni/gixsql.git
        cd gixsql
        autoreconf -i
        ./configure
        make
        sudo make install

    - name: Build COBOL project
      run: |
        make