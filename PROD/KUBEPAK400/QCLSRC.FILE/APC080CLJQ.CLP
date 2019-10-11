/*********************************************************************/
/*   PROGRAM-------- APC080CLJQ                                      */
/*   DATE WRITTEN--- 12/20/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- VENDOR LABLES                                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&ORD) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (4 1)) RTNVAR(&ORD)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(APR080) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(6 40) LPI(6) CPI(10) +
                          ALIGN(*YES) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             QSYS/OVRPRTF FILE(APR081) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(18 40) LPI(6) CPI(10) +
                          ALIGN(*YES) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             IF         COND(&ORD = '1') THEN(GOTO CMDLBL(VNO))
             IF         COND(&ORD = '2') THEN(GOTO CMDLBL(VZP))
             IF         COND(&ORD = '3') THEN(GOTO CMDLBL(VAL))

 VNO:        CALL       PGM(APR080)
                        GOTO END

 VZP:        CALL       PGM(APR081)
                        GOTO END

 VAL:        CALL       PGM(APR082)
                        GOTO END
 END:        ENDPGM
