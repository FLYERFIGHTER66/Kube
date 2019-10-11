/*********************************************************************/
/*   PROGRAM-------- BIR368CL                                        */
/*   DATE WRITTEN--- 12/17/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- LINE ITEMS DELETED IN SHIPMENT CONFIRMATION     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(BIR368) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR368)
             CLRPFM     FILE(FIORDDEL)
 END:        ENDPGM
