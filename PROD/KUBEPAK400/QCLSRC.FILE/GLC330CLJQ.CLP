/*********************************************************************/
/*   PROGRAM-------- GLC330CLJQ                                      */
/*   DATE WRITTEN--- 05/04/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- JOURNAL ENTRY POST                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CALL       PGM(GLR330)
 END:        ENDPGM
