identification division.
       class-id. Program.

       method-id. Main static.
       procedure division.
           invoke type EmployeeRepo "InsertEmployee" using "Dang", 30
           invoke type EmployeeRepo "FetchEmployees"
           goback.
       end method Main.

       end class Program.