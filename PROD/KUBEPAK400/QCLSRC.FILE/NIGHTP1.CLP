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
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

/*  FINISH DAILY ORDER POST                                         */
             CALL       PGM(BIC550ACL)
  NOSAVE:

/*  GET REQ SHIP DATE TO MONDAY                        */
/*           CALL       PGM(GROWERS/FIXMON)            */

/*  GET SOW DATE AND ALPHA SEARCH                      */
             CALL       PGM(FXSOWD)

/*  REBUILD VALUE OF OPEN ORDERS IN MCUST              */
             CALL       PGM(RBVALOO)

/*  REBUILD VALUE OF OPEN A/R IN MCUST              */
             CALL       PGM(UPDCARBL)
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
/* TEMP COPY MINVT */
/*           CALL       PGM(CPYMINVT) */

/*   PURGE FGLPRE                                                    */
/*           CALL       PGM(PRGGLPRECL)                            */

/*   CALL NIGHTGL  IN EFDGL LIBRARY                                  */
         /*  CALL       PGM(EFDGL/NIGHTGL)  */
             CALL       PGM(EFDGL/NIGHTGL)

/*   CLEAR JOBLOG OUTQ                                               */
             CLROUTQ    OUTQ(QEZJOBLOG)
             ENDPGM
