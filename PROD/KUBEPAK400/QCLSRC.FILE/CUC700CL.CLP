/*********************************************************************/
/*   PROGRAM-------- CUC700CL                                        */
/*   DATE WRITTEN--- 08/27/03                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CLEAR LAST SEASONS TOTALS                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&VENDOR) TYPE(*DEC) LEN(6)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&USER) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&LIBR) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             RTVJOBA    USER(&USER)
             IF         COND(&USER = 'BILL') THEN(GOTO CMDLBL(USOK))
             IF         COND(&USER = 'BILLB') THEN(GOTO CMDLBL(USOK))
             IF         COND(&USER = 'EFD') THEN(GOTO CMDLBL(USOK))
                        GOTO END

 USOK:
/*           CALL       PGM(CUR999) PARM(&VENDOR)                     +
             IF         COND(&VENDOR = 0) THEN(DO)                    +
             SNDPGMMSG  MSGID(CUT0001) MSGF(KPMSGF) MSGDTA(*NONE) +   +
                          TOPGMQ(*EXT)                                +
             GOTO       CMDLBL(END)                                   +
             ENDDO                                                   */

             CALL       PGM(CUC700)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(CUC701)
             QSYS/RTVDTAARA DTAARA(*LDA (5 10)) RTNVAR(&FILE)

/*  BUILD LAST YEAR FILE    */

 NOJ:
             RTVOBJD    OBJ(FCUTCTL) OBJTYPE(*FILE) RTNLIB(&LIBR)
/* WJB       CPYF       FROMFILE(TGMSDATA/FCUTLOT) +                 +
                          TOFILE(TGMSDATA/&FILE) MBROPT(*ADD) +      +
                          CRTFILE(*YES)                             */
             CPYF       FROMFILE(&LIBR/FCUTLOT) TOFILE(&LIBR/&FILE) +
                          MBROPT(*ADD) CRTFILE(*YES)
             CLRPFM     FILE(&LIBR/FCUTLOT)
                        GOTO END

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
