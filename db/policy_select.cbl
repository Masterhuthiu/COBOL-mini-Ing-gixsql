       IDENTIFICATION DIVISION.
       PROGRAM-ID. POLICYSELECT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       COPY "db/policy.cpy".

       PROCEDURE DIVISION.

           EXEC SQL
              SELECT customer_name, premium
              INTO :CUSTOMER-NAME, :PREMIUM
              FROM policy
              WHERE policy_id = :POLICY-ID
           END-EXEC.

           DISPLAY "CUSTOMER: " CUSTOMER-NAME
           DISPLAY "PREMIUM: " PREMIUM

           GOBACK.