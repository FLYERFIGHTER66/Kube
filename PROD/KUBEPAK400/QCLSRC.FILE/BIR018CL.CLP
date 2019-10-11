/*********************************************************************/
/*   PROGRAM-------- BIR018CL                                        */
/*   DATE WRITTEN--- 06/22/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- FREIGHT ZONE MAINTENANCE                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR018')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Freight Zone +
                          Maintenance ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR018)
END:         ENDPGM
