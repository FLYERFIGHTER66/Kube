/*********************************************************************/
/*   PROGRAM-------- @KUBEPRTCL                                      */
/*   DATE WRITTEN--- 07/12/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SPECS FOR KUBE PAK PRINTERS                     */
/*                                                                   */
/*********************************************************************/

             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

          /* DETERMINE IF PRINTER NEEDS SPECIAL SPECS */
             IF         COND(&PRT = 'P7        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P9        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q4        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q5        ') THEN(GOTO CMDLBL(P7))
/*           IF         COND(&PRT = 'Q8        ') THEN(GOTO CMDLBL(P7))   */
             IF         COND(&PRT = 'R3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P8        ') THEN(GOTO CMDLBL(P7))

          /* NORMAL SPECS FOR 15 CHAR TO THE INCH */
             QSYS/OVRPRTF FILE(PIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

          /* SPECIAL SPECS FOR 12 CHAR TO THE INCH */
 P7:         QSYS/OVRPRTF FILE(PIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(12) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 PRT:     /* PROGRAM CALL HERE*/

