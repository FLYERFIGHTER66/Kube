/*********************************************************************/
/*   PROGRAM-------- ICR120CL                                        */
/*   DATE WRITTEN--- 02/05/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- LOCATION FILE MASTER LIST                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRPRTF    FILE(ICR120) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(10) FORMTYPE(*NAR)

             CALL       PGM(ICR120)
             ENDPGM
