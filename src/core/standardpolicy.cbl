       identification division.
       class-id. StandardPolicy.

       data division.
       working-storage section.
       01 policy-number pic x(50).
       01 premium       pic 9(9)v99.

       method-id. setPolicy.
       linkage section.
       01 p-number pic x(50).
       01 p-premium pic 9(9)v99.
       procedure division using p-number p-premium.

           move p-number to policy-number
           move p-premium to premium

           goback.
       end method.

       method-id. getPremium.
       linkage section.
       01 out-premium pic 9(9)v99.
       procedure division returning out-premium.

           move premium to out-premium
           goback.

       end method.

       end class StandardPolicy.