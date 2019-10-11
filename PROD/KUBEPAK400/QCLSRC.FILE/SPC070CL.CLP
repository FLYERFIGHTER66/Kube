/*********************************************************************/
/*   PROGRAM-------- SPC020CL                                        */
/*   DATE WRITTEN---  2/11/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- UPDATE FIXERS BY SELECTED WEEK                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/OVRPRTF FILE(SPC070) TOFILE(*LIBL/P1) +
                          DEV(XERPRT01) PAGESIZE(66 85) LPI(6) +
                          CPI(10) OVRFLW(60) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(SPC070)
 END:        ENDPGM
