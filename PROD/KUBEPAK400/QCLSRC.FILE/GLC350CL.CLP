/*********************************************************************/
/*   PROGRAM-------- GLC350CL                                        */
/*   DATE WRITTEN--- 02/26/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- POST TO G/L BALANCE FILE                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&ISBATCH) TYPE(*LGL) VALUE('0')
             DCL        VAR(&CONO   ) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&ACTPER ) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&BEGDAT ) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ENDDAT ) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&BGCYMD ) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&ENCYMD ) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&TRNDAT ) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ERR    ) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&TRNDAT@) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ACTPER@) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC350')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Post General +
                          Ledger Balances')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(#ISBATCH) PARM(&ISBATCH)
             IF         COND(&ISBATCH) THEN(DO)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&TRNDAT@)
             CHGVAR     VAR(&TRNDAT) VALUE(&TRNDAT@)
             CALL       PGM(GETAPER) PARM(&CONO &ACTPER &BEGDAT +
                          &ENDDAT &BGCYMD &ENCYMD &TRNDAT &ERR)
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('B')
             IF         COND(&ACTPER *EQ 99) THEN(CHGVAR VAR(&ACTPER) +
                          VALUE(12))
             CHGVAR     VAR(&ACTPER@) VALUE(&ACTPER)
             CHGDTAARA  DTAARA(*LDA (  3 2)) VALUE(&ACTPER@)
             ENDDO

             CALL       PGM(GLC350)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/GLC350CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(GLC350CLJQ)
 END:        ENDPGM
