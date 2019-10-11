/*********************************************************************/
/*   PROGRAM-------- BIR185CL                                        */
/*   DATE WRITTEN--- 11/25/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ALTERNATE PRICE CODE FILE LISTING               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR185) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR185)
 END:        ENDPGM
