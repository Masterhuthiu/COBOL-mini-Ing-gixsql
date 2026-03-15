       IDENTIFICATION DIVISION.
       PROGRAM-ID. RIDERSERVICE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "../copy/rider.cpy".

       PROCEDURE DIVISION.

           IF RIDER-TYPE = "ACCIDENT"
               ADD 200 TO RIDER-PREMIUM
           END-IF.

           GOBACK.