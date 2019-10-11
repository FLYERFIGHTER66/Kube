/*********************************************************************/
/*   PROGRAM-------- BIR119CL                                        */
/*   DATE WRITTEN--- 07/27/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- USER ID MASTER LISTING                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR119) TOFILE(QSYSPRT) PAGESIZE(66 +
                          132) LPI(6) CPI(10) FORMTYPE(*NAR)
             CALL       PGM(BIR119)
             ENDPGM
