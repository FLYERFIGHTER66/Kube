/*********************************************************************/
/*     IF YOU MAKE ANY CHANGES HERE MAKE THEM TO NIGHT ALSO          */
/*********************************************************************/
/*                                                                   */
/*********************************************************************/
/*   PROGRAM-------- NIGHTS                                          */
/*   DATE WRITTEN---  1/06/95                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE                               */
/*   REVISIONS------                                                 */
/*  4/25/95 EFD CHANGE TO RUN IN QCTL AND STOP QBATCH.               */
/*  5/25/99 EFD COPY OF NIGHT WITHOUT TSAVE                          */
/*  5/17/01 EFD ADD NEW OPEN ORDER CALC                              */
/* 10/26/01 EFD ADD ECKE REQUIREMENTS CALC.                          */
/* 11/15/01 EFD ADD 84 TRAY ORDER ENTRY CHANGE LIST                  */
/*  4/23/02 EFD ADD G/L JOURNAL AND S/A BY P.C. AUTO PRINT.          */
/*? 5/09/05 WJB ADD CALL TO BIC550CL                                 */
/*? 5/11/05 WJB DLT CALL TO BIC550CL                                 */
/*?11/04/14 WJB DLT CALL TO CUC650CLA                                */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

/*  RERUN FIRST PART OF DAILY ORDER POST (JUST IN CASE)             */
/*           CALL       PGM(BIC550CL)                               */
/*  FINISH DAILY ORDER POST                                         */
             CALL       PGM(BIC550ACL)

/*  PRINT ORDER OVER RIDE REPORT                                    */
/*           CALL       PGM(BIR101CL)                  */
/*  GET REQ SHIP DATE TO MONDAY                        */
/*           CALL       PGM(GROWERS/FIXMON)            */

/*  GET SOW DATE AND ALPHA SEARCH                      */
             CALL       PGM(FXSOWD)

/*  REBUILD VALUE OF OPEN ORDERS IN MCUST              */
/*           CALL       PGM(GROWERS/RBVALOO)           */
             CALL       PGM(GETTORDACL)

/*  REBUILD VALUE OF OPEN A/R IN MCUST              */
             CALL       PGM(UPDCARBL)
/*  RECALC ALLOCATIONS                                 */
             CALL       PGM(BIR900)
        /*   CALL       PGM(CALCALOCL)   */

 /*     RECALC LKITM FILE AFTER PROCESSING     */
             CALL       PGM(BLDLKITMCL)

/*   CALL CUR100CL IN KUBEPAK400 LIBRARY CALC ECKE REQUIREMENTS      */
             CALL       PGM(KUBEPAK400/CUR100CL)

/*   CALL GLC401ACL IN KUBEPAK400 LIBRARY PRINT DAILY JOURNAL    */
             CALL       PGM(KUBEPAK400/GLC410ACL)

/*   CALL SAC410ACL IN KUBEPAK400 LIBRARY P.C. SALES ANALYSIS    */
          /* CALL       PGM(KUBEPAK400/SAC410ACL)   -DNR-  B.S. 11/23/2015   */

/*   CALL CUC650CLA IN KUBEPAK400 LIBRARY 84 TRAY ORDER CHANGE   */
/*  WJB -    CALL       PGM(CUC650CLA)   {REMOVED AT REQUEST OF BILL S.}    */

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTS    ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Night Process +
                          for Saturday')
             CALL       PGM(STSUPD)

/*   CALL NIGHTGL  IN EFDGL LIBRARY                                  */
         /*  CALL       PGM(EFDGL/NIGHTGL)  */
             CALL       PGM(NIGHTGL)

             ENDPGM
