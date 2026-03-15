       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTPOLICY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 POLICY-ID        PIC 9(6).
       01 CUSTOMER-NAME    PIC X(50).
       01 POLICY-TYPE      PIC X(20).
       01 PREMIUM          PIC 9(7)V99.
       EXEC SQL END DECLARE SECTION END-EXEC.

       PROCEDURE DIVISION.

           DISPLAY "=== COBOL POLICY TEST ===".

           MOVE 1001 TO POLICY-ID.
           MOVE "NGUYEN VAN A" TO CUSTOMER-NAME.
           MOVE "LIFE" TO POLICY-TYPE.
           MOVE 1500.50 TO PREMIUM.

           DISPLAY "INSERT POLICY...".

           EXEC SQL
              INSERT INTO policy
              VALUES (:POLICY-ID, :CUSTOMER-NAME, :POLICY-TYPE, :PREMIUM)
           END-EXEC.

           IF SQLCODE = 0
               DISPLAY "INSERT SUCCESS"
           ELSE
               DISPLAY "INSERT FAILED SQLCODE=" SQLCODE
           END-IF.

           DISPLAY "READ POLICY...".

           EXEC SQL
              SELECT CUSTOMER_NAME, POLICY_TYPE, PREMIUM
              INTO :CUSTOMER-NAME, :POLICY-TYPE, :PREMIUM
              FROM policy
              WHERE policy_id = :POLICY-ID
           END-EXEC.

           DISPLAY "======================"
           DISPLAY "Policy ID  : " POLICY-ID
           DISPLAY "Customer   : " CUSTOMER-NAME
           DISPLAY "Type       : " POLICY-TYPE
           DISPLAY "Premium    : " PREMIUM
           DISPLAY "======================"

           STOP RUN.
