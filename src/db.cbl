       IDENTIFICATION DIVISION.
       PROGRAM-ID. DB-CONNECT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE sqlca END-EXEC.

       PROCEDURE DIVISION.

           DISPLAY "CONNECTING DATABASE..."

           EXEC SQL
               CONNECT TO "testdb"
               USER "postgres"
               USING "password"
           END-EXEC.

           IF SQLCODE NOT = 0
               DISPLAY "DB CONNECT FAILED: " SQLCODE
           ELSE
               DISPLAY "DB CONNECT OK"
           END-IF.

           GOBACK.