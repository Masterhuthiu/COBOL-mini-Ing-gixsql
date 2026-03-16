IDENTIFICATION DIVISION.
       CLASS-ID. EmployeeRepo.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           *> Khai báo các kiểu dữ liệu .NET cần thiết
           CLASS NpgsqlConnection AS "Npgsql.NpgsqlConnection"
           CLASS NpgsqlCommand AS "Npgsql.NpgsqlCommand"
           CLASS NpgsqlDataReader AS "Npgsql.NpgsqlDataReader".

       STATIC.
           METHOD-ID. InsertEmployee.
           DATA DIVISION.
           LOCAL-STORAGE SECTION.
               DECLARE conn TYPE NpgsqlConnection.
               DECLARE cmd TYPE NpgsqlCommand.
           LINKAGE SECTION.
               *> Tham số truyền vào từ C#
               01 empName AS ANY.
               01 empAge BINARY-LONG.
           PROCEDURE DIVISION USING BY VALUE empName, empAge.
               
               *> Khởi tạo kết nối tới DB (Sử dụng Host=db cho Docker)
               SET conn TO NEW NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
               INVOKE conn "Open".

               *> Thực thi lệnh SQL Insert
               SET cmd TO NEW NpgsqlCommand("INSERT INTO emp (name, age) VALUES (@n, @a)", conn).
               INVOKE cmd "Parameters.AddWithValue" USING "n", empName.
               INVOKE cmd "Parameters.AddWithValue" USING "a", empAge.
               INVOKE cmd "ExecuteNonQuery".

               INVOKE conn "Close".
           END METHOD InsertEmployee.

           METHOD-ID. FetchEmployees.
           DATA DIVISION.
           LOCAL-STORAGE SECTION.
               DECLARE conn TYPE NpgsqlConnection.
               DECLARE cmd TYPE NpgsqlCommand.
               DECLARE reader TYPE NpgsqlDataReader.
           PROCEDURE DIVISION.
               SET conn TO NEW NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
               INVOKE conn "Open".

               SET cmd TO NEW NpgsqlCommand("SELECT name, age FROM emp", conn).
               SET reader TO INVOKE cmd "ExecuteReader".

               *> Duyệt và in kết quả ra Console (Log của GitHub Actions/Docker)
               PERFORM UNTIL NOT INVOKE reader "Read"
                   DISPLAY "COBOL Log: " INVOKE reader["name"] " | Age: " INVOKE reader["age"]
               END-PERFORM.

               INVOKE conn "Close".
           END METHOD FetchEmployees.
       END STATIC.

       END CLASS EmployeeRepo.