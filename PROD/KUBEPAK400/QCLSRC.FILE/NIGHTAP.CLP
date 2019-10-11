/*********************************************************************/
/*   PROGRAM-------- NIGHTAP                                         */
/*   DATE WRITTEN---  4/21/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR A/P APPLICATION           */
/*                   ONLY RUN AS PART OF NIGHT IN EFDSYS IF A/P INST.*/
/*   REVISIONS------                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*   PURGE A/P WORK FILE                                             */
             RGZPFM     FILE(FAPWK)
             MONMSG     MSGID(CPF2981)

/*   PURGE A/P WORKS FILES                                           */
             RGZPFM     FILE(FAPWKS)
             MONMSG     MSGID(CPF2981)

/*   PURGE A/P CHECK                                                 */
             RGZPFM     FILE(FAPCHK)
             MONMSG     MSGID(CPF2981)

/*   PURGE TOPAY FILE                                                */
             RGZPFM     FILE(FTOPAY)
             MONMSG     MSGID(CPF2981)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTAP   ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly A/P +
                          Process')
             CALL       PGM(STSUPD)

             ENDPGM
