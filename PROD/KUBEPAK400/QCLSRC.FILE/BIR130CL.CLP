/*********************************************************************/
/*   PROGRAM-------- BIR130CL                                        */
/*   DATE WRITTEN--- 08/03/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT TAX JURISDICTION LIST                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&FRM) TYPE(*CHAR) LEN(6)
             QSYS/OVRPRTF FILE(BIR130) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR130)
 END:        ENDPGM
