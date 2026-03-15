       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADD-RIDER.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 POLICY-ID       PIC 9(9).
       01 RIDER-TYPE      PIC X(50).
       01 RIDER-PREMIUM   PIC 9(7)V99).

       EXEC SQL INCLUDE sqlca END-EXEC.

       PROCEDURE DIVISION.

           MOVE 1 TO POLICY-ID
           MOVE "ACCIDENT" TO RIDER-TYPE
           MOVE 200 TO RIDER-PREMIUM

           EXEC SQL
               INSERT INTO riders
               (policy_id, rider_type, rider_premium)
               VALUES
               (:POLICY-ID, :RIDER-TYPE, :RIDER-PREMIUM)
           END-EXEC.

           IF SQLCODE = 0
               DISPLAY "RIDER ADDED"
           ELSE
               DISPLAY "ERROR INSERT RIDER: " SQLCODE
           END-IF.

           GOBACK.