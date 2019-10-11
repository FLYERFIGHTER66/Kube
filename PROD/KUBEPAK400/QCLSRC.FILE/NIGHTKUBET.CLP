/*********************************************************************/
/*   PROGRAM-------- NIGHTKUBE                                       */
/*   DATE WRITTEN---  2/21/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR KUBE PAK                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

/*   REORGANIZE ORDER FILES                                          */
/*   ORGANIZE HEADER FILE                                         */
             RGZPFM     FILE(FHORDR)
             MONMSG     MSGID(CPF2981)

/*   ORGANIZE DETAIL FILE                                         */
             RGZPFM     FILE(FIORDR)
             MONMSG     MSGID(CPF2981)

             ENDPGM
