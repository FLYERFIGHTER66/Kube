/*********************************************************************/
/*   PROGRAM-------- BIR110CL                                        */
/*   DATE WRITTEN--- 05/15/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CONTRACT PRICE MASTER LISTING                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR110) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR110)
             ENDPGM
