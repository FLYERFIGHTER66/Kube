/*********************************************************************/
/*   PROGRAM-------- CURFIXCL                                        */
/*   DATE WRITTEN--- 09/17/03                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- BUILD SEQUENCE FILE                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)




             CLRPFM     FILE(FCUTSEQ)

             CALL       PGM(CURFIXMIN)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
