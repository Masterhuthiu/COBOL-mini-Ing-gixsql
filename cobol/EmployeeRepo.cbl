class-id. EmployeeRepo.

method-id. InsertEmployee static.
    procedure division using by value name as string
                                by value age as binary-long.
    declare conn type NpgsqlConnection
        = new NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
    invoke conn "Open".

    declare cmd type NpgsqlCommand
        = new NpgsqlCommand("INSERT INTO emp (name, age) VALUES (@n, @a)", conn).
    invoke cmd "Parameters.AddWithValue" using "n", name.
    invoke cmd "Parameters.AddWithValue" using "a", age.
    invoke cmd "ExecuteNonQuery".

    invoke conn "Close".
end method InsertEmployee.

method-id. FetchEmployees static.
    procedure division.
    declare conn type NpgsqlConnection
        = new NpgsqlConnection("Host=db;Username=postgres;Password=postgres;Database=ingenium").
    invoke conn "Open".

    declare cmd type NpgsqlCommand
        = new NpgsqlCommand("SELECT id, name, age FROM emp", conn).
    declare reader type NpgsqlDataReader = cmd "ExecuteReader".

    while reader "Read"
        display "ID: " & reader["id"].ToString()
        display "Tên: " & reader["name"].ToString()
        display "Tuổi: " & reader["age"].ToString()
    end-while.

    invoke conn "Close".
end method FetchEmployees.

end class EmployeeRepo.
