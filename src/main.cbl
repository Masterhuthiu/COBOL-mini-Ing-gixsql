       identification division.
       program-id. main.

       data division.
       working-storage section.

       01 life object reference LifePolicy.
       01 rider1 object reference Rider.

       01 total pic 9(9)v99.

       procedure division.

           invoke LifePolicy "new" returning life
           invoke life "setPolicy" using "LIFE001" 1000

           invoke Rider "new" returning rider1
           invoke rider1 "setRider" using "Accident" 200

           invoke life "calcPremium" returning total

           display "Life Premium = " total

           stop run.