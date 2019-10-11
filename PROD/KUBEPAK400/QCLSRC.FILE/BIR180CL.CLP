/*********************************************************************/
/*   PROGRAM-------- BIR180CL                                        */
/*   DATE WRITTEN--- 08/24/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CUSTOMER/TYPE FILE LISTING                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR180) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR180)
 END:        ENDPGM
