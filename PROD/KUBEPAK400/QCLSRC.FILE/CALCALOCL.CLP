/*********************************************************************/
/*   PROGRAM-------- CALCALOCL                                       */
/*   DATE WRITTEN--- 02/09/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- GET ALLOCATIONS                                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
                                                                             /*+
?    Zero out the Allocated Bucket on all FDLOTRD records                     */
             CALL       PGM(ZERLOTALC)
                                                                             /*+
?    Delete unneeded FALITEM records (Don't Touch Fixers)                     */
             CALL       PGM(ALALDE)
                                                                             /*+
?    Check FALITEM For Over Allocate (Processed Order by Order)               */
             CALL       PGM(ALALOV)
                                                                             /*+
?    Repopulate FDLOTRD based on recalc'd FALITEM records                     */
             CALL       PGM(ALFDL1)
                                                                             /*+
?    Repopulate FDLOTRD based on recalc'd FALITEM records                     */
             QSYS/OVRPRTF FILE(CALCALO) TOFILE(*LIBL/QSYSPRT) +
                          DEV(XERPRT01) PAGESIZE(66 85) LPI(6) CPI(10) +
                          FORMTYPE(*NAR)
             GOTO       CMDLBL(SKIP4NOW)
             CALL       PGM(ALFDL2)
 SKIP4NOW:
                                                                             /*+
?    Removed from Process                                                     */
/*           CALL       PGM(CALCALO)                                */
/*           CALL       PGM(GETFALITEM)                             */
 END:        ENDPGM
