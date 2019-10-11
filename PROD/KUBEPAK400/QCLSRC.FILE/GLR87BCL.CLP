/*********************************************************************/
/*   PROGRAM-------- GLR87BCL                                        */
/*   DATE WRITTEN--- 07/15/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- G/L CONSOLIDATION  CONVERT FROM 400 FILES       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(GLDET) TOFILE(QS36F/SS.GLPRE)

             CALL       PGM(GLR87B)

 END:        ENDPGM
