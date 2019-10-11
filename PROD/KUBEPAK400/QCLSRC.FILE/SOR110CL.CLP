/*********************************************************************/
/*   PROGRAM-------- SOR110CL                                        */
/*   DATE WRITTEN--- 11/21/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- S/O HISTORY ITEM INQUIRY                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SOR110')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   S/O History +
                          Item Inquiry')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SOR110)
 END:        ENDPGM
