/*********************************************************************/
/*   PROGRAM-------- RBC101CL                                        */
/*   DATE WRITTEN--- 04/08/05                                        */
/*   PROGRAMMER----- WILLIAM J. BEHR                                 */
/*   DESCRIPTION---- SCAN CARTS INTO READY BAY                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&TPY) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&DET) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

          /* TELL SCR020 WHAT TYPE REPORT R=READY BAY O=ORDER ETC*/
          /* TO ASSIGN CORRECT PRINTER */
             CHGDTAARA  DTAARA(*LDA (256 1)) VALUE('O')

          /* LOAD DATES INTO LDA  */
             CALL       PGM(SCR020)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
/* TEMP OVER RIDE LOT FILES */
/*           OVRDBF     FILE(FDLOTRD) TOFILE(TGMSDATA/FDLOTRDT)  */
/*           OVRDBF     FILE(FDLOT) TOFILE(TGMSDATA/FDLOTT)      */
/*           OVRDBF     FILE(FLCSTAT) TOFILE(TGMSDATA/FLCSTATT)  */

             CALL       PGM(RBR101)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
