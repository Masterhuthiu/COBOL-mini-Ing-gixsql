       class-id. Program.
       method-id. Main static.
           *> Gọi InsertEmployee
           invoke type EmployeeRepo "InsertEmployee" using "Dang", 30.

           *> Gọi FetchEmployees
           invoke type EmployeeRepo "FetchEmployees".
           goback.
       end method Main.
       end class Program.
