/*********************************************************************/
/*   PROGRAM-------- BIR360CL                                        */
/*   DATE WRITTEN--- 07/30/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DOP UPDATE SHIST & MSALES FILES                 */
/*   REVISIONS------                                                 */
/*  9/01/96 EFD TAKE OVER ALL BIP360 FUNCTIONS                       */
/*********************************************************************/
             PGM
/*  OUTPUT RECORDS TO SHIPPED ORDER HISTORY FILE                     */
             QSYS/OVRPRTF FILE(BIR520) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
CALL BIR520
 END:        ENDPGM
