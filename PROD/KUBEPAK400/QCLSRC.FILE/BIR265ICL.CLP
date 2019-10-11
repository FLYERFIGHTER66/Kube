/*********************************************************************/
/*   PROGRAM-------- BIR265CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY ITEM                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ITEM &SIZE &DATE &TYPE)

             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(03)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR265')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Open +
                          Orders By Item ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (501 12)) VALUE(&ITEM)
             CHGDTAARA  DTAARA(*LDA (513  3)) VALUE(&SIZE)
             CHGDTAARA  DTAARA(*LDA (516  6)) VALUE(&DATE)
             CHGDTAARA  DTAARA(*LDA (522  1)) VALUE(&TYPE)

             CALL       PGM(BIR265)
 END:        ENDPGM
