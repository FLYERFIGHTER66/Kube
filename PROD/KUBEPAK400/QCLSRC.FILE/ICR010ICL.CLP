/*********************************************************************/
/*   PROGRAM-------- ICR010CL                                        */
/*   DATE WRITTEN--- 09/22/98                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ITEM MASTER MAINTENANCE                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ITEM &SIZE &MODE)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN( 3)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN( 1)

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (501 12)) VALUE(&ITEM)
             CHGDTAARA  DTAARA(*LDA (513  3)) VALUE(&SIZE)
             CHGDTAARA  DTAARA(*LDA (516  1)) VALUE(&MODE)

NXT:         CALL       PGM(ICR010)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))


             CALL       PGM(ICC110CL)

             GOTO       CMDLBL(NXT)
END:         ENDPGM
