/*********************************************************************/
/*   PROGRAM-------- SDR360C                                         */
/*   DATE WRITTEN--- 08/18/03                                        */
/*   DESCRIPTION---- COST/PRICE REPORT within dates                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&FDAT) TYPE(*CHAR) LEN(8) VALUE('00000000')
             QSYS/DCL   VAR(&TDAT) TYPE(*CHAR) LEN(8) VALUE('00000000')
             QSYS/DCL   VAR(&SORT) TYPE(*CHAR) LEN(1) VALUE('S')

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
 RESTART:
             CALL       PGM(SDC360R) PARM(&FDAT &TDAT &SORT)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/SDR360JQ) PARM(&FDAT &TDAT &SORT))
                        GOTO END

 NOJ:        CALL       PGM(SDR360JQ) PARM(&FDAT &TDAT &SORT)

             GOTO       CMDLBL(RESTART)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
