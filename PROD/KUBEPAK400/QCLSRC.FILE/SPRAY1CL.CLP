/*********************************************************************/
/*   PROGRAM-------- SPRAY1CL                                        */
/*   DATE WRITTEN--- 07/12/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SCANNER INPUT FOR GROWTH REGULATOR SIGNON       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             CALL       PGM(KUBEPAK400/KUBEALLLBL) /* get library +
                          list */

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

          /* SCAN TRAYS  */
             CALL       PGM(CHR100)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             SIGNOFF

             ENDPGM
