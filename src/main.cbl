       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       PROCEDURE DIVISION.

           DISPLAY "START MINI INGENIUM".

           CALL "DB-CONNECT".

           CALL "CREATE-POLICY".

           CALL "ADD-RIDER".

           DISPLAY "DONE".

           STOP RUN.