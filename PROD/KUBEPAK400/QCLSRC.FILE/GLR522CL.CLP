/*********************************************************************/
/*   PROGRAM-------- GLR522CL                                        */
/*   DATE WRITTEN--- 03/19/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INCOME STATEMENT                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&OPT) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (25 1)) RTNVAR(&OPT)
             IF         COND(&OPT *EQ '6') THEN(GOTO CMDLBL(OPT6))


 OPT6:       QSYS/OVRPRTF FILE(GLR522) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(66 198) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(GLR522)
             GOTO END

 END:        ENDPGM
