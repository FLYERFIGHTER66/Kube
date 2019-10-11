/*********************************************************************/
/*   PROGRAM-------- BIR460CL                                        */
/*   DATE WRITTEN--- 10/22/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT CREDIT MEMOS                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CALL       PGM(BIC460)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (11 1)) RTNVAR(&REP)
             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(REP))
             STRS36PRC  PRC(BIP450)
             MONMSG     MSGID(CPA0701 SSP0010)
 REP:        STRS36PRC  PRC(BIP460)
             MONMSG     MSGID(CPA0701 SSP0010)
 END:        ENDPGM
