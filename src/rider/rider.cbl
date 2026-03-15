       IDENTIFICATION DIVISION.
       CLASS-ID. Rider.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 rider-name PIC X(50).
       01 rider-fee  PIC 9(7)V99.

       METHOD-ID. setData.
       LINKAGE SECTION.
       01 p-name PIC X(50).
       01 p-fee  PIC 9(7)V99.
       PROCEDURE DIVISION USING p-name p-fee.
           MOVE p-name TO rider-name
           MOVE p-fee  TO rider-fee
       END METHOD.

       METHOD-ID. getFee.
       PROCEDURE DIVISION RETURNING rider-fee.
       END METHOD.

       END CLASS.