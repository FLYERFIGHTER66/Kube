/*********************************************************************/
/*   PROGRAM-------- BIR160CL                                        */
/*   DATE WRITTEN--- 08/25/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRODUCT CLASS/CUSTOMER TYPE FILE LISTING        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR160) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR160)
 END:        ENDPGM
