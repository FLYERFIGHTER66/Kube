/*********************************************************************/
/*   PROGRAM-------- ICC620CL                                        */
/*   DATE WRITTEN--- 11/26/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- POST PHYSICAL TO BOOK                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICC620')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Post +
                          Physical to Book ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ICC620)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ICR620)

                        GOTO END
 END:        ENDPGM
