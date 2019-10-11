/*********************************************************************/
/*   PROGRAM-------- NIGHTKUBE                                       */
/*   DATE WRITTEN---  2/21/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR KUBE PAK                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

/*   CALCULATE YTD BUCKETS IN FSHIST AND FSHISTS                     */
             CALL       PGM(SAR900)

/*   REORGANIZE ORDER FILES                                          */
/*   ORGANIZE HEADER FILE                                         */
             RGZPFM     FILE(FHORDR)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)

/*   ORGANIZE DETAIL FILE                                         */
             RGZPFM     FILE(FIORDR)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)

/*   ORGANIZE ORDER CHANGE FILE                                   */
             RGZPFM     FILE(FORDCHG)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)

/*   REORGANIZE INVENTORY FILES                                      */
/*   ORGANIZE FMINVT                                                 */
             RGZPFM     FILE(FMINVT)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)

/*   ORGANIXE FMITSES                                                */
             RGZPFM     FILE(FMITSES)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)

/*   ORGANIZE FIADD                                                  */
             RGZPFM     FILE(FIADD)
             MONMSG     MSGID(CPF2981 CPF3202 CPF3135)


             ENDPGM
