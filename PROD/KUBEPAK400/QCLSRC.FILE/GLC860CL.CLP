/*********************************************************************/
/*   PROGRAM-------- GLC860CL                                        */
/*   DATE WRITTEN--- 08/04/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- UPDATE ACCTG PERIOD IN GLDET                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC860')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      Update +
                          G/L Dates ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLC860)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)

             QSYS/OVRPRTF FILE(GLR860) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY)

             CALL       PGM(GLR860)
 END:        ENDPGM
