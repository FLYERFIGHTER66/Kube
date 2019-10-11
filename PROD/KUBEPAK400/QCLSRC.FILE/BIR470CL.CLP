/*********************************************************************/
/*   PROGRAM-------- BIR470CL                                        */
/*   DATE WRITTEN--- 11/14/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER LOG REPORT                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR470) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR470)
             ENDPGM
