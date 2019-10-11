/*********************************************************************/
/*   PROGRAM-------- BIC550CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY BILLING POST                              */
/*   REVISIONS------                                                 */
/*  4/13/00 EFD SPLIT INTO TWO FOR NIGHT TO RUN 2ND HALF             */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SLS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COMP) TYPE(*CHAR) LEN(2)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC550')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Daily +
                          Billing Post    ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *NE '0') THEN(DO) /*  IF BATCH THEN  */
             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE('P9        ') /* PRINTER */
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE('*NAR      ') /* FORM    */
             CHGDTAARA  DTAARA(*LDA (120 02)) VALUE('01')         /* COPIES  */
             CHGDTAARA  DTAARA(*LDA (123 04)) VALUE('*NO ')       /* HOLD    */
             CHGDTAARA  DTAARA(*LDA (127 04)) VALUE('*NO ')       /* SAVE    */
             ENDDO
             IF         COND(&TYPE *NE '0') THEN(DO) /*  IF NOT BATCH THEN  */

             CALL       PGM(BIC550)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
             ENDDO

             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&COMP)

/* PROCESS DAILY INVOICE REGISTER                                    */
             CALL       PGM(BIR340CL)

/* POST TO A/R                                                       */
             CALL       PGM(BIR430CL)

/* PROCESS DAILY SALES REGISTER IF WANTED                            */
             RTVDTAARA  DTAARA(*LDA (4 1)) RTNVAR(&SLS)
             IF         COND(&EOJ *EQ 'N') THEN(GOTO CMDLBL(NOSLS))
             CALL       PGM(BIR350CL)

/* PROCESS DAILY CASH REGISTER                                       */
 NOSLS:      RTVDTAARA  DTAARA(*LDA (172 7)) RTNVAR(&DAT)
             CHGDTAARA  DTAARA(*LDA (3 9)) VALUE(&DAT)
             CHGDTAARA  DTAARA(*LDA (10 10)) VALUE('          ')
             CALL       PGM(ARC350CLJQ)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('BIC550CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&COMP)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Daily Billing +
                          Post')
             CALL       PGM(STSUPD)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
