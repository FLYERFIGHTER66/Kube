/*********************************************************************/
/*   PROGRAM-------- PIC315CLJQ                                      */
/*   DATE WRITTEN--- 06/27/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT POINSETTIA AVAILABILITY.   BATCH          */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&OPT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

 NOUPD:      QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&PRT = 'P7        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q4        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q5        ') THEN(GOTO CMDLBL(P7))

             QSYS/OVRPRTF FILE(PIR315) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 P7:         QSYS/OVRPRTF FILE(PIR315) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(12) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 PRT:        CALL       PGM(PIR315)

             ENDPGM
