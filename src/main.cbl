       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       PROCEDURE DIVISION.

           CALL "DB-CONNECT"

           CALL "CREATE-POLICY"

           CALL "ADD-RIDER"

           DISPLAY "DONE"

           STOP RUN.