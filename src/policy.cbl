       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-POLICY.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY "policy.cpy".

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.

           MOVE "John Doe" TO CUSTOMER-NAME
           MOVE 1000 TO PREMIUM
           MOVE "2026-01-01" TO START-DATE

           EXEC SQL
               INSERT INTO policies
               (customer_name, premium, start_date)
               VALUES
               (:CUSTOMER-NAME, :PREMIUM, :START-DATE)
           END-EXEC

           DISPLAY "POLICY CREATED"

           GOBACK.