       identification division.
       program-id. DBPolicy.

       data division.
       working-storage section.

       exec sql include sqlca end-exec.

       01 policy-number pic x(50).
       01 premium pic 9(9)v99.

       procedure division.

           exec sql
              insert into policies(policy_number, policy_type, premium)
              values (:policy-number, 'LIFE', :premium)
           end-exec

           goback.