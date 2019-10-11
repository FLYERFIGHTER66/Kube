/*********************************************************************/
/*   PROGRAM-------- BIC650CLJQ                                      */
/*   DATE WRITTEN--- 02/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHANGE ORDER DUE DATE                           */
/*   REVISIONS------                                                 */
/*  4/28/00 EFD ADD SUMMARY PICKSLIP PRINT                           */
/*  5/16/01 EFD ADD SUMMARY REPORT                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SUM) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&NBR) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(8)


             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)

             RTVJOBA    NBR(&NBR)
             CHGDTAARA  DTAARA(*LDA (200 2)) VALUE('WF')
             CHGDTAARA  DTAARA(*LDA (202 6)) VALUE(&NBR)
             RTVDTAARA  DTAARA(*LDA (200 8)) RTNVAR(&FILE)
             CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CRTPF      FILE(&FILE) SRCFILE(KUBEPAK400/QDDSSRC) +
                          SRCMBR(WBIR312) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO)
             ENDDO
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
             QSYS/OVRPRTF FILE(BIR312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY)
             CALL       PGM(QPK055)

             QSYS/OVRPRTF FILE(QPK312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
             CALL       PGM(QPK312)
             DLTF       FILE(&FILE)

 END:        ENDPGM
