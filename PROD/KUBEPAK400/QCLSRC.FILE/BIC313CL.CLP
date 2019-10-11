/*********************************************************************/
/*   PROGRAM-------- BIC310CL                                        */
/*   DATE WRITTEN--- 01/17/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PICK SLIPS                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*   1/6/03  CHANGED OVERFLOW TO BIR313X & 313    C.BUCK             */
/*           AND CHANGED CPI TO 10 FROM 15.                          */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&NXT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEL) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&PRT2) TYPE(*CHAR) LEN(10)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
 NXT:        CALL       PGM(BIC310)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (134 1)) RTNVAR(&NXT)
             QSYS/RTVDTAARA DTAARA(*LDA (49 1)) RTNVAR(&SEL)
             QSYS/RTVDTAARA DTAARA(*LDA (17 8)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (27 8)) RTNVAR(&PRT2)
             IF         COND(&SEL = '5') THEN(GOTO CMDLBL(ITEM))
             IF         COND(&SEL = '2') THEN(GOTO CMDLBL(SVIA))
             QSYS/OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR)

             IF         COND(&PRT2 > '       ') THEN(DO)
             QSYS/OVRPRTF FILE(BIR310X) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR)
                          ENDDO
             CALL       PGM(BIR310)
             IF         COND(&NXT = 'N') THEN(GOTO CMDLBL(NXT))
                        GOTO END
 ITEM:       QSYS/OVRPRTF FILE(BIR312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR312)
                        GOTO END
 SVIA:       QSYS/OVRPRTF FILE(BIR313) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             QSYS/OVRPRTF FILE(BIR313X) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR313)
 END:        ENDPGM
