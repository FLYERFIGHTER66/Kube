/*********************************************************************/
/*   PROGRAM-------- ARC550CL                                        */
/*   DATE WRITTEN--- 03/19/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- TRANSFER TO GENERAL LEDGER                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC550')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  Transfer to +
                          General Ledger  ')

             CALL       PGM(ARC999)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/* POST AROPN  */
             CALL       PGM(ARR550)

/* G/L CONSOLIDATION */
             CALL       PGM(GLR870CL)

 END:  /*    CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')   */

             ENDPGM
