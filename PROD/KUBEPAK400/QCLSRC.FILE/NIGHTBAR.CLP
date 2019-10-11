/*********************************************************************/
/*   PROGRAM-------- NIGHTBAR                                        */
/*   DATE WRITTEN--- 12/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR BAR CODE FILES            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*   PURGE TRAY FILE                                              */
             RGZPFM     FILE(FTRAY)
             MONMSG     MSGID(CPF2981)

/*   PURGE SOWLINE FILE                                             */
             RGZPFM     FILE(FSOWSCH)
             MONMSG     MSGID(CPF2981)

/*   PURGE MISSED TRAY FILE                                        */
             RGZPFM     FILE(FBADTR)
             MONMSG     MSGID(CPF2981)

/*   PURGE ORDER PUT DOWN FILE                                      */
             RGZPFM     FILE(FPUTORD)
             MONMSG     MSGID(CPF2981)

/*   PURGE ORDER TRAY FILE                                          */
             RGZPFM     FILE(FTRORD)
             MONMSG     MSGID(CPF2981)

/*   PURGE ORDER TRAY ERROR FILE                                    */
             RGZPFM     FILE(FTRORE)
             MONMSG     MSGID(CPF2981)

/*   PURGE CART FILE                                                 */
             RGZPFM     FILE(FCART)
             MONMSG     MSGID(CPF2981)

/*   PURGE CART FILE FROM SCANNERS                                   */
             RGZPFM     FILE(FCARTS)
             MONMSG     MSGID(CPF2981)

/*   PURGE ORDER WORK FILE                                           */
             RGZPFM     FILE(FWKORD)
             MONMSG     MSGID(CPF2981)

/*   PURGE PUT DOWN CONTROL FILE                                     */
             RGZPFM     FILE(FPTORDC)
             MONMSG     MSGID(CPF2981)

/*   PURGE READY BAY TRAY FILE                                     */
             RGZPFM     FILE(FRBTRAY)
             MONMSG     MSGID(CPF2981)

/*   PURGE READY BAY ORDER FILE                                     */
             CALL       PGM(RBR750)
             RGZPFM     FILE(FRBORDR)
             MONMSG     MSGID(CPF2981)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTBAR  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly Bar +
                          Code Process')
             CALL       PGM(STSUPD)

             ENDPGM
