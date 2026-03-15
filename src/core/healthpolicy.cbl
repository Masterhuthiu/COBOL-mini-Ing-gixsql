       identification division.
       class-id. HealthPolicy inherits StandardPolicy.

       data division.
       working-storage section.
       01 health-factor pic 9v99 value 1.10.

       method-id. calcPremium.
       linkage section.
       01 result pic 9(9)v99.

       procedure division returning result.

           invoke self "getPremium" returning result
           compute result = result * health-factor

           goback.

       end method.

       end class HealthPolicy.