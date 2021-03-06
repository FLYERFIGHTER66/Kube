/*********************************************************************/
/*   PROGRAM-------- ORDER1CL                                        */
/*   DATE WRITTEN--- 03/01/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SCANNER INPUT FOR ORDER VERIFICATION SCAN 1     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&DET) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CALL       PGM(*LIBL/KUBEALLLBL) /* get library +
                          list */
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (256 1)) VALUE('B')

          /* LOAD DATES INTO LDA  */
             CALL       PGM(SCR020)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

          /* SCAN ORDERS  */
             CALL       PGM(SCR102)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')


             ENDPGM
