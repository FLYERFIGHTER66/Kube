/*********************************************************************/
/*   PROGRAM-------- BIR170CL                                        */
/*   DATE WRITTEN--- 11/29/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT ORDER PRICE LIST                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&FRM) TYPE(*CHAR) LEN(6)
             OVRDBF     FILE(FMORLC) TOFILE(FMORLS)
             QSYS/OVRPRTF FILE(BIR170) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) ALIGN(*NO) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR170)
 END:        ENDPGM
