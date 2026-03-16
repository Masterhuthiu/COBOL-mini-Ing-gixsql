       IDENTIFICATION DIVISION.
       CLASS-ID. EmployeeRepo.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       STATIC.
           *> Phương thức Add: In thông báo đã add
           METHOD-ID. InsertEmployee.
           DATA DIVISION.
           LINKAGE SECTION.
               01 empName AS ANY.
               01 empAge BINARY-LONG.
           PROCEDURE DIVISION USING BY VALUE empName, empAge.
               
               DISPLAY "------------------------------------".
               DISPLAY "COBOL ENGINE: Bat dau xu ly..." .
               DISPLAY "Hanh dong: DA ADD nhan vien " empName.
               DISPLAY "Tuoi: " empAge.
               DISPLAY "Trang thai: Thanh cong".
               DISPLAY "------------------------------------".

           END METHOD InsertEmployee.

           *> Phương thức List: In thông báo đã list
           METHOD-ID. FetchEmployees.
           PROCEDURE DIVISION.
               
               DISPLAY "------------------------------------".
               DISPLAY "COBOL ENGINE: Truy xuat du lieu...".
               DISPLAY "Hanh dong: DA LIST danh sach nhan vien".
               DISPLAY "He thong: Dang cho phan hoi tu Database".
               DISPLAY "------------------------------------".

           END METHOD FetchEmployees.
       END STATIC.

       END CLASS EmployeeRepo.