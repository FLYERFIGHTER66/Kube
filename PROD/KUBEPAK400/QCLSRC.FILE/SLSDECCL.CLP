/*********************************************************************/
/*   PROGRAM-------- SLSDECCL                                        */
/*   DATE WRITTEN--- 09/17/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- OPEN ORDERS BY DESC SALES                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)


             CLRPFM     FILE(TGMSDATA/SLSDECFL)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SLSDEC')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  Customer +
                          Sales/Open Orders ')

             CALL       PGM(SAC999)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SLSDCC)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)


             QSYS/OVRPRTF FILE(SLSDEC) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*STD) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(SLSDEC)

 END:        ENDPGM
