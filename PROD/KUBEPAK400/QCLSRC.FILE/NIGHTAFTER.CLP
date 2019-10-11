             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHT     ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('NIGHTLY PROCESS')
             CALL       PGM(STSUPD)

/*   CALL NIGHTGL  IN EFDGL LIBRARY                                  */
         /*  CALL       PGM(EFDGL/NIGHTGL)  */
             CALL       PGM(NIGHTGL)

/*   CALL NIGHTAP  IN EFDAP LIBRARY                                  */
             CALL       PGM(EFDAP/NIGHTAP)

/*   CALL NIGHTAR  IN EFDAR LIBRARY                                  */
             CALL       PGM(EFDAR/NIGHTAR)

/*   CALL NIGHTBAR IN KUBEPAK400                                     */
             CALL       PGM(KUBEPAK400/NIGHTBAR)

/*   CALL GETNXCST IN KUBEPAK400 LIBRARY                             */
             CALL       PGM(KUBEPAK400/GETNXCSTCL)

/*   CALL CUR100CL IN KUBEPAK400 LIBRARY CALC ECKE REQUIREMENTS      */
             CALL       PGM(KUBEPAK400/CUR100CL)

/*   CALL GLC410ACL IN KUBEPAK400 LIBRARY PRINT DAILY JOURNAL    */
             CALL       PGM(KUBEPAK400/GLC410ACL)

/*   CALL SAC410ACL IN KUBEPAK400 LIBRARY P.C. SALES ANALYSIS    */
          /* CALL       PGM(KUBEPAK400/SAC410ACL)   -DNR-  B.S. 11/23/2015   */

/*   CALL CUC650CLA IN KUBEPAK400 LIBRARY 84 TRAY ORDER CHANGE   */
/* WJB -     CALL       PGM(CUC650CLA)   {REMOVED AT REQUEST OF BILL S.}    */

/*   CALL POI900 IN KUBEPAK400                                   */
             CALL       PGM(KUBEPAK400/PIR900)

/*   CALL NIGHTKUBE IN KUBEPAK400                                    */
             CALL       PGM(KUBEPAK400/NIGHTKUBE)

             ENDPGM
