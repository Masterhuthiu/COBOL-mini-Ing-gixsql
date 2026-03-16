       identification division.
       class-id. Program.

       method-id. main static.
       procedure division.
           invoke type EmployeeRepo "InsertEmployee" using "Dang", 30
           invoke type EmployeeRepo "FetchEmployees"
           goback.
       end method main.

       end class Program.
