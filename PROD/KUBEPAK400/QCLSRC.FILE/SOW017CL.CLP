/*********************************************************************/
/*   PROGRAM-------- SOW017CL                                        */
/*   DATE WRITTEN--- 12/07/2009                                      */
/*   PROGRAMMER----- W. J. BEHR                                      */
/*   DESCRIPTION---- RECEIVE CUTTINGS                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FORM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (  1 01)) VALUE('5')           /* SOWLIN */
             CHGDTAARA  DTAARA(*LDA ( 11 10)) VALUE('FSOWLAB3  ')  /* LFILE  */
             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE('P4        ')  /* LPRTR  */
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE('NEWSOW    ')  /* LFORM  */
             CHGDTAARA  DTAARA(*LDA (120 02)) VALUE('01')          /* LCOPY  */
             CHGDTAARA  DTAARA(*LDA (122 01)) VALUE('N')           /* LJOBQ  */
             CHGDTAARA  DTAARA(*LDA (123 04)) VALUE('*NO ')        /* LHOLD  */
             CHGDTAARA  DTAARA(*LDA (127 04)) VALUE('*NO ')        /* LSAVE  */
             CHGDTAARA  DTAARA(*LDA (133 01)) VALUE(' ')           /* LCANCL */
             CHGDTAARA  DTAARA(*LDA (134 10)) VALUE('P4        ')  /* RPRTR  */

             /* START PRINTERS */
             RTVDTAARA  DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             RTVDTAARA  DTAARA(*LDA (110 10)) RTNVAR(&FORM)

             CALL       PGM(SOW017) /* RUN THE SOW LINE */
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
