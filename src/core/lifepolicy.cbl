       identification division.
       class-id. LifePolicy inherits StandardPolicy.

       data division.
       working-storage section.
       01 life-factor pic 9v99 value 1.20.

       method-id. calcPremium.
       linkage section.
       01 result pic 9(9)v99.

       procedure division returning result.

           invoke self "getPremium" returning result
           compute result = result * life-factor

           goback.

       end method.

       end class LifePolicy.