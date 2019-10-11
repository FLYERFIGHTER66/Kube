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
/*  3/07/01 EFD MOVE TSAVE TO END                                    */
/*  5/17/01 EFD ADD NEW OPEN ORDER CALC                              */
/* 10/26/01 EFD ADD ECKE REQUIREMENTS CALC.                          */
/* 11/15/01 EFD ADD 84 TRAY ORDER ENTRY CHANGE LIST                  */
/* 12/07/01 EFD ADD BAR CODE NIGHT PROCESS                           */
/*  2/21/02 EFD ADD NIGHTKUBE TO PROCESS                             */
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

/*   CALL CUR100CL IN KUBEPAK400 LIBRARY CALC ECKE REQUIREMENTS      */
             CALL       PGM(KUBEPAK400/CUR100CL)

/*   CALL GLC401ACL IN KUBEPAK400 LIBRARY PRINT DAILY JOURNAL    */
             CALL       PGM(KUBEPAK400/GLC410ACL)

/*   CALL SAC410ACL IN KUBEPAK400 LIBRARY P.C. SALES ANALYSIS    */
         /*  CALL       PGM(KUBEPAK400/SAC410ACL)   -DNR-  B.S. 11/23/2015   */

/*   CALL CUC650CLA IN KUBEPAK400 LIBRARY 84 TRAY ORDER CHANGE   */
/*  WJB -    CALL       PGM(CUC650CLA)   {REMOVED AT REQUEST OF BILL S.}    */


             ENDPGM
