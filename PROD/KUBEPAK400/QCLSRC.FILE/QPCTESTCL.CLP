/*********************************************************************/
/*   PROGRAM-------- QPCARLCCL                                       */
/*   DATE WRITTEN---  6/06/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CALCULATE LATE CHARGES DAILY                    */
/*                                                                   */
/*********************************************************************/
             PGM

             CLRPFM     FILE(TESTDATA/FMTRAN)
             CLRPFM     FILE(TESTDATA/FARLC)
             CLRPFM     FILE(TESTDATA/FARLCD)
             CLRPFM     FILE(TESTDATA/FAROPN)
             CPYF       FROMFILE(TESTDATA/FAROPN702) +
                          TOFILE(TESTDATA/FAROPN) MBROPT(*ADD)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('QPKARLCD  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('01')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Calculate Daily +
                          Late Charges')
             CALL       PGM(STSUPDTST)


 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
