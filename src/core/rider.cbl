       identification division.
       class-id. Rider.

       data division.
       working-storage section.
       01 rider-name pic x(50).
       01 rider-premium pic 9(9)v99.

       method-id. setRider.
       linkage section.
       01 r-name pic x(50).
       01 r-prem pic 9(9)v99.

       procedure division using r-name r-prem.

           move r-name to rider-name
           move r-prem to rider-premium

           goback.
       end method.

       method-id. getPremium.
       linkage section.
       01 result pic 9(9)v99.
       procedure division returning result.

           move rider-premium to result
           goback.

       end method.

       end class Rider.