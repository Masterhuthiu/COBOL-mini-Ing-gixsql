       class-id. EmployeeRepo.

       factory.
       data division.
       working-storage section.
       01 StaticMessage pic x(50) value "Xin chao tu Factory.".

       procedure division.
       method-id. PrintStaticMessage static.
           procedure division.
               display StaticMessage
           end method PrintStaticMessage.
       end factory.

       object.
       data division.
       working-storage section.
       01 Name pic x(50).
       01 Age pic 9(4).

       procedure division.
       method-id. SetEmployee.
           procedure division using by value newName as string
                                      by value newAge as binary-long.
               move newName to Name
               move newAge to Age
           end method SetEmployee.

       method-id. PrintEmployee.
           procedure division.
               display "Ten: " & Name
               display "Tuoi: " & Age
           end method PrintEmployee.
       end object.

       end class EmployeeRepo.
