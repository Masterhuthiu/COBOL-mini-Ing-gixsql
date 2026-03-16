       class-id. EmployeeRepo.

       method-id. InsertEmployee static.
           01 empName string.
           01 empAge int.

           *> Tạo kết nối PostgreSQL
           invoke type Npgsql.NpgsqlConnection
               "new" returning conn
               with "Host=localhost;Username=postgres;Password=postgres;Database=testdb".

           invoke conn "Open".

           *> Tạo command INSERT
           invoke type Npgsql.NpgsqlCommand
               "new" returning cmd
               with "INSERT INTO emp(name, age) VALUES(@n, @a)", conn.

           invoke cmd "Parameters.AddWithValue" using "n", empName.
           invoke cmd "Parameters.AddWithValue" using "a", empAge.

           invoke cmd "ExecuteNonQuery".

           invoke conn "Close".
           goback.
       end method InsertEmployee.


       method-id. FetchEmployees static.
           01 reader object.

           invoke type Npgsql.NpgsqlConnection
               "new" returning conn
               with "Host=localhost;Username=postgres;Password=postgres;Database=testdb".

           invoke conn "Open".

           *> Tạo command SELECT
           invoke type Npgsql.NpgsqlCommand
               "new" returning cmd
               with "SELECT name, age FROM emp", conn.

           invoke cmd "ExecuteReader" returning reader.

           *> Duyệt kết quả
           perform until reader "Read" = false
               display "Tên: " reader "GetString"(0)
               display "Tuổi: " reader "GetInt32"(1)
           end-perform.

           invoke conn "Close".
           goback.
       end method FetchEmployees.

       end class EmployeeRepo.
