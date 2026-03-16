IDENTIFICATION DIVISION.
CLASS-ID. EmployeeRepo.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

STATIC.
    METHOD-ID. InsertEmployee.
    DATA DIVISION.
    LINKAGE SECTION.
        01 empName AS ANY.
        01 empAge BINARY-LONG.
    PROCEDURE DIVISION USING BY VALUE empName, empAge.

        DISPLAY "------------------------------------".
        DISPLAY "COBOL: DA ADD nhan vien " empName.
        DISPLAY "Tuoi: " empAge.
        DISPLAY "------------------------------------".

    END METHOD InsertEmployee.

    METHOD-ID. FetchEmployees.
    PROCEDURE DIVISION.

        DISPLAY "------------------------------------".
        DISPLAY "COBOL: DA LIST danh sach nhan vien".
        DISPLAY "------------------------------------".

    END METHOD FetchEmployees.
END STATIC.

END CLASS EmployeeRepo.
