/*********************************************************************/
/*   PROGRAM-------- PIR300CL                                        */
/*   DATE WRITTEN--- 05/31/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- POINSETTIA SPREAD SHEET                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             CALL       PGM(PIR900)

             CALL       PGM(PIR300)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
