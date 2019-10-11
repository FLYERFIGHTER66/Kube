/*********************************************************************/
/*   PROGRAM-------- APR220CL                                        */
/*   DATE WRITTEN--- 06/27/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PAYMENT SELECTION                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&AUTO) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR220')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Payment +
                          Selection   ')
             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(APR220)
/* CHECK IF ANY AUTO SELECT RUN */
             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&AUTO)
             IF         COND(&AUTO = ' ') THEN(GOTO CMDLBL(END))
             CALL       PGM(APR221)
 END:        ENDPGM
