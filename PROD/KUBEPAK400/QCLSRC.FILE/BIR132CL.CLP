/*********************************************************************/
/*   PROGRAM-------- BIR132CL                                        */
/*   DATE WRITTEN--- 04/04/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CUSTOMER TYPES MASTER LISTING                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR132) TOFILE(QSYSPRT) PAGESIZE(66 +
                          132) LPI(6) CPI(10) FORMTYPE(*NAR)
             CALL       PGM(BIR132)
             ENDPGM
