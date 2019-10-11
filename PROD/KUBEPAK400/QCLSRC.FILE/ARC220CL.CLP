/*********************************************************************/
/*   PROGRAM-------- ARC220CL                                        */
/*   DATE WRITTEN--- 03/26/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- BALANCE INQUIRY                                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR220')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      A/R +
                          Balance Inquiry ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)

             QSYS/OVRPRTF FILE(ARR220) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY)

             QSYS/OVRPRTF FILE(ARR22A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY)

 NXT:        CALL       PGM(ARR220)

             QSYS/RTVDTAARA DTAARA(*LDA (9 1)) RTNVAR(&HIST)
             IF         COND(&HIST = ' ') THEN(GOTO CMDLBL(END))
             CALL       PGM(ARR225)

             GOTO       CMDLBL(NXT)
 END:        ENDPGM
