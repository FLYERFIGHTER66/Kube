/*********************************************************************/
/*   PROGRAM-------- BIR101CL                                        */
/*   DATE WRITTEN--- 06/12/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER OVERRDIES LISTING (NIGHT)                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR101) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) +
                          FORMTYPE(*NAR) SAVE(*YES)
             CALL       PGM(BIR101)
             CLRPFM     FILE(QS36F/FORDOVR)
             ENDPGM
