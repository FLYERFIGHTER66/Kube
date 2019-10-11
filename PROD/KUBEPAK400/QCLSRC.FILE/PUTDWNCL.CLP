/*********************************************************************/
/*   PROGRAM-------- PUTDWNCL                                        */
/*   DATE WRITTEN---  5/18/00                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PUT DOWN REPORT                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             RUNQRY     QRY(KUBEPAK400/PUTDWNQRY) QRYFILE((*SAME)) +
                          RCDSLT(*YES)

             QSYS/OVRPRTF FILE(PUTDWN) TOFILE(*LIBL/QSYSPRT) +
                          DEV(XERPRT01) PAGESIZE(66 120) LPI(6) +
                          CPI(15) OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(PUTDWN)

 END:        ENDPGM
