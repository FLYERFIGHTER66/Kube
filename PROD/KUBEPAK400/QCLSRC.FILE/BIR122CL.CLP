/*********************************************************************/
/*   PROGRAM-------- BIR122CL                                        */
/*   DATE WRITTEN--- 04/20/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRODUCT CLASS MASTER LISTING                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             OVRPRTF    FILE(BIR122) TOFILE(QSYSPRT) PAGESIZE(66 +
                          80) LPI(6) CPI(10) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR122)
             ENDPGM
