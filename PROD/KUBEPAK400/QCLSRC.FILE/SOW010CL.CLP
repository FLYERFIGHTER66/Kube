/*********************************************************************/
/*   PROGRAM-------- SOW010CL                                        */
/*   DATE WRITTEN--- 11/30/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SOW LINE OPERATIONS                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(SOW001) /* GET SOW LINE AND PARMS */
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             /* START PRINTERS */
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             IF         COND(&PRT = 'R1        ') THEN(DO)
             STRPRTWTR  DEV(R1) FORMTYPE(SOWLABEL) ALIGN(*FILE)
             MONMSG     MSGID(CPF3310) EXEC(CHGWTR WTR(R1) +
                          FORMTYPE(SOWLABEL))
             ENDDO
             IF         COND(&PRT = 'R2        ') THEN(DO)
             STRPRTWTR  DEV(R2) FORMTYPE(SOWLABEL) ALIGN(*FILE)
             MONMSG     MSGID(CPF3310) EXEC(CHGWTR WTR(R2) +
                          FORMTYPE(SOWLABEL))
             ENDDO

             CALL       PGM(SOW010) /* RUN THE SOW LINE */
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
