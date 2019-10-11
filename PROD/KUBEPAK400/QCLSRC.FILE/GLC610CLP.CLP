/*********************************************************************/
/*   PROGRAM-------- GLC610CL                                        */
/*   DATE WRITTEN--- 08/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- YEAR END PRELIMINARY CLOSE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&CO) TYPE(*CHAR) LEN(2)

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(9) /* LIBR NAME */

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC610')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Year End +
                          Preliminary Close ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&CO)

             CALL       PGM(GLC610)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /*   BUILD LAST YEAR FILES   */
             RTVDTAARA  DTAARA(*LDA (88 9)) RTNVAR(&LIBR)


 /*  UPDATE GLCTL AND GLCLOS  BASE SYSTEM      */

             CALL       PGM(GLR619)

 /*  UPDATE GLCTL AND GLCLOS  NEWSYSTEM        */

             OVRDBF     FILE(FGLCTL) TOFILE(&LIBR/FGLCTL)
             CALL       PGM(GLR619A)

 /*  REORGANIZE FILES        */

             RGZPFM     FILE(FGLDET)
             RGZPFM     FILE(FGLDCON)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('GLC610CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&CO)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('G/L Soft Close')
             CALL       PGM(STSUPD)

 END:        ENDPGM
