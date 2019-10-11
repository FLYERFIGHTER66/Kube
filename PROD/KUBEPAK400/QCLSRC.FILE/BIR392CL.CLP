/*********************************************************************/
/*   PROGRAM-------- BIR392CL                                        */
/*   DATE WRITTEN--- 09/27/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY CUSTOMER -SUMMARY                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR392) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR392)
 END:        ENDPGM
