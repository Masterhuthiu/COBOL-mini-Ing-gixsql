identification division.
       class-id. EmployeeRepo.

       method-id. InsertEmployee static.
       procedure division using by value empName as string,
                                        empAge  as binary-long.
           declare conn as type Npgsql.NpgsqlConnection
           declare cmd  as type Npgsql.NpgsqlCommand

           set conn = new Npgsql.NpgsqlConnection(
               "Host=localhost;Username=postgres;Password=postgres;Database=testdb")

           invoke conn "Open"

           set cmd = new Npgsql.NpgsqlCommand(
               "INSERT INTO emp(name, age) VALUES(@n, @a)", conn)

           invoke cmd::Parameters "AddWithValue" using "@n", empName
           invoke cmd::Parameters "AddWithValue" using "@a", empAge
           invoke cmd "ExecuteNonQuery"
           invoke conn "Close"
           goback.
       end method InsertEmployee.

       method-id. FetchEmployees static.
       procedure division.
           declare conn   as type Npgsql.NpgsqlConnection
           declare cmd    as type Npgsql.NpgsqlCommand
           declare reader as type Npgsql.NpgsqlDataReader

           set conn = new Npgsql.NpgsqlConnection(
               "Host=localhost;Username=postgres;Password=postgres;Database=testdb")

           invoke conn "Open"

           set cmd = new Npgsql.NpgsqlCommand(
               "SELECT name, age FROM emp", conn)

           invoke cmd "ExecuteReader" returning reader

           perform until not reader::Read()
               display "Ten: "  reader::GetString(0)
               display "Tuoi: " reader::GetInt32(1)
           end-perform

           invoke conn "Close"
           goback.
       end method FetchEmployees.

       end class EmployeeRepo.