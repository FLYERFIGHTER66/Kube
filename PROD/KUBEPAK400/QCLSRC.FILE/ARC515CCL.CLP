/*********************************************************************/
/*   PROGRAM-------- ARC515CL                                        */
/*   DATE WRITTEN---  7/26/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- CUSTOMER BALANCE LISTING                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LCO &DATE &CUST &OPN &PRT)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LCO) TYPE(*DEC) LEN(2 0)
             QSYS/DCL   VAR(&DATE) TYPE(*DEC) LEN(7 0)
             QSYS/DCL   VAR(&CUST) TYPE(*DEC) LEN(6 0)
             QSYS/DCL   VAR(&OPN) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)

             DCL        VAR(&LINK) TYPE(*CHAR) LEN(75)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(75) VALUE('/kube +
                          pak/PDF/CUST_BAL_REPORT/BAL_')
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)

             IF         COND(&PRT *EQ '*PDF') THEN(GOTO CMDLBL(PDF))

 PRINT:      QSYS/OVRPRTF FILE(ARR515A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) DEVTYPE(*AFPDS) PAGESIZE(66 85) +
                          LPI(6) CPI(10) ALIGN(*NO) +
                          FRONTOVL(HEADER) FORMTYPE(*NAR)
             CALL       PGM(ARR515) PARM(&LCO &DATE &CUST &OPN)
             GOTO       CMDLBL(END)

 PDF:        RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&TIMESTAMP)
             CHGVAR     VAR(&LINK) VALUE(&PATH *TCAT &TIMESTAMP +
                          *TCAT '.pdf')
             QSYS/OVRPRTF FILE(ARR515A) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 85) LPI(6) +
                          CPI(10) FRONTMGN(.25 .25) ALIGN(*NO) +
                          FRONTOVL(HEADER) FORMTYPE(*NAR) +
                          TOSTMF(&LINK) WSCST(*PDF)
             CALL       PGM(ARR515) PARM(&LCO &DATE &CUST &OPN)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &LINK *TCAT +
                          '"') PAUSE(*NO)
             GOTO       CMDLBL(END)

END:         CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
