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
          git \
          libpq-dev \
          wget

    - name: Install OpenCOBOL-ESQL
      run: |
        git clone https://github.com/opensourcecobol/Open-COBOL-ESQL.git
        cd Open-COBOL-ESQL
        ./configure
        make
        sudo make install

    - name: Build project
      run: |
        make