       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADD-RIDER.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY "rider.cpy".

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.

           MOVE 1 TO POLICY-ID
           MOVE "ACCIDENT" TO RIDER-TYPE
           MOVE 200 TO RIDER-PREMIUM

           EXEC SQL
               INSERT INTO riders
               (policy_id, rider_type, rider_premium)
               VALUES
               (:POLICY-ID, :RIDER-TYPE, :RIDER-PREMIUM)
           END-EXEC

           DISPLAY "RIDER ADDED"

           GOBACK.