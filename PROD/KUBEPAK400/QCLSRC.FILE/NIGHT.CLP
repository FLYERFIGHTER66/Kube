/*********************************************************************/
/*     IF YOU MAKE ANY CHANGES HERE MAKE THEM TO NIGHTS ALSO         */
/*********************************************************************/
/*                                                                   */
/*********************************************************************/
/*   PROGRAM-------- NIGHT                                           */
/*   DATE WRITTEN---  1/06/95                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE                               */
/*   REVISIONS------                                                 */
/*  4/25/95 EFD CHANGE TO RUN IN QCTL AND STOP QBATCH.               */
/*  7/23/99 EFD ADD GLPRE PURGECL                                    */
/*  3/07/01 EFD MOVE TSAVE TO END                                    */
/*  5/17/01 EFD ADD NEW OPEN ORDER CALC                              */
/* 10/26/01 EFD ADD ECKE REQUIREMENTS CALC.                          */
/* 11/15/01 EFD ADD 84 TRAY ORDER ENTRY CHANGE LIST                  */
/* 12/07/01 EFD ADD BAR CODE NIGHT PROCESS                           */
/*  2/21/02 EFD ADD NIGHTKUBE TO PROCESS                             */
/*  3/23/02 EFD MOVE NIGHTKUBE TO END BECAUSE OF HALTS               */
/*  5/10/02 EFD ADD POINSETTIA ALLOCATION PROGRAM                    */
/*? 4/26/04 WJB ADD CALL TO PRG010 TO CLEAR OUT FIORDRWK             */
/*? 2/08/05 WJB CHANGED TSAVE TO TSAVE_ALL                           */
/*? 5/09/05 WJB ADD CALL TO BIC550CL                                 */
/*? 5/11/05 WJB REMOVE CALL TO BIC550CL                              */
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEALLLBL)

/* Stop Subsystems to ensure all jobs are ended  */
             ENDSBS     SBS(QINTER) OPTION(*IMMED)
             ENDSBS     SBS(QBATCH) OPTION(*IMMED)
             DLYJOB     DLY(300) /* Give subsystems time to end */

/* FINISH DAILY ORDER POST */
             CALL       PGM(BIC550ACL)

/* Now restart the Subsystems */
             STRSBS     SBSD(QINTER)
             MONMSG     MSGID(CPF1010)
             SBMJOB     CMD(STRSBS SBSD(QBATCH)) JOB(STR_QBATCH) +
                          JOBD(KUBEPAK) JOBQ(QINTER) USER(NIGHT) +
                          SCDTIME(221000)
             STRSBS     SBSD(QBATCH)
             MONMSG     MSGID(CPF1010)
             STRTCP
             MONMSG     MSGID(CPF0000)

/*?WJB - Call PRG010 to clear entries from FIORDRWK more than two days old ?*/
             CALL       PGM(PRG010)
             MONMSG     MSGID(CPF0000)
/* GET SOW DATE AND ALPHA SEARCH */
             CALL       PGM(FXSOWD)
/* REBUILD VALUE OF OPEN A/R IN MCUST */
             CALL       PGM(UPDCARBL)
/* RECALC ALLOCATIONS */
             CALL       PGM(BIR900)
          /* CALL       PGM(CALCALOCL)  */
/* RECALC LKITM FILE AFTER PROCESSING */
             CALL       PGM(BLDLKITMCL)
/* REBUILD VALUE OF OPEN ORDERS IN MCUST */
             CALL       PGM(GETTORDACL)
/* CALCULATE YTD BUCKETS IN FSHIST AND FSHISTS */
             CALL       PGM(SAR900)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHT     ')
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('NIGHTLY PROCESS')
             CALL       PGM(STSUPD)

             CALL       PGM(NIGHTGL)
             CALL       PGM(NIGHTAP)
             CALL       PGM(NIGHTAR)
             CALL       PGM(NIGHTBAR)
             CALL       PGM(GETNXCSTCL)
             CALL       PGM(CUR100CL)
/* PRINT DAILY JOURNAL */
/*           CALL       PGM(GLC410ACL)   */  WRKJOBSCDE GLC410
/* P.C. SALES ANALYSIS */
         /*  CALL       PGM(SAC410ACL)   -DNR-  B.S. 11/23/2015   */
/* 84 TRAY ORDER CHANGE */
/*  WJB -    CALL       PGM(CUC650CLA)   {REMOVED AT REQUEST OF BILL S.}    */
             CALL       PGM(PIR900)
/* SET UP EFD COMM LINES */
             CALL       PGM(NIGHTKUBE)
/* BACK UP THE KUBE-PAK LIBRARIES and IFS  */
             CALL       PGM(TSAVE_ALL)
             ENDPGM
