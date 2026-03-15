       IDENTIFICATION DIVISION.
       PROGRAM-ID. POLICYINSERT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       COPY "../copy/policy.cpy".

       PROCEDURE DIVISION.

           EXEC SQL
             INSERT INTO policy
             VALUES (:POLICY-ID,
                     :CUSTOMER-NAME,
                     :POLICY-TYPE,
                     :PREMIUM)
           END-EXEC.

           GOBACK.