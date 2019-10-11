/*********************************************************************/
/*   PROGRAM-------- BIR165CL                                        */
/*   DATE WRITTEN--- 04/05/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRODUCT CLASS 3 DISCOUNT FILE LISTING           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR165) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR165)
 END:        ENDPGM
