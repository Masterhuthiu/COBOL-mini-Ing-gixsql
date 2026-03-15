       IDENTIFICATION DIVISION.
       PROGRAM-ID. HEALTHPOLICY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "../copy/policy.cpy".

       PROCEDURE DIVISION.

           IF POLICY-TYPE = "HEALTH"
               COMPUTE PREMIUM = 2000
           END-IF.

           GOBACK.