/*********************************************************************/
/*   PROGRAM-------- BIC650CL                                        */
/*   DATE WRITTEN--- 02/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHANGE ORDER DUE DATE                           */
/*   REVISIONS------                                                 */
/*  4/28/00 EFD ADD SUMMARY PICKSLIP PRINT                           */
/*********************************************************************/
             PGM

             DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SUM) TYPE(*CHAR) LEN(1)

             RTVOBJD    OBJ(PGMLIB) OBJTYPE(*FILE) RTNLIB(&PGMLIB)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC650')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Order Due Date +
                          Modification ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&SEQ)

             QSYS/OVRPRTF FILE(BIR650) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY)

             CALL       PGM(BIR650)

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&SUM)
             IF         COND(&SUM = 'Y') THEN(GOTO CMDLBL(SUM))
             GOTO END

 SUM:  /*  DECIDE IF JOBQ OR NOT  */
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'Y') THEN(DO)
             SBMJOB     CMD(CALL PGM(&PGMLIB/BIC650CLJQ))
             GOTO END
             ENDDO

             CALL       PGM(BIC650CLJQ)

 END:        ENDPGM
