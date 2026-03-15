       IDENTIFICATION DIVISION.
       PROGRAM-ID. DB-CONNECT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE sqlca END-EXEC.

       PROCEDURE DIVISION.

           DISPLAY "CONNECTING DB".

           EXEC SQL
               CONNECT TO "testdb"
           END-EXEC.

           IF SQLCODE NOT = 0
               DISPLAY "CONNECT FAILED " SQLCODE
           ELSE
               DISPLAY "CONNECT OK"
           END-IF.

           GOBACK.