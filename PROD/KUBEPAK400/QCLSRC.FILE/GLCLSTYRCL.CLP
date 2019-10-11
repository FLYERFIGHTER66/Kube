/*********************************************************************/
/*   PROGRAM-------- GLCLSTYRCL                                      */
/*   DATE WRITTEN--- 01/15/00                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- GOTO LAST YEAR FILES                            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LIBR) TYPE(*CHAR) LEN(9)
             QSYS/DCL   VAR(&LIBRC) TYPE(*CHAR) LEN(10)

             RTVJOBA    CURLIB(&LIBRC)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLCLST')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   G/L Year End +
                          Processing  ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLRLSTY)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (10 9)) RTNVAR(&LIBR)
             ADDLIBLE   LIB(&LIBR)
             CHGCURLIB  CURLIB(&LIBR)

             GO         MENU(GLM090)

             CHGCURLIB  CURLIB(&LIBRC)
             RMVLIBLE   LIB(&LIBR)

 END:        ENDPGM
