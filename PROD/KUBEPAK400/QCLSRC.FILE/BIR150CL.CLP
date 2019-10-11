/*********************************************************************/
/*   PROGRAM-------- BIR150CL                                        */
/*   DATE WRITTEN--- 08/03/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT GENERAL LEDGER DEFAULTS                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&FRM) TYPE(*CHAR) LEN(6)
             QSYS/OVRPRTF FILE(BIR150) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) ALIGN(*NO) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR150)
 END:        ENDPGM
