/*********************************************************************/
/*   PROGRAM-------- ARR003CL                                        */
/*   DATE WRITTEN--- 07/16/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CREDIT CARD MASTER FILE MAINTENANCE             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR003')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Credit Card +
                          Master File  ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 NXT:        CALL       PGM(ARR003)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARC103CL)

             GOTO       CMDLBL(NXT)
 END:        ENDPGM
