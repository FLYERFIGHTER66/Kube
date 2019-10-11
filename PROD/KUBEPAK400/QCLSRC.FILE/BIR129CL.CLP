/*********************************************************************/
/*   PROGRAM-------- BIR129CL                                        */
/*   DATE WRITTEN--- 07/06/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DEPARTMENT MASTER LISTING                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR129) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR129)
             ENDPGM
