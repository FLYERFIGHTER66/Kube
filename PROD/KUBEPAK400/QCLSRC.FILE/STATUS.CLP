/*   PROGRAM NAME...  STATUS                                       */
/*   DESCRIPTION....  SAMPLE OF CL FOR PROGRAM STATUS UPDATE       */
/*   DATE...........   4/21/99                                     */
/*   PROGRAMMER.....  EFD                                          */

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHT     ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly Process')
             CALL       PGM(STSUPD)
