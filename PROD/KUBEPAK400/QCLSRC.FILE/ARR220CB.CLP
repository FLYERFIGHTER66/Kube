/*********************************************************************/
/*   PROGRAM-------- ARR220CL                                        */
/*   DATE WRITTEN--- 11/26/98                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R COLLECTION COMMENT INQUIRY                  */
/*   REVISIONS------ USED TO RUN SINGLE CUSTOMER INQUIRY - MJT       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CUST)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR220')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      A/R +
                          Comment Inquiry')
             CHGDTAARA  DTAARA(*LDA (250 6)) VALUE(&CUST)
             CHGDTAARA  DTAARA(*LDA (256 1)) VALUE('B')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             OVRPRTF    FILE(ARR22A) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             OVRPRTF    FILE(ARR220) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)

 NXT:        CALL       PGM(ARR220)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (9 1)) RTNVAR(&HIST)
             IF         COND(&HIST = ' ') THEN(GOTO CMDLBL(END))
             CALL       PGM(ARR226)
             GOTO       CMDLBL(NXT)

 END:        ENDPGM
