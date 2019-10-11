        /****************************************************************/
       /*?  PROGRAM-------- LATECHGCL (Calls LATECHARGE)               */
      /*?   DATE WRITTEN--- 07/07/2004                                */
     /*?    PROGRAMMER----- William J. Behr                          */
    /*?     DESCRIPTION---- CALCULATE LATE CHARGES (RUN DAILY)      */
   /****************************************************************/
             PGM
             DCL        VAR(&JOBDATE) TYPE(*CHAR) LEN(6)

             RTVJOBA    DATE(&JOBDATE)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 6)) VALUE(&JOBDATE)

        /*?  Process Late Fees   */
          /* CALL       PGM(LATECHARGE)*/
             CALL       PGM(LATCRGNEW) PARM('01/01/1900' '*ALL' '*ALL')
        /*?  Post Late Fees from FARLC to FAROPN   */
             CALL       PGM(QPKLCUPT)

        /*?  End of Job Precess  */
 EOJ:
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
