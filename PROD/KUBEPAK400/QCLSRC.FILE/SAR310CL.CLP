/*********************************************************************/
/*   PROGRAM-------- SAR310CL                                        */
/*   DATE WRITTEN--- 05/30/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- TAXES BY TAX JURISDICTION                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(SAR310) TOFILE(QSYSPRT) PAGESIZE(66 +
                          132) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(SAR310)
             ENDPGM
