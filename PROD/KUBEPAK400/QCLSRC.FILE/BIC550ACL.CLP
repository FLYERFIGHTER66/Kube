/*********************************************************************/
/*   PROGRAM-------- BIC550CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY BILLING POST                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SLS) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COMP) TYPE(*CHAR) LEN(2)

             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC550')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Daily +
                          Billing Post    ')

             CALL       PGM(DEF998A)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC550A)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&COMP)

/* POST TO SALES HISTORY                                             */
             CALL       PGM(BIR360CL)

/* POST TO INVENTORY AND COST OF GOODS SOLD                          */
             CALL       PGM(SAR300)

/* POST AR TRANSACTIONS                                              */
             CALL       PGM(ARR550)

/* POST INVENTORY TRANSACTIONS                                       */
             CALL       PGM(ICR510)

/* POST TO GL DETAIL FILE                                            */
             CALL       PGM(GLR870CL)

/* PURGE DSALE                                                       */
             CLRPFM     FILE(&DATALIB/FDSALE)

/* REBUILD TOTAL BUCKETS IN SHIST AND SHISTS                         */
             CALL       PGM(SAR900)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('BIC550ACL ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&COMP)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Daily Billing +
                          Post Night Part')
             CALL       PGM(STSUPD)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
