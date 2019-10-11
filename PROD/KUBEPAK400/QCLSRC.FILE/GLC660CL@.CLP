/*********************************************************************/
/*   PROGRAM-------- GLC660CL                                        */
/*   DATE WRITTEN--- 01/22/00                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- YEAR END HARD CLOSE                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&CO) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&LIBR) TYPE(*CHAR) LEN(9)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC610')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Year End +
                          Preliminary Close ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&CO)
             CALL       PGM(GLRLSTY)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (10 9)) RTNVAR(&LIBR)

             RMVLIBLE   LIB(&LIBR)

             OVRDBF     FILE(FGLBALI) TOFILE(&LIBR/FGLBAL)
             CALL       PGM(GLR660)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/* UPDATE GLCTL */
             CALL       PGM(GLR669)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('GLC660CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&CO)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('G/L Hard Close')
             CALL       PGM(STSUPD)

 END:        ADDLIBLE   LIB(&LIBR)

             ENDPGM
