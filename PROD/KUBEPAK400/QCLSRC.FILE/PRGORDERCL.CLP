/*********************************************************************/
/*   PROGRAM-------- PRGORDERCL                                      */
/*   DATE WRITTEN---  1/06/97                                        */
/*   PROGRAMMER----- GD                                              */
/*   DESCRIPTION---- PURGE DELETED/CLOSED RECORDS FROM FIORDR/FHORDR */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CALL       PGM(PRGIORDR)
             RTVDTAARA  DTAARA(*LDA (1 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             STRQMQRY   QMQRY(PRG_FIOROY)

             RGZPFM     FILE(FIORDR)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(FHORDR)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(FIOROY)
             MONMSG     MSGID(CPF2981)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('PRGORDERCL')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Remove Shipped +
                          Orders')
             CALL       PGM(STSUPD)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
