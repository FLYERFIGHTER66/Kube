/*********************************************************************/
/*   PROGRAM-------- BIR337CL                                        */
/*   DATE WRITTEN--- 12/14/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- INVOICE INQUIRY BY INVOICE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
AGN:         CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CALL       PGM(BIR337)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&REP)
             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(REP))
             ELSE       GOTO (END)
 REP:        QSYS/RTVDTAARA DTAARA(*LDA (31 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*INV)
             CALL       PGM(BIR330)
             GOTO AGN
 END:        ENDPGM
