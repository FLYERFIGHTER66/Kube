/*********************************************************************/
/*   PROGRAM-------- BIR255CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY ORDER NUMBER                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PORDER)
             DCL        VAR(&PORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PORDER@) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PORDER@) VALUE(&PORDER)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (003 6)) VALUE(&PORDER@)
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR255')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Open Orders By +
                          Order Number ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR255)
 END:        ENDPGM
