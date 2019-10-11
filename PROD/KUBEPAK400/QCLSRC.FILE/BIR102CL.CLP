/*********************************************************************/
/*   PROGRAM-------- BIR102CL                                        */
/*   DATE WRITTEN--- 06/12/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- TAG ORDERS LISTING (NIGHT)                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR102) TOFILE(QSYSPRT) PAGESIZE(66 +
                          80) LPI(6) CPI(10) ALIGN(*NO) +
                          FORMTYPE(*NAR) SAVE(*YES)
             CALL       PGM(BIR102)
             ENDPGM
