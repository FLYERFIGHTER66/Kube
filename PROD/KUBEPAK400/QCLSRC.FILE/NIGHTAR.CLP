/*********************************************************************/
/*   PROGRAM-------- NIGHTAR                                         */
/*   DATE WRITTEN--- 10/15/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR A/R APPLICATION           */
/*                   ONLY RUN AS PART OF NIGHT IN EFDSYS IF A/R INST.*/
/*   REVISIONS------                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*   PURGE A/R OPEN FILE                                             */
             RGZPFM     FILE(FAROPN)
             MONMSG     MSGID(CPF2981)

/*   PURGE A/P ENTRY FILES                                           */
             RGZPFM     FILE(FARENT)
             MONMSG     MSGID(CPF2981)

/*   PURGE ARSEL                                                     */
             RGZPFM     FILE(FARSEL)
             MONMSG     MSGID(CPF2981)

/*   PURGE AR210 FILE                                                */
             RGZPFM     FILE(FAR210)
             MONMSG     MSGID(CPF2981)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTAR   ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly A/R +
                          Process')
             CALL       PGM(STSUPD)

             ENDPGM
