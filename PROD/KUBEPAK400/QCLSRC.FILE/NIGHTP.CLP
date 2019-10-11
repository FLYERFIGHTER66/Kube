/*********************************************************************/
/*     IF YOU MAKE ANY CHANGES HERE MAKE THEM TO NIGHTS ALSO         */
/*********************************************************************/
/*                                                                   */
/*********************************************************************/
/*   PROGRAM-------- NIGHT                                           */
/*   DATE WRITTEN---  1/06/95                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE                               */
/*   REVISIONS------                                                 */
/*  4/25/95 EFD CHANGE TO RUN IN QCTL AND STOP QBATCH.               */
/*  7/23/99 EFD ADD GLPRE PURGECL                                    */
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

/*  RECALC ALLOCATIONS                                 */
               CALL       PGM(BIR900)
           /*  CALL       PGM(CALCALOCL)  */

 /*     RECALC LKITM FILE AFTER PROCESSING     */
             CALL       PGM(BLDLKITMCL)

             ENDPGM
