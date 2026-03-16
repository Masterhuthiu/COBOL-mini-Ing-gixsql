       IDENTIFICATION DIVISION.
       CLASS-ID. Program.

       METHOD-ID. Main STATIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           DECLARE emp TYPE Employee.
       PROCEDURE DIVISION.
           SET emp::Name TO "Dang".
           SET emp::Age TO 30.

           INVOKE emp "PrintInfo".
           GOBACK.
       END METHOD Main.

       END CLASS Program.
