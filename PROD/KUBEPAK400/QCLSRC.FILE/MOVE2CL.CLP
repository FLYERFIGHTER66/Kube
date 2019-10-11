/*********************************************************************/
/*   PROGRAM-------- MOVE1CL                                        */
/*   DATE WRITTEN--- 02/03/04                                        */
/*   PROGRAMMER----- C.BUCK                                          */
/*   DESCRIPTION---- SCANNER INPUT FOR MOVE TRAYS SIGNON             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             CALL       PGM(KUBEPAK400/KUBEALLLBL) /* get library +
                          list */

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

          /* SCAN TRAYS  */
             CALL       PGM(MOV200)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             SIGNOFF

             ENDPGM
