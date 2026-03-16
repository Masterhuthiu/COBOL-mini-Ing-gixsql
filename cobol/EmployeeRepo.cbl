class-id. EmployeeRepo.

       method-id. InsertEmployee static.
       procedure division using by value empName as string
                                  by value empAge as binary-long.
           
           *> Khởi tạo kết nối tới service "db" trong Docker
           declare conn type NpgsqlConnection
               = new NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
           invoke conn "Open".

           *> Chuẩn bị câu lệnh Insert
           declare cmd type NpgsqlCommand
               = new NpgsqlCommand("INSERT INTO emp (name, age) VALUES (@n, @a)", conn).
           
           invoke cmd "Parameters.AddWithValue" using "n", empName.
           invoke cmd "Parameters.AddWithValue" using "a", empAge.
           invoke cmd "ExecuteNonQuery".

           invoke conn "Close".
       end method InsertEmployee.

       method-id. FetchEmployees static.
       procedure division.
           declare conn type NpgsqlConnection
               = new NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
           invoke conn "Open".

           declare cmd type NpgsqlCommand
               = new NpgsqlCommand("SELECT name, age FROM emp", conn).
           declare reader type NpgsqlDataReader = cmd "ExecuteReader".

           *> Duyệt dữ liệu và in ra Console log để debug
           while reader "Read"
               display "Employee: " & reader["name"].ToString() & " | Age: " & reader["age"].ToString()
           end-while.

           invoke conn "Close".
       end method FetchEmployees.

       end class EmployeeRepo.