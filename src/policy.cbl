       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-POLICY.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 CUSTOMER-NAME     PIC X(100).
       01 PREMIUM           PIC 9(7)V99.
       01 START-DATE        PIC X(10).

       EXEC SQL INCLUDE sqlca END-EXEC.

       PROCEDURE DIVISION.

           MOVE "John Doe" TO CUSTOMER-NAME
           MOVE 1000 TO PREMIUM
           MOVE "2026-01-01" TO START-DATE

           EXEC SQL
               INSERT INTO policies
               (customer_name, premium, start_date)
               VALUES
               (:CUSTOMER-NAME, :PREMIUM, :START-DATE)
           END-EXEC.

           IF SQLCODE = 0
               DISPLAY "POLICY CREATED"
           ELSE
               DISPLAY "ERROR INSERT POLICY: " SQLCODE
           END-IF.

           GOBACK.