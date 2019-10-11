/*********************************************************************/
/*   PROGRAM-------- NIGHTGL                                         */
/*   DATE WRITTEN---  5/07/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR G/L APPLICATION           */
/*                   ONLY RUN AS PART OF NIGHT IN EFDSYS IF G/L INST.*/
/*   REVISIONS------                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*   PURGE G/L PRE FILE                                              */
             RGZPFM     FILE(FGLPRE)
             MONMSG     MSGID(CPF2981)

/*   PURGE G/L WORK FILE                                             */
             RGZPFM     FILE(FGLWRK)
             MONMSG     MSGID(CPF2981)

/*   PURGE G/L REVERSING ENTRY FILE                                  */
             RGZPFM     FILE(FGLREV)
             MONMSG     MSGID(CPF2981)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTGL   ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly G/L +
                          Process')
             CALL       PGM(STSUPD)

             ENDPGM
