/*********************************************************************/
/*   PROGRAM-------- SAR240CL                                        */
/*   DATE WRITTEN--- 07/02/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SALES INQUIRY BY PRODUCT CLASS                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SAR240')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Sales By +
                          Product Class ')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR240)
 END:        ENDPGM
